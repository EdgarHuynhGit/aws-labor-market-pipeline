# Design decisions

Keep this updated as you build — it's the file interviewers actually ask about.

## Data source: BLS vs. Adzuna
- **Status:** TBD
- Considerations: auth method, rate limits, data granularity, historical
  backfill availability.

## Ingestion: Lambda + EventBridge vs. Fargate/ECS
- **Decision:** Lambda + EventBridge (scheduled)
- **Why:** the ingestion job is small, quick, and runs on a simple schedule —
  no need for a long-running container. Lambda's free tier easily covers a
  daily invocation.

## Transform: Glue vs. plain Python (pandas) in Lambda
- **Decision:** Glue
- **Why:** demonstrates the managed ETL / Spark pattern that shows up in AWS
  data engineering job descriptions, and scales past what a Lambda's memory
  and 15-minute timeout would allow if the dataset grows.

## Infra as code: Terraform vs. AWS CDK / CloudFormation
- **Decision:** Terraform
- **Why:** cloud-agnostic syntax, widely used across companies regardless of
  which cloud they're on, large community/module ecosystem.

## Visualization: QuickSight vs. custom Flask/React dashboard
- **Status:** TBD — QuickSight is faster to stand up; a custom dashboard is
  more portfolio-visible and doubles as React practice.
