import os
os.environ["RAW_BUCKET"] = "labor-market-pipeline-raw-dev"
os.environ["ADZUNA_APP_ID"] = "0f1bbf01"
os.environ["ADZUNA_APP_KEY"] = "984e8589ae95326991225fd04b295209"
os.environ["ADZUNA_QUERY"] = "data analyst"

from lambda_function import handler

result = handler({}, None)
print(result)  