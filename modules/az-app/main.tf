terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "2.23.1"
    }
    random = {
      source = "hashicorp/random"
    }
  }
}

resource "docker_image" "az-app" {
	name = "az-image"
}

resource "docker_container" "az-app" {
  count                 = var.project_details["nodes"]
  #image                 = var.project_details["image"]
  image                 = docker_image.az-app.image_id
  name                  = "${var.project_details["name"]}-${count.index}"
  destroy_grace_seconds = 120
  must_run              = true
  restart               = "always"

  networks_advanced {
    name    = var.project_details["name"]
    aliases = [var.project_details["name"]]
  }

  ports {
    internal = var.project_details["port"]
    # external = "88${count.index}"
  }
  labels {
    label = "1"
    value = "one"
  }

  labels {
    label = "traefik.enable"
    value = "true"
  }


  labels {
    label = "traefik.http.services.${var.project_details["name"]}.loadbalancer.server.port"
    value = var.project_details["port"]
  }

  labels {
    label = "traefik.http.routers.${var.project_details["name"]}.rule"
    value = "Host(`${var.project_details["domain"]}`) && Path(`${var.project_details["path"]}`)"
  }

  labels {
    label = "traefik.http.routers.${var.project_details["name"]}.tls"
    value = false
  }

  labels {
    label = "traefik.http.routers.${var.project_details["name"]}.entrypoints"
    value = "https"
  }

  labels {
    label = "traefik.http.routers.${var.project_details["name"]}.middlewares"
    value = "${var.project_details["name"]}-stripprefix"
  }

  labels {
    label = "traefik.http.middlewares.${var.project_details["name"]}-stripprefix.stripprefix.prefixes"
    value = var.project_details["path"]
  }

}

