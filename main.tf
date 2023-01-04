resource "random_string" "random" {
  length           = 8
  special          = false
  override_special = "/@£$"
}

resource "null_resource" "docker-image" {
  provisioner "local-exec" {

    command = "/bin/bash ./files/docker-image.sh"
  }
}

resource "docker_network" "deployment" {
  name   = var.project_details["name"]
  driver = "bridge"
  depends_on = [
    null_resource.docker-image
  ]
}

module "loadbalancer" {

  source          = "./modules/loadbalancer"
  project_details = var.project_details
  depends_on = [
    docker_network.deployment
  ]

}

module "az-app" {

  source          = "./modules/az-app"
  app_nodes       = var.project_details["nodes"]
  project_details = var.project_details
  depends_on  = [
    module.loadbalancer
  ]

}


