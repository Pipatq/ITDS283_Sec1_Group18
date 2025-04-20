from dotenv import load_dotenv
import os
import mysql.connector

load_dotenv()

def str_to_bool(value):
    return str(value).strip().lower() in ['true', '1', 'yes']


def get_connection():
    return mysql.connector.connect(
        host=os.getenv('DB_HOST'),
        port=int(os.getenv('DB_PORT', 3306)),
        user=os.getenv('DB_USER'),
        password=os.getenv('DB_PASSWORD'),
        database=os.getenv('DB_NAME'),
        ssl_ca=os.getenv('ssl_ca'),
        ssl_verify_cert=str_to_bool(os.getenv('ssl_verify_cert')),
        ssl_verify_identity=str_to_bool(os.getenv('ssl_verify_identity'))
    )