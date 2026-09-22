# AWS Labor Market Analytics Pipeline

A serverless data pipeline that ingests public job-market data, transforms
it on AWS, and surfaces trends (in-demand skills, salary ranges, posting
volume) in a dashboard — built while job hunting, on the job market data
itself.

## Status

In progress — see [docs/decisions.md](docs/decisions.md) for open
decisions and [docs/architecture.md](docs/architecture.md) for the current
architecture.

## Architecture

```
EventBridge (schedule)
      |
      v
   Lambda  ---->  S3 (raw/)
                      |
                      v
              Glue Crawler + Glue Job
                      |
                      v
              S3 (processed/, Parquet)
                      |
                      v
                   Athena  ---->  QuickSight / Flask+React dashboard
```

## Tech stack

- **Ingestion:** AWS Lambda (Python), scheduled via EventBridge
- **Storage:** S3 (raw + processed zones)
- **Transform:** AWS Glue (crawler + PySpark ETL job)
- **Query:** Athena
- **Visualization:** QuickSight or a custom Flask/React dashboard (TBD)
- **Infrastructure as code:** Terraform

## Data source

Public labor market data via the BLS API or Adzuna API — final choice
tracked in [docs/decisions.md](docs/decisions.md).

## Project structure

```
aws-labor-market-pipeline/
├── infra/          # Terraform: S3, IAM, Lambda, Glue, EventBridge
├── ingestion/       # Lambda function: API pull -> raw S3
├── etl/             # Glue job script (raw -> processed Parquet)
├── analysis/        # Sample Athena queries
├── dashboard/        # QuickSight config or Flask/React app
├── docs/             # Architecture notes and design decisions
└── tests/            # Unit tests for ingestion and transform logic
```

## Setup

Prerequisites: an AWS account, Terraform >= 1.5, Python 3.12.

```bash
cd infra
terraform init
terraform plan
terraform apply
```

This provisions the S3 buckets, IAM roles, Lambda function, EventBridge
schedule, and Glue database/crawler. The Glue ETL job itself is wired up
in a later step once `etl/glue_job.py` is finalized (see
[docs/decisions.md](docs/decisions.md)).

## Roadmap

-  Week 1 — AWS fundamentals, account setup, manual ingestion test
-  Week 2 — Automate ingestion, build Glue crawler + ETL job
-  Week 3 — Athena queries, dashboard
-  Week 4 — Terraform for full infra, docs, demo

## License

MIT — see [LICENSE](LICENSE).
