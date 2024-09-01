variable "stage" {
    type  = string
}
variable "servicename" {
    type  = string
}
variable "tags" {
  type = map(string)
  default = {
    "name" = "crider-alb"
  }
}

variable "internal" {
    type  = bool
    default = true
}

variable "public" {
    type  = bool
    default = false
}

variable "subnet_ids" {
    type  = list
}

variable "aws_s3_lb_logs_name" {
    type  = string
}
variable "idle_timeout" {
    type  = string
    default = "60"
}
# variable "certificate_arn" {
#     type  = string
# }
variable "port" {
    type  = string
    default = "80"
}
variable "vpc_id" {
    type  = string
}
variable "instance_ids" {
    type  = list
    default = []
}
variable "domain" {
    type  = string
    default = ""
}
variable "hostzone_id" {
    type  = string
    default = ""
}
variable "hc_path" {
    type  = string
    default = "/"
}
variable "hc_healthy_threshold" {
    type  = number
    default = 5
}
variable "hc_unhealthy_threshold" {
    type  = number
    default = 2
}
variable "sg_allow_comm_list" {
    type = list
}
variable "target_type" {
    type = string
    default = "ip"
}
variable "availability_zone" {
    type = string
    default = ""
}

variable "logs_id" {
    type = string
    default = ""
}

variable "cert_domain" {
    type = string
    default = ""
}

