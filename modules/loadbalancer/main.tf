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
resource "docker_image" "traefik" {
  name = "traefik:v2.6"
}


resource "random_string" "random" {
  length           = 16
  special          = true
  override_special = "/@£$"
}

resource "docker_container" "traefik" {

  image    = docker_image.traefik.image_id
  name     = "loadbalancer"
  must_run = true
  restart  = "always"

  networks_advanced {
    name    = var.project_details["name"]
    aliases = [var.project_details["name"]]
  }

  ports {
    internal = 80
    external = 80
    protocol = "tcp"
  }

  ports {
    internal = 443
    external = 443
    protocol = "tcp"
  }

  ports {
    internal = 8080
    external = 8080
    protocol = "tcp"
  }

    ports {
    internal = 8082
    external = 8082
    protocol = "tcp"
  }

  labels {
    label = "traefik.enable"
    value = true
  }

  command = [
      "--api",
      "--api.dashboard=true",
      "--accesslog=true",
      "--providers.docker",
      "--entryPoints.http.address=:80",
      "--entryPoints.https.address=:443",
      "--entrypoints.https.http.tls=true",
      "--providers.docker=true",
      "--providers.docker.exposedbydefault=false",
      "--entrypoints.http.http.redirections.entrypoint.to=https",
      "--entrypoints.http.http.redirections.entrypoint.scheme=https",
  ]


  labels {
    label = "traefik.frontend.rule"
    value = "Host:traefik.localhost"
  }

  labels {
    label = "traefik.port"
    value = 8080
  }

  labels {
    label = "traefik.http.routers.api.rule"
    value = "Host(`traefik.localhost`)"
  }

  labels {
    label = "traefik.http.routers.api.entrypoints"
    value = "https"
  }

  labels {
    label = "traefik.http.routers.api.service"
    value = "api@internal"
  }

  labels {
    label = "traefik.http.routers.api.tls"
    value = false
  }

  labels {
    label = "traefik.http.routers.dashboard.rule"
    value = "Host(`traefik.localhost`) && PathPrefix(`/dashboard`)"
  }

  labels {
    label = "traefik.http.routers.dashboard.tls"
    value = "true"
  }


  labels {
    label = "traefik.http.routers.dashboard.entrypoints"
    value = "https"
  }

  labels {
    label = "traefik.http.routers.dashboard.service"
    value = "api@internal"
  }

  labels {
    label = "entryPoints.https.tls.certificates.certFile"
    value = "/var/run/certificates/cert.pem"
  }

  labels {
    label = "entryPoints.https.tls.certificates.keyFile"
    value = "/var/run/certificates/self-cert.pem"
  }


  labels {
    label = "traefik.http.middlewares.https_redirect.redirectscheme.scheme"
    value = "https"
  }

  labels {
    label = "traefik.http.middlewares.https_redirect.redirectscheme.permanent"
    value = true
  }

  mounts {
    target    = "/var/run/docker.sock"
    source    = "/var/run/docker.sock"
    type      = "bind"
    read_only = true

  }

  mounts {
    target    = "/var/run/certificates"
    source    = "${abspath(path.root)}/files/certificates"
    type      = "bind"
    read_only = true

  }

}