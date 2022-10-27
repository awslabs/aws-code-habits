import os
import boto3
import requests
from requests_aws4auth import AWS4Auth

host = '' # e.g. https://localhost:8080/
region = '' # e.g. us-west-1
service = '' # es

profile_name=os.getenv('AWS_PROFILE')
credentials = boto3.Session(profile_name=profile_name).get_credentials()
awsauth = AWS4Auth(credentials.access_key, credentials.secret_key, region, service, session_token=credentials.token)


# Register repository

bucket_name=''
role_arn=''

def register_repository():
    path = f'_snapshot/{bucket_name}' # the OpenSearch API endpoint
    url = host + path

    payload = {
        "type": "s3",
        "settings": {
            "bucket": f'{bucket_name}',
            "region": f'{region}',
            "role_arn": f'{role_arn}'
        }
    }

    headers = {"Content-Type": "application/json"}

    r = requests.put(url, auth=awsauth, json=payload, headers=headers, verify=False)

    print(r.status_code)
    print(r.text)

from datetime import datetime
snapshot_name = datetime.today().strftime('%Y-%m-%d')

# Take snapshot
def take_snapshot():
    path = f'_snapshot/{bucket_name}/{snapshot_name}'
    url = host + path

    r = requests.put(url, auth=awsauth, verify=False)
    print(r.text)

# Restore snapshot (all indexes except Dashboards and fine-grained access control)
def restore_snapshot():
    path = f'_snapshot/{bucket_name}/{snapshot_name}/_restore'
    url = host + path

    payload = {
    "indices": "-.kibana*,-.opendistro_security",
    "include_global_state": False
    }

    headers = {"Content-Type": "application/json"}
    r = requests.post(url, auth=awsauth, json=payload, headers=headers, verify=False)
    print(r.text)

def list_all_indices():
    path = f'_cat/indices'
    url = host + path

    r = requests.get(url, auth=awsauth, verify=False)
    print(r.text)

# register_repository()
# take_snapshot()
# restore_snapshot()
list_all_indices()
