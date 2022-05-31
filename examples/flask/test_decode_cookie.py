import hashlib
from itsdangerous import URLSafeTimedSerializer
from flask.sessions import TaggedJSONSerializer

def decode_flask_cookie(secret_key, cookie_str):
    salt = 'cookie-session'
    serializer = TaggedJSONSerializer()
    signer_kwargs = {
        'key_derivation': 'hmac',
        'digest_method': hashlib.sha1
    }
    s = URLSafeTimedSerializer(secret_key, salt=salt, serializer=serializer, signer_kwargs=signer_kwargs)
    return s.loads(cookie_str)

key = "39ca5466cac134fdb7b1337d1f64a858b8a4"
cookie = "eyJ2aXNpdHMiOjF9.YpaNMQ.pFjIxOMMDh9BG7H8XA5b0OrHXqI"

res = decode_flask_cookie(key, cookie)
print(res)
