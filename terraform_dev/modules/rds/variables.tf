# variable "name_prefix" {
#   description = "Prefix for resource names"
#   type        = string
# }

variable "servicename" {
  type = string
  description = "Name of the service"
}

variable "subnet_ids" {
  description = "List of subnet IDs for the RDS instance"
  type        = list(string)
}

variable "db_instance_identifier" {
  description = "Unique identifier for the RDS instance"
  type        = string
}

variable "engine_version" {
  description = "The version of the database engine to use"
  type        = string
  default     = "8.0.35"
}

variable "allocated_storage" {
  description = "The allocated storage for the RDS instance (in GB)"
  type        = number
  default     = 100
}

variable "instance_class" {
  description = "The instance type for the RDS instance"
  type        = string
  default     = "db.m5.large"
}

variable "multi_az" {
  description = "Deploy the RDS instance in multiple Availability Zones"
  type        = bool
  default     = true
}

variable "master_username" {
  description = "The master username for the database"
  type        = string
}

variable "master_password" {
  description = "The master password for the database"
  type        = string
}

variable "tags" {
  description = "Tags to assign to resources"
  type        = map(string)
  default     = {}
}
variable "db_name" {
  description = "The NAME of the DB"
  type        = string
}

# variable "allowed_cidrs" {
#   description = ""
#   type        = string
# }
#?
variable "vpc_id" {
  description = "The ID of the VPC where the security group will be created"
  type        = string
}

