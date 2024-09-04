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
  default = "ap-northeast-2"
}

variable "az" {
  description = "Name of the az"
  type = list
  default = ["ap-northeast-2a", "ap-northeast-2b", "ap-northeast-2c"]
}

