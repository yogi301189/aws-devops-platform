import json
import os

import boto3
import psycopg
from fastapi import FastAPI

app = FastAPI(title="DevOps Demo API")


def get_database_credentials():
    client = boto3.client(
        "secretsmanager",
        region_name=os.environ.get("AWS_REGION", "ap-south-1"),
    )

    response = client.get_secret_value(
        SecretId=os.environ["DB_SECRET_ARN"]
    )

    secret = json.loads(response["SecretString"])

    return secret["username"], secret["password"]


@app.get("/")
def root():
    return {
        "application": "DevOps Demo API",
        "status": "running",
        "environment": "development",
    }


@app.get("/health")
def health():
    return {
        "status": "healthy",
    }


@app.get("/db")
def database_check():
    username, password = get_database_credentials()

    connection = psycopg.connect(
        host=os.environ["DB_HOST"],
        port=os.environ.get("DB_PORT", "5432"),
        dbname=os.environ.get("DB_NAME", "appdb"),
        user=username,
        password=password,
    )

    with connection.cursor() as cursor:
        cursor.execute(
            "SELECT current_database(), current_user;"
        )
        database, user = cursor.fetchone()

    connection.close()

    return {
        "database": database,
        "user": user,
        "status": "connected",
    }