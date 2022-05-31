# Set cookies!
# set_cookie(key, value="", max_age=None)
# request.cookies.get(key)
# key - cookie name, 30-50 keys per domain
# value - data, limit 4KB per key
# max_age - in seconds

# Session cookies!
# Encrypted by key
# Age of session cookie until close browser.
# Or you can set session.permanent = True
# app.permanent_session_lifetime, default 31 days
# Or set for example datetime.timedelta(days=10)

from flask import Flask, request, make_response, url_for, session
import datetime

app = Flask(__name__)
app.config["SECRET_KEY"] = "39ca5466cac134fdb7b1337d1f64a858b8a4"
app.permanent_session_lifetime = datetime.timedelta(days=1)

@app.route("/")
def index():
    if "visits" in session:
        session["visits"] = session.get("visits") + 1
    else:
        session["visits"] = 1
    return f"<h1>Main</h1><p>Views: {session['visits']}"


# Attention! session['data'] linked to list, list have 1,2,3,4, 
# but when we change index 1 more one time, list not changed, so cookie will not update!
# So you need add session.modified = True, after this shit!
data = [1,2,3,4]
@app.route("/session")
def sessions():
    session.permanent = True
    if "data" not in session:
        session["data"] = data
    else:
        session["data"][1] += 1
        session.modified = True
    return f"<p>session['data']: {session['data']}"

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

# Simpe cookie: ===>
#< HTTP/1.1 200 OK
#< Content-Type: text/html; charset=utf-8
#< Content-Length: 38
#< Set-Cookie: logged=yes!!!; Expires=Tue, 31 May 2022 21:14:05 GMT; Max-Age=60; Path=/
#< Connection: close

# Session cookie ===>
#< Content-Length: 24
#< Vary: Cookie
#< Set-Cookie: session=eyJ2aXNpdHMiOjF9.YpaNXA.1Ark7FWQZAy8hl40HryfqsxpNDM; HttpOnly; Path=/
#< Connection: close

