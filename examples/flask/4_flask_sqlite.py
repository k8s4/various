import sqlite3 as sql 
import os
from flask import Flask, render_template, request, g

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
    return render_template('index.html', menu = [db])

@app.teardown_appcontext
def close_db(error):
    if hasattr(g, 'link_db'):
        g.link_db.close()

if __name__ == "__main__":
    app.run(debug=True)




