import sqlite3 as sql 
import os
from flask import Flask, render_template, request, g, flash, abort
from FDataBase import FDataBase

# Configuration
DATABASE = '/tmp/flask.sqlite'
DEBUG= True
SECRET_KEY = 'edc8492c-d3c6-11ec-a307-a32b5aa2d1d2'

app = Flask(__name__)

# Read all vars from tgis file
app.config.from_object(__name__)

# Redifine database file path to root folder
app.config.update(dict(DATABASE=os.path.join(app.root_path, 'flsite.sqlite')))

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
    db = open_db()
    dbase = FDataBase(db)
    print(dbase.getMenu())
    return render_template('index.html', menu = dbase.getMenu(), articles=dbase.getPostsAnonce())

@app.route("/post", methods=["POST","GET"])
def addPost():
    db = open_db()
    dbase = FDataBase(db)
    if request.method == "POST":
        if len(request.form['name']) > 4 and len(request.form['post']) > 10:
            res = dbase.addPost(request.form['name'], request.form['post'])
            if not res:
                flash('Failed to add new post', category='error')
            else:
                flash('Added new post sucessfully', category='success')
        else:
            flash('Failed to add new post', category='error')
    return render_template('post.html', menu = dbase.getMenu(), title='Add new post')

@app.route("/articles/<int:id_post>")
def getPost(id_post):
    db = open_db()
    dbase = FDataBase(db)
    title, post = dbase.getPost(id_post)
    print(dbase.getPost(id_post))
    if not title:
        abort(404)
    return render_template('article.html', menu = dbase.getMenu(), title=title, post=post)

@app.teardown_appcontext
def close_db(error):
    if hasattr(g, 'link_db'):
        g.link_db.close()

if __name__ == "__main__":
    create_db()
    app.run(debug=True)




