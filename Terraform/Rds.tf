resource "aws_db_subnet_group" "rds_subnets" {
  name = "rds-subnet-group"

  subnet_ids = [
    aws_subnet.private_subnet.id,
    aws_subnet.public_subnet.id
  ]
}

resource "aws_db_instance" "wordpress_db" {
  allocated_storage      = 20
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = "db.t3.micro"

  db_name     = var.db_name
  username    = var.db_username
  password    = var.db_password

  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  db_subnet_group_name   = aws_db_subnet_group.rds_subnets.name

  publicly_accessible = false
  skip_final_snapshot = true

  tags = { Name = "wordpress-rds" }
}

