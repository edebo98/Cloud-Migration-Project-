# data.tf

# Dynamically get the latest Amazon Linux 2 AMI
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

# Get the current AWS account ID for unique S3 bucket names
data "aws_caller_identity" "current" {}
