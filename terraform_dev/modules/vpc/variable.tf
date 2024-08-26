# Comm TAG
variable "tags" {
  type = map(string)
  description = "Map of tags to assign to resources"
}

variable "stage" {
  type = string
  description = "Deployment stage (e.g., dev, prod)"
}

variable "servicename" {
  type = string
  description = "Name of the service"
}

# VPC CIDR Block
variable "vpc_ip_range" {
  type = string
  description = "CIDR block for the VPC"
}

# Availability Zones
variable "az" {
  type = list(string)
  description = "List of Availability Zones to use"
}

# Public Subnets
variable "subnet_public_az1" {
  type = string
  description = "CIDR block for the public subnet in AZ1"
}

# variable "subnet_public_az2" {
#   type = string
#   description = "CIDR block for the public subnet in AZ2"
# }

# variable "subnet_public_az3" {
#   type = string
#   description = "CIDR block for the public subnet in AZ3"
# }

# Private Subnets
variable "subnet_private_az1" {
  type = string
  description = "CIDR block for the private subnet in AZ1"
}

variable "subnet_private_az2" {
  type = string
  description = "CIDR block for the private subnet in AZ2"
}

variable "subnet_private_az3" {
  type = string
  description = "CIDR block for the private subnet in AZ3"
}

# RDS Subnets
variable "subnet_db_az1" {
  type = string
  description = "CIDR block for the RDS subnet in AZ1"
}

variable "subnet_db_az2" {
  type = string
  description = "CIDR block for the RDS subnet in AZ2"
}

variable "subnet_db_az3" {
  type = string
  description = "CIDR block for the RDS subnet in AZ3"
}
