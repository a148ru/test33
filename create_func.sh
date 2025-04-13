#!/bin/bash

yc serverless function create \
  --name for-serverless-shortener \
  --description "function for serverless-shortener"

yc serverless function version create \
  --function-name for-serverless-shortener \
  --memory=256m \
  --execution-timeout=5s \
  --runtime=python39 \
  --entrypoint=index.handler \
  --service-account-id $SERVICE_ACCOUNT_SHORTENER_ID \
  --environment USE_METADATA_CREDENTIALS=1 \
  --environment endpoint=grpcs://$YDB_ENDPOINT \
  --environment database=$YDB_DATABASE \
  --source-path src.zip

yc serverless function allow-unauthenticated-invoke for-serverless-shortener

