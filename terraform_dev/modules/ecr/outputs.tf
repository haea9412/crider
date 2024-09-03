# output "repository_arn" {
#   value = {
#     for name, repository in aws_ecr_repository.ecr-repository : name => repository.arn
#   }
# }
# output "repository_url" {
#   value = {
#     for name, repository in aws_ecr_repository.ecr-repository : name => repository.repository_url
#   }
# }

output "repository_arn" {
  value = aws_ecr_repository.ecr-repository.arn
}

output "repository_url" {
  value = aws_ecr_repository.ecr-repository.repository_url
}
