from flask import Flask, render_template

app = Flask(__name__)

menu = ["General","Solutions","About"]

@app.route("/test")
@app.route("/")
def index():
    return render_template("index.html", title="SuperSite", menu=menu)

@app.route("/base")
def basepage():
    return render_template("index.html")

if __name__ == "__main__":
    app.run(debug=True)

