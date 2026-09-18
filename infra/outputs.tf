output "raw_bucket_name" {
  value = aws_s3_bucket.raw.bucket
}

output "processed_bucket_name" {
  value = aws_s3_bucket.processed.bucket
}

output "ingestion_lambda_name" {
  value = aws_lambda_function.ingestion.function_name
}

output "glue_database_name" {
  value = aws_glue_catalog_database.this.name
}
