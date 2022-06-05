import sqlite3 as sql 
import os
from flask import Flask, render_template, request, g, flash, abort, redirect, url_for
from FDataBase import FDataBase
from werkzeug.security import generate_password_hash, check_password_hash
from flask_login import LoginManager, login_user, login_required, logout_user, current_user
from UserLogin import UserLogin
# PBKDF2 - Password-Based Key Derivation Function (sha), Werkzeug
# Flask-Login

# Configuration
DATABASE = '/tmp/flask.sqlite'
DEBUG= True
SECRET_KEY = 'edc8492c-d3c6-11ec-a307-a32b5aa2d1d2'

app = Flask(__name__)

# Read all vars from tgis file
app.config.from_object(__name__)
# Redifine database file path to root folder
app.config.update(dict(DATABASE=os.path.join(app.root_path, 'flsite.sqlite')))

login_manager = LoginManager(app)

# Redirect for unauthorized users and custom design
login_manager.login_view = 'login'
login_manager.login_message = "Please authorize for view this page"
login_manager.login_message_category = "success"

def connect_db():
    conn = sql.connect(app.config['DATABASE'])
    conn.row_factory = sql.Row
    return conn

def create_db():
    db = connect_db()
    with app.open_resource('schema.sql', mode='r') as f:
        db.cursor().executescript(f.read())
        db.commit()
        db.close()

def open_db():
    if not hasattr(g, 'link_db'):
        g.link_db = connect_db()
    return g.link_db

@app.route("/")
def index():
    return render_template('index.html', menu = dbase.getMenu(), articles=dbase.getPostsAnonce())

@app.route("/post", methods=["POST","GET"])
@login_required
def addPost():
    if request.method == "POST":
        if len(request.form['name']) > 2 and len(request.form['post']) > 10:
            res = dbase.addPost(request.form['name'], request.form['post'], request.form['url'])
            if not res:
                flash('Failed to add new post', category='error')
            else:
                flash('Added new post sucessfully', category='success')
        else:
            flash('Failed to add new post', category='error')
    return render_template('post.html', menu = dbase.getMenu(), title='Add new post')

@app.route("/articles/<alias>")
def getPost(alias):
    title, post = dbase.getPost(alias)
    if not title:
        abort(404)
    return render_template('article.html', menu = dbase.getMenu(), title=title, post=post)

@app.route("/login", methods=["POST", "GET"])
def login():
    if current_user.is_authenticated:
        return redirect(url_for('profile'))

    if request.method == "POST":
        user = dbase.getUserByEmail(request.form['email'])
        if user and check_password_hash(user['password'], request.form['password']):
            userlogin = UserLogin().create(user)
            rm = True if request.form.get('remainme') else False
            login_user(userlogin, remember=rm)
            return redirect(request.args.get("next") or url_for("profile"))
        flash("Login failed, check email and password.", "error")

    return render_template("login.html", menu=dbase.getMenu(), title="Sign in")

@app.route("/register", methods=["POST", "GET"])
def register():
    if request.method == "POST":
        if len(request.form["name"]) > 4 and len(request.form["email"]) > 4 \
                and len(request.form["password"]) > 4 and request.form["password"] == request.form["password2"]:
            hash = generate_password_hash(request.form["password"])
            res = dbase.addUser(request.form['name'], request.form["email"], hash)
            if res:
                flash("Registation success!", "success")
                return redirect(url_for("login"))
            else: 
                flash("Registarion failed...", "error")
        else:
            flash("Check data in fields, may be some field have less four chars.", "error")

    return render_template("register.html", menu=dbase.getMenu(), title="Register")

@app.route("/profile")
@login_required
def profile():
    return f"""<p><a href="{ url_for('logout') }">Logout!</a></p>
               <p>User info: { current_user.get_id() }</p>"""

@app.route("/logout")
@login_required
def logout():
    logout_user()
    flash("You are logged out", "success")
    return redirect(url_for('login'))

@login_manager.user_loader
def load_user(user_id):
    print("load_user")
    return UserLogin().fromDB(user_id, dbase)

dbase = None
@app.before_request
def before_request():
    global dbase
    db = open_db()
    dbase = FDataBase(db)

@app.teardown_appcontext
def close_db(error):
    if hasattr(g, 'link_db'):
        g.link_db.close()


if __name__ == "__main__":
    create_db()
    app.run(debug=True)





