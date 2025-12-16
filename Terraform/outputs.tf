output "ec2_public_ip" {
  value = aws_instance.wordpress_server.public_ip
}

output "rds_endpoint" {
  value = aws_db_instance.wordpress_db.address
}

