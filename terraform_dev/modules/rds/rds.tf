resource "aws_db_subnet_group" "db_subnet_group" {
  name        = "${var.servicename}-db-subnet-group"
  subnet_ids  = var.subnet_ids
  tags = merge(tomap({
         Name = "${var.servicename}-db-subnet-group"}), 
        var.tags)
}

resource "aws_db_instance" "db_instance" {
  identifier        = var.db_instance_identifier
  allocated_storage = var.allocated_storage
  engine            = "mysql"
  engine_version    = var.engine_version
  instance_class    = var.instance_class
  db_subnet_group_name = aws_db_subnet_group.db_subnet_group.name
  multi_az          = var.multi_az
  publicly_accessible = false
  vpc_security_group_ids   = [aws_security_group.db_security_group.id]
  db_name              = var.db_name


  # Master Credentials
  username = var.master_username
  password = var.master_password

  # Backup & Maintenance
  backup_retention_period = 7
  maintenance_window      = "Sun:00:00-Sun:03:00"
  auto_minor_version_upgrade = true

  # Tags
  tags = merge(tomap({
         Name = "${var.servicename}-db-instance"}), 
        var.tags)

  # Optional settings
  storage_type            = "gp2"
  storage_encrypted       = true
  final_snapshot_identifier = "${var.db_instance_identifier}-final-snapshot"

  depends_on = [aws_db_subnet_group.db_subnet_group, aws_security_group.db_security_group]
}




resource "aws_security_group" "db_security_group" {
  name        = "${var.servicename}-db-security-group"
  description = "Security group for RDS instance"
  vpc_id      = var.vpc_id

  // 인바운드 규칙 설정
  ingress {
    from_port   = 3306 # MySQL 기본 포트
    to_port     = 3306
    protocol    = "tcp"
    #cidr_blocks = var.allowed_cidrs
    cidr_blocks = ["0.0.0.0/0"]
    # cidr_blocks = var.allowed_cidrs # 접근 허용 CIDR 블록
  }

  // 아웃바운드 규칙 설정
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(tomap({
         Name = "${var.servicename}-db-security-group"}), 
        var.tags)
}

