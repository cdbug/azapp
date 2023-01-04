variable "app_nodes" {
  type = number
  default = 3
}

variable "traefik_network_attachable" {
  type        = bool
  description = "Make the default Traefik network attachable?"
  default     = false
}

variable "networks" {
  type        = list(string)
  description = "List of networks to connect Traefik to."
  default     = ["traefik"]
}

variable "le_url" {

  type = map(string)

}

variable "project_details" {
  type  = map(any)
}