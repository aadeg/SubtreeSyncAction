import json
import requests
import os

jwt_token = os.environ.get('JWT_TOKEN')
installation_id = os.environ.get('INSTALLATION_ID')
if jwt_token is None:
    raise Exception('JWT_TOKEN is not set')
if installation_id is None:
    raise Exception('INSTALLATION_ID is not set')

url = f"https://api.github.com/app/installations/{installation_id}/access_tokens"
headers = {
    "Authorization": "Bearer " + jwt_token,
    "Content-Type": "application/vnd.github.v3+json"
}
r = requests.post(url, headers=headers)
res = r.json()
if "token" not in res:
    raise Exception(f"Missing token in response: {r.text}")
print(res["token"])