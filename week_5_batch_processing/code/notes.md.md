URL="spark://de-zoomcamp-vm.us-central1-c.c.de-zoomcamp-viniciuspc.internal:7077"

spark-submit \
  --master="${URL}" \
  06_spark_sql.py \
    --input_green=data/pq/green/2021/*/ \
    --input_yellow=data/pq/yellow/2021/*/ \
    --output=data/report-2021

