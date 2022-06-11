# Flask blueprints
import sqlite3 as sql 
from flask import Blueprint, render_template, request, url_for, redirect, flash, session, g

# Decorators way:
# @app.before_request
# @admin.before_request
# @admin.teardown_request
# @app.teardown_appcontext

# 'admin'  - suffix for all methods in this module
# __name__ - runtime module root folder
admin = Blueprint('admin', __name__, template_folder='templates', static_folder='static')

menu = [{'url': '.index', 'title': 'Panel'},
        {'url': '.listusers', 'title': 'List users'},
        {'url': '.listpubs', 'title': 'Posts'},
        {'url': '.logout', 'title': 'Logout'}]

db = None

def login_admin():
    session['admin_logged'] = 1

def isLogged():
    return True if session.get('admin_logged') else False

def logout_admin():
    session.pop('admin_logged', None)

@admin.route('/')
def index():
    if not isLogged():
        return redirect(url_for('.login'))
    return render_template("admin/index.html", menu=menu, title="Admin panel")
    

@admin.route('/login', methods=["POST", "GET"])
def login():
    if isLogged():
        return redirect(url_for('.index'))
        
    if request.method == "POST":
        if request.form['user'] == 'admin' and request.form['password'] == "12345":
            login_admin()
            return redirect(url_for(".index")) # or admin.index - admin is name of blueprint
        else:
            flash("Login failed, check email and password.", "error")
    return render_template("admin/login.html", title="Admin panel")

@admin.route('/logout', methods=['POST', 'GET'])
def logout():
    if not isLogged():
        return redirect(url_for('.login'))
    logout_admin()
    return redirect(url_for('.login'))

@admin.before_request
def before_request():
    global db
    db = g.get('link_db')

@admin.teardown_request
def teardown_request(request):
    global db
    db = None
    return request

@admin.route('/list-pubs')
def listpubs():
    if not isLogged():
        return redirect(url_for('.login'))

    list = []
    if db:
        try:
            cur = db.cursor()
            cur.execute(f"SELECT title, text, url FROM posts")
            list = cur.fetchall()
        except sqlite3.Error as e:
            print("Failed to fetch posts from database" + str(e))

    return render_template('admin/listpubs.html', title="List of posts", menu=menu, list=list)

@admin.route('/list-users')
def listusers():
    if not isLogged():
        return redirect(url_for('.login'))

    list = []
    if db:
        try:
            cur = db.cursor()
            cur.execute(f"SELECT name, email FROM users ORDER BY time DESC")
            list = cur.fetchall()
        except sqlite3.Error as e:
            print("Faild to get users from database" + str(e))

    return render_template('admin/listusers.html', title='Users list', menu=menu, list=list)
