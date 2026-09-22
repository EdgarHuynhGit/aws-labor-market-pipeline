import os
os.environ["RAW_BUCKET"] = "labor-market-pipeline-raw-dev"
os.environ["ADZUNA_APP_ID"] = "your_app_id"
os.environ["ADZUNA_APP_KEY"] = "your_app_key"
os.environ["ADZUNA_QUERY"] = "data analyst"

from lambda_function import handler

result = handler({}, None)
print(result)