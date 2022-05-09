from flask import Flask

app = Flask(__name__)

@app.route("/test")
@app.route("/")
def index():
    return "<html><head><title>Hello test</title></head><body><h1>Test Site</h1></body></html>"

if __name__ == "__main__":
    app.run(debug=True)

