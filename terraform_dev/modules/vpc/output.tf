# output "network-vpc" {
#   value = aws_vpc.aws-vpc
# }

# output "public-az1" {
#   value = aws_subnet.public-az1
# }

# output "private-az1" {
#   value = aws_subnet.private-az1
# }

# output "vpc_id" {
#   value = aws_vpc.aws-vpc.id
# }
# output "vpc_cidr" {
#   value = aws_vpc.aws-vpc.cidr_block
# }
# output "nat_ip" {
#   value = aws_eip.nat-eip.public_ip
# }
# output "nat_id" {
#   value = aws_nat_gateway.vpc-nat.id
# }
# output "pub_rt_id" {
#   value = aws_route_table.aws-rt-pub.id
# }
# output "pri_rt_id" {
#   value = aws_route_table.aws-rt-pri.id
# }
output "vpc_id" {
  value = aws_vpc.aws-vpc.id
}

# output "public_subnet_ids" {
#   value = [
#     aws_subnet.public-az1.id,
#     aws_subnet.public-az2.id,
#     aws_subnet.public-az3.id
#   ]
# }

output "public_subnet_id" {
  value = aws_subnet.public-az1.id

}

output "private_subnet_ids" {
  value = [
    aws_subnet.private-az1.id,
    aws_subnet.private-az2.id,
    aws_subnet.private-az3.id
  ]
}

output "db_subnet_ids" {
  value = [
    aws_subnet.db-az1.id,
    aws_subnet.db-az2.id,
    aws_subnet.db-az3.id
  ]
}

output "public_route_table_id" {
  value = aws_route_table.aws-rt-pub.id
}

output "private_route_table_id" {
  value = aws_route_table.aws-rt-pri.id
}
