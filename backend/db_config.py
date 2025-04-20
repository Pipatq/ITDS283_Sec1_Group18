# import mysql.connector

# def get_connection():
#     return mysql.connector.connect(
#         host='localhost',
#         user='root',
#         password='',
#         database='football',
#     )


# import mysql.connector
# def get_connection():
#     return mysql.connector.connect(
#         host = "gateway01.ap-southeast-1.prod.aws.tidbcloud.com",
#         port = 4000,
#         user = "4SogGgVti3txabK.root",
#         password = "CXHHLturkn3F9GJK",
#         database = "football",
#         ssl_ca= "C:/Users/pipat/Documents/flutter/Project/index/backend/isrgrootx1.pem",
#         ssl_verify_cert = True,
#         ssl_verify_identity = True
#     )
    
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