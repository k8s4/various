# request --> 
# context app (g, current_app) --> 
# context_request (request(url, GET,POST, key=value, more...), session(dict, for token and more...) )
#
# app1 = Flask("app1") 
# app2 = Flask("app2")

from flask import Flask, render_template, url_for, request, flash, session, redirect, abort

app = Flask(__name__)
app.config['SECRET_KEY'] = "edc8492c-d3c6-11ec-a307-a32b5aa2d1d9"

menu = [{"name": "General", "url": "/"},
        {"name": "Sign in", "url": "/login"},
        {"name": "Post", "url": "/post"},
        {"name": "Contact", "url": "contact"},
        {"name": "About", "url": "about"}]

@app.route("/test")
@app.route("/")
def index():
    print( url_for("index") )
    return render_template("index.html", title="SuperSite", menu=menu)

@app.route("/contact", methods=["POST", "GET"])
def contact():
    if request.method == "POST":
        print(request.form['username'])
        if len(request.form['username']) > 2:
            flash('Message sent!', category='success')
        else:
            flash('Message sent failed.', category='error')

    return render_template("contact.html", title="SuperSite Contact", menu=menu)

@app.route("/base")
def basepage():
    print( url_for("basepage") )
    return render_template("index.html")

# int, float, path
@app.route("/some/<int:page>/<path:shit>")
def sometest(shit, page):
    return f"Path: {shit} on {page}.\n"

# request contest test 
with app.test_request_context():
    print( url_for("basepage") )
    print( url_for("sometest", shit="somesome", page=333) )


@app.route("/login", methods=["POST", "GET"])
def login():
    if "userLogged" in session:
        return redirect(url_for("profile", username=session['userLogged']))
    elif request.method == 'POST' and request.form['username'] == "petrovich" and request.form['password'] == "pass":
        session['userLogged'] = request.form['username']
        return redirect(url_for('profile', username=session['userLogged']))

    return render_template('login.html', title="Authorize form", menu=menu)

# dynamic url eq
@app.route("/profile/<username>")
def profile(username):
    if 'userLogged' not in session or session['userLogged'] != username:
        abort(401)

    return f"User: {username}\n"

# request contest test
with app.test_request_context():
    print( url_for("basepage") )
    print( url_for("sometest", shit="somesome", page=333) )

@app.errorhandler(404)
def pageNotFound(error):
    return render_template("404.html", title="Page not found or not yet made", menu=menu), 404

@app.errorhandler(401)
def pageNotFound(error):
    return render_template("401.html", title="You are not authorized to view this content", menu=menu, error=401), 401

if __name__ == "__main__":
    app.run(debug=True)

