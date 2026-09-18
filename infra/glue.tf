resource "aws_glue_catalog_database" "this" {
  name = replace("${var.project_name}_db", "-", "_")
}

resource "aws_glue_crawler" "processed" {
  name          = "${var.project_name}-processed-crawler"
  role          = aws_iam_role.glue_service.arn
  database_name = aws_glue_catalog_database.this.name

  s3_target {
    path = "s3://${aws_s3_bucket.processed.bucket}/"
  }

  # Run manually to start; switch to a schedule once the ETL job is stable
  # schedule = "cron(0 6 * * ? *)"
}

# NOTE: the actual transform job (etl/glue_job.py) is uploaded to
# aws_s3_bucket.glue_assets and referenced by an aws_glue_job resource.
# Left out of the initial scaffold on purpose — wire this up once the
# script itself is written and tested locally, so you're not debugging
# Terraform and PySpark at the same time.
