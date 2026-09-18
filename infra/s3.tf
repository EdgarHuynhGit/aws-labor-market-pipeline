# Raw landing zone: unmodified API responses, one object per ingestion run
resource "aws_s3_bucket" "raw" {
  bucket = "${var.project_name}-raw-${var.environment}"
}

resource "aws_s3_bucket_public_access_block" "raw" {
  bucket                  = aws_s3_bucket.raw.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Processed zone: cleaned, partitioned Parquet output from the Glue job
resource "aws_s3_bucket" "processed" {
  bucket = "${var.project_name}-processed-${var.environment}"
}

resource "aws_s3_bucket_public_access_block" "processed" {
  bucket                  = aws_s3_bucket.processed.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Glue needs a scratch bucket for crawler/job temp files and script storage
resource "aws_s3_bucket" "glue_assets" {
  bucket = "${var.project_name}-glue-assets-${var.environment}"
}
