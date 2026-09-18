"""
Ingestion Lambda: pulls job posting data from the Adzuna API and writes
the raw response to S3, untouched, for the Glue job to process later.

TODO before this works:
  - Register at developer.adzuna.com for an app_id + app_key
  - Store both in SSM Parameter Store or Secrets Manager and reference
    them here -- NOT as hardcoded values or a committed .env file.
    For local testing only, env vars are fine (export, don't commit).
"""

import json
import os
import urllib.parse
import urllib.request
from datetime import datetime, timezone

import boto3

s3 = boto3.client("s3")
RAW_BUCKET = os.environ["RAW_BUCKET"]

ADZUNA_APP_ID = os.environ.get("ADZUNA_APP_ID", "")
ADZUNA_APP_KEY = os.environ.get("ADZUNA_APP_KEY", "")
ADZUNA_COUNTRY = os.environ.get("ADZUNA_COUNTRY", "us")
ADZUNA_QUERY = os.environ.get("ADZUNA_QUERY", "software engineer")


def fetch_data() -> dict:
    """Pull one page of job postings from the Adzuna search API."""
    url = (
        f"https://api.adzuna.com/v1/api/jobs/{ADZUNA_COUNTRY}/search/1"
        f"?app_id={ADZUNA_APP_ID}&app_key={ADZUNA_APP_KEY}"
        f"&what={urllib.parse.quote(ADZUNA_QUERY)}&results_per_page=50"
    )
    with urllib.request.urlopen(url, timeout=10) as response:
        return json.loads(response.read())


def handler(event, context):
    timestamp = datetime.now(timezone.utc)
    key = f"raw/{timestamp:%Y/%m/%d}/{timestamp:%Y%m%dT%H%M%S}.json"

    data = fetch_data()

    s3.put_object(
        Bucket=RAW_BUCKET,
        Key=key,
        Body=json.dumps(data).encode("utf-8"),
        ContentType="application/json",
    )

    return {"statusCode": 200, "bucket": RAW_BUCKET, "key": key}
