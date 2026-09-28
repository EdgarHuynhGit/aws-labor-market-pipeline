# Repository Instructions

## Project scope
- This repository builds a serverless AWS labor-market analytics pipeline.
- Keep the architecture aligned with EventBridge -> Lambda -> S3 raw -> Glue/PySpark -> S3 processed Parquet -> Athena.
- The ingestion implementation currently targets the Adzuna API; do not silently switch to BLS without updating `docs/decisions.md` and the ETL schema.

## Technology conventions
- Python target: 3.12.
- Terraform target: >= 1.5.0 with AWS provider `~> 5.0` and Archive provider `~> 2.4`.
- Use AWS Lambda for scheduled ingestion and AWS Glue for managed Spark ETL.
- Keep credentials out of source control; use environment variables locally and AWS-managed secret/configuration services in deployed infrastructure.

## Change guidance
- Preserve raw API responses in S3 and keep transformations in the Glue job.
- Keep Terraform changes modular under `infra/` and update documentation for architecture or decision changes.
- Add or update focused tests under `tests/` or `ingestion/test_local.py` for Python behavior changes.
- Validate Python syntax/tests and Terraform formatting/validation when those tools are available.
- Avoid unrelated refactors and do not commit changes unless explicitly requested.
