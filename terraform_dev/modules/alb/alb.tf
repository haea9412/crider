##ALB
resource "aws_lb" "alb" {
  name               = "aws-alb-${var.servicename}"
  internal           = var.internal
  load_balancer_type = "application"
  security_groups    = [aws_security_group.sg-alb.id]
  subnets            = var.subnet_ids

  enable_deletion_protection = false

  idle_timeout = var.idle_timeout

  access_logs {
    bucket  = "crider-lb-logs"
    prefix  = "dev"
    enabled = true
  }

  tags = merge(tomap({
         Name =  "aws-alb-${var.stage}-${var.servicename}"}),
        var.tags)
  
  depends_on = [aws_s3_bucket.state_logs]

  
}

resource "aws_acm_certificate" "cert" {
  domain_name       = "back.mangooopeach.store"
  validation_method = "DNS"
}

# 인증서 검증을 위한 Route 53 레코드
resource "aws_route53_record" "cert_validation_records" {
  for_each = { for idx, option in tolist(aws_acm_certificate.cert.domain_validation_options) : idx => option }

  zone_id = "Z02544243U0HTDIMXTAD"
  name    = each.value.resource_record_name
  type    = each.value.resource_record_type
  ttl     = 60
  records = [each.value.resource_record_value]
}

# 인증서 검증 리소스
resource "aws_acm_certificate_validation" "cert_validation" {
  certificate_arn = aws_acm_certificate.cert.arn
  validation_record_fqdns = [
    for record in aws_route53_record.cert_validation_records : record.fqdn
  ]
}

# Route 53 레코드 - ALB를 도메인에 매핑
resource "aws_route53_record" "alb-record" {

  depends_on = [aws_lb.alb]
  name    = "back.mangooopeach.store" 
  zone_id = "Z02544243U0HTDIMXTAD"
  type    = "A"
  alias {
    name                   = aws_lb.alb.dns_name
    zone_id                = aws_lb.alb.zone_id
    evaluate_target_health = true
  }
}

resource "aws_lb_listener" "lb-listener-443" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   =  aws_acm_certificate.cert.arn 

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.lb-target-group.arn
  }
  tags = var.tags
  depends_on =[aws_lb_target_group.lb-target-group]
}

resource "aws_lb_listener" "lb-listener-80" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
  tags = var.tags
}


resource "aws_lb_target_group" "lb-target-group" {
  name     = "aws-alb-tg-${var.servicename}"
  port     = var.port
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  target_type = var.target_type
  health_check {
    path = var.hc_path
    healthy_threshold   = var.hc_healthy_threshold
    unhealthy_threshold = var.hc_unhealthy_threshold
  }
  tags = merge(tomap({
         Name =  "aws-alb-tg-${var.stage}-${var.servicename}"}),
        var.tags)
}


#alb sg
resource "aws_security_group" "sg-alb" {
  name   = "aws-sg-${var.stage}-${var.servicename}-alb"
  vpc_id = var.vpc_id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "TCP"
    cidr_blocks = var.sg_allow_comm_list
    description = ""
    self        = true
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "TCP"
    cidr_blocks = var.sg_allow_comm_list
    description = ""
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = merge(tomap({
         Name = "aws-sg-${var.stage}-${var.servicename}-alb"}), 
        var.tags)
}

resource "aws_security_group" "sg-alb-to-tg" {
  name   = "aws-sg-${var.stage}-${var.servicename}-alb-to-tg"
  vpc_id = var.vpc_id

  ingress {
    from_port   = var.port
    to_port     = var.port
    protocol    = "TCP"
    security_groups = [aws_security_group.sg-alb.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = merge(tomap({
         Name = "aws-sg-${var.stage}-${var.servicename}-alb-to-tg"}), 
        var.tags)
}




#logs s3

resource "aws_s3_bucket" "state_logs" {
  bucket = "crider-lb-logs"
  
}
resource "aws_s3_bucket_policy" "state_logs_policy" {
  bucket = aws_s3_bucket.state_logs.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
        {
        Effect    = "Allow",
        Principal = {
          AWS = "arn:aws:iam::600734575887:root"  // 자신의 AWS 계정 ID
        },
        Action    = "s3:PutObject",
        Resource  = "arn:aws:s3:::${aws_s3_bucket.state_logs.id}/dev/*"
      },
      {
        Effect    = "Allow",
        Principal = {
          Service = "logdelivery.elb.amazonaws.com"  // ALB의 로그 전달 서비스
        },
        Action    = "s3:GetBucketAcl",
        Resource  = "arn:aws:s3:::${aws_s3_bucket.state_logs.id}"  // 버킷 ARN
      }
    ]
  })
}


resource "aws_s3_bucket_versioning" "enabled" { 
  bucket = aws_s3_bucket.state_logs.id 
  versioning_configuration {
    status = "Enabled"
  }


}
resource "aws_s3_bucket_server_side_encryption_configuration" "default" { 
  bucket = aws_s3_bucket.state_logs.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}
resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket = aws_s3_bucket.state_logs.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = false
  restrict_public_buckets = false
}





# resource "aws_acm_certificate_validation" "api" {
#   certificate_arn         = aws_acm_certificate.cert.arn
#   validation_record_fqdns = [for record in aws_route53_record.api_validation : record.fqdn]
# }

