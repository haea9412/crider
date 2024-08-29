output "sg_alb_to_tg_id" {
  value = aws_security_group.sg-alb-to-tg.id
}
output "alb_dns_name" {
  value = aws_lb.alb.dns_name
}
output "alb_zone_id" {
  value = aws_lb.alb.zone_id
}

output "state_logs" {
  value = aws_s3_bucket.state_logs
}

output "cert" {
  value = aws_acm_certificate.cert.arn
}