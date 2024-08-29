provider "aws" {
  region = var.region 
}

terraform {
  required_version = ">= 1.0.0, < 2.0.0"

  backend "s3" {
    bucket         = "crider-terraform-develop"
    key            = "dev/terraform-ci/terraform.tfstate"
    region         = "ap-southeast-2"
    encrypt        = true
    dynamodb_table = "crider-terraform-develop"

  }
  
}


module "vpc" {
  source = "./modules/vpc"  
  
  vpc_ip_range         = "192.168.20.0/24"
  az                   = var.az
  subnet_public_az1    = "192.168.20.0/28"
  # subnet_public_az2    = "192.168.20.16/28"
  # subnet_public_az3    = "192.168.20.32/28"
  subnet_private_az1   = "192.168.20.128/28"
  subnet_private_az2   = "192.168.20.144/28"
  subnet_private_az3   = "192.168.20.160/28"
  subnet_db_az1        = "192.168.20.176/28"
  subnet_db_az2        = "192.168.20.192/28"
  subnet_db_az3        = "192.168.20.208/28"

  tags = {
    "Environment" = "dev"      
    "Project"     = "test"   
  }
 
  stage       = var.stage  
  servicename = var.servicename 
}



module "rds" {
  source = "./modules/rds"
  vpc_id = module.vpc.vpc_id
  servicename             = var.servicename
  db_instance_identifier  = "rds-crider" 
  subnet_ids               = module.vpc.db_subnet_ids
  engine_version          = "8.0"
  instance_class          = "db.t3.micro"
  master_username         = "admin"
  master_password         = "password123"
  db_name                 = "cirderdb"
  #allowed_cidrs           = module.vpc.public_subnet_ids

}

module "eks" {
  source = "./modules/eks"  
  servicename             = var.servicename 
  private_subnet_ids      = module.vpc.private_subnet_ids
  

}

# # ECR 리포지토리 생성
module "ecr" {
  source = "./modules/ecr"
  # ecr_allow_account_arns  = ["arn:aws:iam::381492185710:user/010510", "arn:aws:iam::381492185710:user/950418"]  
  ecr_allow_account_arns  = ["arn:aws:iam::795149720653:user/950418", "arn:aws:iam::795149720653:user/010510"]  
  image_tag_mutability    = "IMMUTABLE"  
  image_scan_on_push      = true  
  stage                   = var.stage
  servicename             = var.servicename  
  tags                    = {
    "Environment" = "development"
    "Service"     = "service"
  }
}


module "alb" {
  source = "./modules/alb"
  cert_domain = ""
  aws_s3_lb_logs_name = module.alb.state_logs.id
  # certificate_arn = module.alb.cert.arn
  instance_ids = [module.eks.nodegroups.id]
  vpc_id = module.vpc.vpc_id
  sg_allow_comm_list = ["0.0.0.0/0"]

}