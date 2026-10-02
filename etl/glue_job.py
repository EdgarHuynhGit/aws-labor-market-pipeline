"""
Glue ETL job: reads raw JSON from the raw S3 zone, flattens/cleans it,
and writes partitioned Parquet to the processed S3 zone.

This is a PySpark job intended to run inside AWS Glue, not locally.
"""

import sys

from awsglue.transforms import *
from awsglue.utils import getResolvedOptions
from awsglue.context import GlueContext
from awsglue.job import Job
from pyspark.context import SparkContext
from pyspark.sql import functions as F

args = getResolvedOptions(sys.argv, ["JOB_NAME", "RAW_PATH", "PROCESSED_PATH"])

sc = SparkContext()
glueContext = GlueContext(sc)
spark = glueContext.spark_session
job = Job(glueContext)
job.init(args["JOB_NAME"], args)

# 1. Read raw JSON (each file is one Adzuna API response: a top-level
#    object with "results" as an array of job postings, plus "count"
#    and "mean" summary fields we don't need per-row).
raw_df = spark.read.json(args["RAW_PATH"])

# 2. Flatten: explode the results array, pull out and rename the
#    fields we care about, cast types appropriately.
clean_df = raw_df.select(F.explode("results").alias("job")).select(
    F.col("job.id").alias("job_id"),
    F.col("job.title").alias("job_title"),
    F.col("job.company.display_name").alias("company"),
    F.col("job.location.display_name").alias("location"),
    F.col("job.category.label").alias("category"),
    F.col("job.salary_min").cast("double").alias("salary_min"),
    F.col("job.salary_max").cast("double").alias("salary_max"),
    F.col("job.salary_is_predicted").cast("int").alias("salary_is_predicted"),
    F.col("job.contract_time").alias("contract_time"),
    F.to_date("job.created").alias("posted_date"),
    F.col("job.redirect_url").alias("job_url"),
)

# 3. Write partitioned Parquet to the processed zone, partitioned by
#    the job's actual posted_date (not ingestion date) so Athena can
#    efficiently filter by when jobs were posted.
(
    clean_df.write.mode("append")
    .partitionBy("posted_date")
    .parquet(args["PROCESSED_PATH"])
)

job.commit()