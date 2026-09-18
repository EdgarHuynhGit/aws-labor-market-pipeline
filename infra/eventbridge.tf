resource "aws_cloudwatch_event_rule" "ingestion_schedule" {
  name                = "${var.project_name}-ingestion-schedule"
  schedule_expression = var.schedule_expression
}

resource "aws_cloudwatch_event_target" "ingestion_lambda" {
  rule      = aws_cloudwatch_event_rule.ingestion_schedule.name
  target_id = "ingestion-lambda"
  arn       = aws_lambda_function.ingestion.arn
}

resource "aws_lambda_permission" "allow_eventbridge" {
  statement_id  = "AllowExecutionFromEventBridge"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.ingestion.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.ingestion_schedule.arn
}
