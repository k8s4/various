# https://flask.palletsprojects.com/en/2.1.x/api/
# If you needed make db connection onece
# before_first_request - runs onece after first request
# before_request   - runs before request
# after_request    - runs after request if ok
# teardown_request - runs after request anyway

from flask import Flask
app = Flask(__name__)

@app.route("/")
def index():
    return "<html><head><title>Hello test</title></head><body><h1>Test Site</h1></body></html>"

@app.before_first_request
def before_first_request():
    print("before_first_request() called")

@app.before_request
def before_request():
    print("before_request() called")

@app.after_request
def after_request(response):
    print("after_request() called")
    return response

@app.teardown_request
def teradown_request(response):
    print("teardown_request() called")
    return response


if __name__ == "__main__":
    app.run(debug=True)

