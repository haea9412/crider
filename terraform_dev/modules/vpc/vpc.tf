# VPC 생성
resource "aws_vpc" "aws-vpc" {
  cidr_block           = var.vpc_ip_range
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = merge(tomap({
         Name = "aws-vpc-${var.stage}-${var.servicename}"}), 
        var.tags)
}

# 퍼블릭 서브넷 - AZ1
resource "aws_subnet" "public-az1" {
  vpc_id                  = aws_vpc.aws-vpc.id
  cidr_block              = var.subnet_public_az1
  map_public_ip_on_launch = true
  availability_zone       = element(var.az, 0)
  tags = {
    Name = "aws-subnet-pub-az1"
    "kubernetes.io/role/elb" = "1"
  }
  depends_on = [aws_vpc.aws-vpc]
}

# 퍼블릭 서브넷 - AZ2
resource "aws_subnet" "public-az2" {
  vpc_id                  = aws_vpc.aws-vpc.id
  cidr_block              = var.subnet_public_az2
  map_public_ip_on_launch = true
  availability_zone       = element(var.az, 1)
  tags = {
    Name = "aws-subnet-pub-az2"
    "kubernetes.io/role/elb" = "1"
  }
  depends_on = [aws_vpc.aws-vpc]
}

# 퍼블릭 서브넷 - AZ3
resource "aws_subnet" "public-az3" {
  vpc_id                  = aws_vpc.aws-vpc.id
  cidr_block              = var.subnet_public_az3
  map_public_ip_on_launch = true
  availability_zone       = element(var.az, 2)
  tags = {
    Name = "aws-subnet-pub-az3"
    "kubernetes.io/role/elb" = "1"
  }
  depends_on = [aws_vpc.aws-vpc]
}

# 프라이빗 서브넷 - AZ1
resource "aws_subnet" "private-az1" {
  vpc_id                  = aws_vpc.aws-vpc.id
  cidr_block              = var.subnet_private_az1
  map_public_ip_on_launch = false
  availability_zone       = element(var.az, 0)
  tags = {
    Name = "aws-subnet-pri-az1"
    "kubernetes.io/role/internal-elb" = "1"
  }
  depends_on = [aws_vpc.aws-vpc]
}

# 프라이빗 서브넷 - AZ2
resource "aws_subnet" "private-az2" {
  vpc_id                  = aws_vpc.aws-vpc.id
  cidr_block              = var.subnet_private_az2
  map_public_ip_on_launch = false
  availability_zone       = element(var.az, 1)
  tags = {
    Name = "aws-subnet-pri-az2"
    "kubernetes.io/role/internal-elb" = "1"
  }
  depends_on = [aws_vpc.aws-vpc]
}

# 프라이빗 서브넷 - AZ3
resource "aws_subnet" "private-az3" {
  vpc_id                  = aws_vpc.aws-vpc.id
  cidr_block              = var.subnet_private_az3
  map_public_ip_on_launch = false
  availability_zone       = element(var.az, 2)
  tags = {
    Name = "aws-subnet-pri-az3"
    "kubernetes.io/role/internal-elb" = "1"
  }
       
  depends_on = [aws_vpc.aws-vpc]
}

# RDS용 프라이빗 서브넷 - AZ1
resource "aws_subnet" "db-az1" {
  vpc_id                  = aws_vpc.aws-vpc.id
  cidr_block              = var.subnet_db_az1
  map_public_ip_on_launch = false
  availability_zone       = element(var.az, 0)
  tags = merge(tomap({
         Name = "aws-subnet-${var.stage}-${var.servicename}-db-az1"}), 
        var.tags)
  depends_on = [aws_vpc.aws-vpc]
}

# RDS용 프라이빗 서브넷 - AZ2
resource "aws_subnet" "db-az2" {
  vpc_id                  = aws_vpc.aws-vpc.id
  cidr_block              = var.subnet_db_az2
  map_public_ip_on_launch = false
  availability_zone       = element(var.az, 1)
  tags = merge(tomap({
         Name = "aws-subnet-${var.stage}-${var.servicename}-db-az2"}), 
        var.tags)
  depends_on = [aws_vpc.aws-vpc]
}

# RDS용 프라이빗 서브넷 - AZ3
resource "aws_subnet" "db-az3" {
  vpc_id                  = aws_vpc.aws-vpc.id
  cidr_block              = var.subnet_db_az3
  map_public_ip_on_launch = false
  availability_zone       = element(var.az, 2)
  tags = merge(tomap({
         Name = "aws-subnet-${var.stage}-${var.servicename}-db-az3"}), 
        var.tags)
  depends_on = [aws_vpc.aws-vpc]
}

# 퍼블릭 라우트 테이블
resource "aws_route_table" "aws-rt-pub" {
  vpc_id = aws_vpc.aws-vpc.id
  tags = merge(tomap({
         Name = "aws-rt-${var.stage}-${var.servicename}-pub"}), 
        var.tags)
}

# 프라이빗 라우트 테이블
resource "aws_route_table" "aws-rt-pri" {
  vpc_id = aws_vpc.aws-vpc.id
  tags = merge(tomap({
         Name = "aws-rt-${var.stage}-${var.servicename}-pri"}), 
        var.tags)
}

# 프라이빗 RDS 라우트 테이블
resource "aws_route_table" "aws-rt-pri-rds" {
  vpc_id = aws_vpc.aws-vpc.id
  tags = merge(tomap({
         Name = "aws-rt-${var.stage}-${var.servicename}-pri-rds"}), 
        var.tags)
}


# 퍼블릭 서브넷과 퍼블릭 라우트 테이블 연동
resource "aws_route_table_association" "public-az1" {
  subnet_id      = aws_subnet.public-az1.id
  route_table_id = aws_route_table.aws-rt-pub.id
}

resource "aws_route_table_association" "public-az2" {
  subnet_id      = aws_subnet.public-az2.id
  route_table_id = aws_route_table.aws-rt-pub.id
}

resource "aws_route_table_association" "public-az3" {
  subnet_id      = aws_subnet.public-az3.id
  route_table_id = aws_route_table.aws-rt-pub.id
}

# 프라이빗 서브넷과 프라이빗 라우트 테이블 연동
resource "aws_route_table_association" "private-az1" {
  subnet_id      = aws_subnet.private-az1.id
  route_table_id = aws_route_table.aws-rt-pri.id
}

resource "aws_route_table_association" "private-az2" {
  subnet_id      = aws_subnet.private-az2.id
  route_table_id = aws_route_table.aws-rt-pri.id
}

resource "aws_route_table_association" "private-az3" {
  subnet_id      = aws_subnet.private-az3.id
  route_table_id = aws_route_table.aws-rt-pri.id
}

# RDS용 프라이빗 서브넷과 프라이빗 RDS 라우트 테이블 연동
resource "aws_route_table_association" "db-az1" {
  subnet_id      = aws_subnet.db-az1.id
  route_table_id = aws_route_table.aws-rt-pri-rds.id
}

resource "aws_route_table_association" "db-az2" {
  subnet_id      = aws_subnet.db-az2.id
  route_table_id = aws_route_table.aws-rt-pri-rds.id
}

resource "aws_route_table_association" "db-az3" {
  subnet_id      = aws_subnet.db-az3.id
  route_table_id = aws_route_table.aws-rt-pri-rds.id
}

# 인터넷 게이트웨이
resource "aws_internet_gateway" "vpc-igw" {
  vpc_id = aws_vpc.aws-vpc.id
  tags = merge(tomap({
         Name = "aws-igw-${var.stage}-${var.servicename}"}), 
        var.tags)
}

# NAT 게이트웨이용 EIP
resource "aws_eip" "nat-eip" {
  domain = "vpc"
  tags = merge(tomap({
         Name = "aws-eip-${var.stage}-${var.servicename}-nat"}), 
        var.tags)
}

# NAT 게이트웨이 - 퍼블릭 서브넷 AZ1
resource "aws_nat_gateway" "nat-az1" {
  allocation_id = aws_eip.nat-eip.id
  subnet_id     = aws_subnet.public-az1.id
  depends_on    = [aws_internet_gateway.vpc-igw]
  tags = merge(tomap({
         Name = "aws-nat-${var.stage}-${var.servicename}-az1"}), 
        var.tags)
}

# 퍼블릭 라우트 테이블에 인터넷 게이트웨이와 연결
resource "aws_route" "route-to-igw" {
  route_table_id         = aws_route_table.aws-rt-pub.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.vpc-igw.id
}

# 프라이빗 라우트 테이블에 NAT 게이트웨이와 연결
resource "aws_route" "route-to-nat-az1" {
  route_table_id         = aws_route_table.aws-rt-pri.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat-az1.id
}
