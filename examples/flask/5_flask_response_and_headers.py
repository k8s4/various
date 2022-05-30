# headers
# Content-Type: ( text/html, text/plain, impage/jpeg, audio/mp4, multipart/form-data )
# There are three ways to make server response:
# 1. return string and flask make automatically: content-type: text/html and code 200
# 2. make response by make_response()
#         obj = make_response(body, status_code=200)
#         + make cookie
# 3. return tuple like (response, status, headers) or (response, headers) or (response, status)

from flask import Flask, render_template, url_for, make_response, redirect

app = Flask(__name__)

menu = [{"title": "Main", "url": "/"},
        {"title": "Post", "url": "/add_post"}]

@app.route("/")
def index():
    content = render_template('index.html', menu=menu, posts=[])
    res = make_response(content)
    res.headers['Content-Type'] = "text/plain"
    res.headers['Server'] = "Flask Servershit"
    return res

@app.route("/img")
def img():
    img = None
    with app.open_resource(app.root_path + "/static/images/owl.jpeg", mode="rb") as f:
        img = f.read()
    if img is None:
        return "None image"
    res = make_response(img)
    res.headers['Content-Type'] = "image/jpeg"
    return res

@app.route("/fake")
def fake():
    res = make_response("<h1>Some code test</h1>", 500)
    return res

@app.errorhandler(404)
def shitPage(error):
    return("Shitpage not found", 404)

# 301 - permanent redirect
# 302 - temporary redirect
@app.route("/predirect")
def predirect():
    return redirect(url_for("index"), 301)


if __name__ == "__main__":
    app.run(debug=True)

