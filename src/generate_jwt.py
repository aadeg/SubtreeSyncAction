import os
from datetime import datetime, timedelta, timezone

from jwt import JWT, jwk_from_pem
from jwt.utils import get_int_from_datetime

app_id = os.environ.get('APP_ID')
private_key_path = os.environ.get('PRIVATE_KEY_PATH')
private_key = os.environ.get('PRIVATE_KEY')
if app_id is None:
    raise Exception('APP_ID is not set')
if private_key_path is None and private_key is None:
    raise Exception('Neither PRIVATE_KEY nor PRIVATE_KEY_PATH is set')

instance = JWT()

# Loading the private key
if private_key is not None:
    signing_key = jwk_from_pem(bytes(private_key, 'ascii'))
else:
    with open(private_key_path, "rb") as key_file:
        signing_key = jwk_from_pem(key_file.read())

# Generating the JWT
payload = {
    "iat": get_int_from_datetime(datetime.now(timezone.utc)),
    "exp": get_int_from_datetime(datetime.now(timezone.utc) + timedelta(minutes=10)),
    "iss": app_id
}

# Encoding the JWT
jwt = instance.encode(payload, key=signing_key, alg="RS256")
print(jwt)
