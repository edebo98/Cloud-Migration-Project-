

resource "aws_s3_bucket" "migration_bucket" {
  bucket        = "migration-bucket-${data.aws_caller_identity.current.account_id}-${var.aws_region}"
  force_destroy = true

  tags = {
    Name = "migration-bucket-${data.aws_caller_identity.current.account_id}-${var.aws_region}"
  }
}

resource "aws_s3_bucket_public_access_block" "migration_bucket_block" {
  bucket = aws_s3_bucket.migration_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}


