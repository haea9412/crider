variable "stage" {
  type = string
  description = "Deployment stage (e.g., dev, prod)"
  default = "development"
}

variable "servicename" {
  type = string
  description = "Name of the service"
  default = "crider-service"
}

variable "region" {
  description = "Name of the region"
  type = string
  default = "ap-southeast-2"
}

variable "az" {
  description = "Name of the az"
  type = list
  default = ["ap-southeast-2a", "ap-southeast-2b", "ap-southeast-2c"]
}

