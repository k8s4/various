from flask import Flask, abort, make_response

app = Flask(__name__)
status = ""
root = "Base path, working..."

@app.route("/")
def index():
    if status == "err":
      abort(500)
    return root

@app.route("/status")
def status():
    global status
    response = make_response(status)
    response.headers['Custom-Status'] = status
    return response

@app.route("/err")
def err():
    global status
    status = "err"
    return status

@app.route("/switch")
def switch():
    global status
    if status == "running":
      status = "busy"
    else:
      status = "running"
    return "switched to " + status

if __name__ == "__main__":
    status = "running"
    app.run(debug=True, host='0.0.0.0', port='5000')

