"""
Glue ETL job: reads raw JSON from the raw S3 zone, flattens/cleans it,
and writes partitioned Parquet to the processed S3 zone.

This is a PySpark job intended to run inside AWS Glue, not locally.
Fill in the schema/flattening logic once the real API response shape
(BLS or Adzuna) is known.
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

# 1. Read raw JSON
raw_df = spark.read.json(args["RAW_PATH"])

# 2. TODO: flatten/normalize the Adzuna response. Raw results live under
#    the "results" array; each item roughly looks like:
#    { title, company: {display_name}, location: {display_name},
#      salary_min, salary_max, created, redirect_url, category: {label} }
# clean_df = raw_df.select(F.explode("results").alias("job")).select(
#     F.col("job.title").alias("job_title"),
#     F.col("job.company.display_name").alias("company"),
#     F.col("job.location.display_name").alias("location"),
#     F.col("job.salary_min").cast("double").alias("salary_min"),
#     F.col("job.salary_max").cast("double").alias("salary_max"),
#     F.to_date("job.created").alias("posted_date"),
# )
clean_df = raw_df  # placeholder until schema is defined

# 3. Write partitioned Parquet to the processed zone
(
    clean_df.withColumn("ingest_date", F.current_date())
    .write.mode("append")
    .partitionBy("ingest_date")
    .parquet(args["PROCESSED_PATH"])
)

job.commit()
