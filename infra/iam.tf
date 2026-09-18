# --- Lambda execution role ---
resource "aws_iam_role" "lambda_ingestion" {
  name = "${var.project_name}-lambda-ingestion-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = { Service = "lambda.amazonaws.com" }
    }]
  })
}

resource "aws_iam_role_policy" "lambda_ingestion" {
  name = "${var.project_name}-lambda-ingestion-policy"
  role = aws_iam_role.lambda_ingestion.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["logs:CreateLogGroup", "logs:CreateLogStream", "logs:PutLogEvents"]
        Resource = "arn:aws:logs:*:*:*"
      },
      {
        Effect   = "Allow"
        Action   = ["s3:PutObject"]
        Resource = "${aws_s3_bucket.raw.arn}/*"
      }
    ]
  })
}

# --- Glue service role ---
resource "aws_iam_role" "glue_service" {
  name = "${var.project_name}-glue-service-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = { Service = "glue.amazonaws.com" }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "glue_service" {
  role       = aws_iam_role.glue_service.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSGlueServiceRole"
}

resource "aws_iam_role_policy" "glue_s3_access" {
  name = "${var.project_name}-glue-s3-access"
  role = aws_iam_role.glue_service.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Action = ["s3:GetObject", "s3:PutObject", "s3:ListBucket"]
      Resource = [
        aws_s3_bucket.raw.arn, "${aws_s3_bucket.raw.arn}/*",
        aws_s3_bucket.processed.arn, "${aws_s3_bucket.processed.arn}/*",
        aws_s3_bucket.glue_assets.arn, "${aws_s3_bucket.glue_assets.arn}/*"
      ]
    }]
  })
}
