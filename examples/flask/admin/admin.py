# Flask blueprints
from flask import Blueprint, render_template, request, url_for, redirect, flash, session


# 'admin'  - suffix for all methods in this module
# __name__ - runtime module root folder
admin = Blueprint('admin', __name__, template_folder='templates', static_folder='static')

menu = [{'url': '.index', 'title': 'Панель'},
        {'url': '.logout', 'title': 'Выйти'}]

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


