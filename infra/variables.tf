variable "project_name" {
  description = "Short name used as a prefix for all resources"
  type        = string
  default     = "labor-market-pipeline"
}

variable "aws_region" {
  description = "AWS region to deploy into"
  type        = string
  default     = "us-east-2"
}

variable "environment" {
  description = "Deployment environment (dev/prod)"
  type        = string
  default     = "dev"
}

variable "schedule_expression" {
  description = "EventBridge schedule expression for the ingestion Lambda"
  type        = string
  default     = "rate(1 day)"
}

variable "adzuna_app_id" {
  description = "Adzuna API app_id"
  type        = string
  sensitive   = true
}

variable "adzuna_app_key" {
  description = "Adzuna API app_key"
  type        = string
  sensitive   = true
}