variable "servicename" {
  description = "Name of the service"
  type = string
}

# variable "cluster_name" {
#   description = "Name of the cluster"
#   type    = string
# }

variable "private_subnet_ids" {
  type    = list
}