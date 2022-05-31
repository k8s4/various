# Set cookies!
# set_cookie(key, value="", max_age=None)
# request.cookies.get(key)
# key - cookie name, 30-50 keys per domain
# value - data, limit 4KB per key
# max_age - in seconds

from flask import Flask, request, make_response

app = Flask(__name__)

@app.route("/")
def index():
    return "<html><head><title>Hello test</title></head><body><h1>Test Site</h1></body></html>"

@app.route("/login")
def login():
    log = "someshit"
    cookie = request.cookies.get("logged")
    if cookie:
        log = cookie

    res = make_response(f"<h1>Login form</h1><p>Logged: {log}")
    res.set_cookie("logged", "yes!!!", 60)
    return res

@app.route("/logout")
def logout():
    res = make_response(f"<p>You are logged out!</p>")
    res.set_cookie("logged", "", 0)
    return res

if __name__ == "__main__":
    app.run(debug=True)


#< HTTP/1.1 200 OK
#< Content-Type: text/html; charset=utf-8
#< Content-Length: 38
#< Set-Cookie: logged=yes!!!; Expires=Tue, 31 May 2022 21:14:05 GMT; Max-Age=60; Path=/
#< Connection: close
