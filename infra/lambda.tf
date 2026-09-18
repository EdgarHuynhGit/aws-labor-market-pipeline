data "archive_file" "ingestion" {
  type        = "zip"
  source_dir  = "${path.module}/../ingestion"
  output_path = "${path.module}/build/ingestion.zip"
}

resource "aws_lambda_function" "ingestion" {
  function_name    = "${var.project_name}-ingestion"
  role             = aws_iam_role.lambda_ingestion.arn
  handler          = "lambda_function.handler"
  runtime          = "python3.12"
  timeout          = 30
  filename         = data.archive_file.ingestion.output_path
  source_code_hash = data.archive_file.ingestion.output_base64sha256

  environment {
    variables = {
      RAW_BUCKET = aws_s3_bucket.raw.bucket
      # TODO: replace with SSM parameter / Secrets Manager references,
      # e.g. via aws_ssm_parameter data sources -- do not commit real
      # keys as plain Terraform variables.
      ADZUNA_APP_ID  = "TBD"
      ADZUNA_APP_KEY = "TBD"
      ADZUNA_COUNTRY = "us"
      ADZUNA_QUERY   = "software engineer"
    }
  }
}
