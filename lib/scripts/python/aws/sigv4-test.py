"""
The following example code establishes a secure connection to the specified OpenSearch Service
domain and indexes a single document.
"""

import os
from opensearchpy import OpenSearch, RequestsHttpConnection
from requests_aws4auth import AWS4Auth
import boto3

HOST = "localhost"  # Run aws/sso/login aws/ssm/port-forwarding
REGION = ""
SERVICE = ""

profile_name=os.getenv('AWS_PROFILE')

session = boto3.Session(profile_name=profile_name)
client = session.client("sts")

print(client.get_caller_identity())

credentials = session.get_credentials()
awsauth = AWS4Auth(
    credentials.access_key,
    credentials.secret_key,
    REGION,
    SERVICE,
    session_token=credentials.token,
)

search = OpenSearch(
    hosts=[{"host": HOST, "port": 9200}],
    http_auth=awsauth,
    use_ssl=True,
    verify_certs=False,
    ssl_assert_hostname=False,
    ssl_show_warn=False,
    connection_class=RequestsHttpConnection,
)

# To display cluster's information
print(search.info())

# To create an index
# document = {
#     "title": "Moneyball",
#     "director": "Bennett Miller",
#     "year": "2011"
# }
# search.index(index="movies", id="5", body=document)

# To get and print index
# print(search.get(index="movies", id="5"))

# To delete the index created above
# print(search.delete(index="movies", id="5"))
