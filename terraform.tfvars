app_nodes = 3

le_url = {
  prod = "https://acme-v02.api.letsencrypt.org/directory"
  test = "https://acme-staging-v02.api.letsencrypt.org/directory"
}

project_details = {
  domain = "az.stanchev.info"
  nodes = 3
  image = "az-image"
  name  = "azapp"
  port  = 8888
  path  = "/api/ping"
}