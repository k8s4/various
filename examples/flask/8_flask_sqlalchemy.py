from flask_sqlalchemy import SQLAlchemy
from flask import Flask, render_template, request
from datetime import datetime
from werkzeug.security import generate_password_hash, check_password_hash

# ORM - Object Role Model
# SQLAlchemy
# postgresql:///, mysql:///, oracle:///
# Interer, String(size), Test, DateTime, Float, Boolean, LargeBinary


app = Flask(__name__)
app.config['SQLALCHEMY_DATABASE_URI'] = "sqlite:///sa.sqlite"
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False

db = SQLAlchemy(app)

class saUsers(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    email = db.Column(db.String(50), unique=True)
    password = db.Column(db.String(500), nullable=True)
    date = db.Column(db.DateTime, default=datetime.utcnow)

    pr = db.relationship('saProfiles', backref='saUsers', uselist=False)

    def __repr__(self):
        return f"<sa_users {self.id}>"

class saProfiles(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    name = db.Column(db.String(50), nullable=True)
    age = db.Column(db.Integer)
    city = db.Column(db.String(100))

    user_id = db.Column(db.Integer, db.ForeignKey('sa_users.id'))

    def __repr__(self):
        return f"<sa_profiles {self.id}>"

@app.route("/register", methods=["POST", "GET"])
def register():
    if request.method == "POST":
        try:
            hash = generate_password_hash(request.form["password"])
            u = saUsers(email=request.form['email'], password=hash)
            db.session.add(u)
            db.session.flush()
            p = saProfiles(name=request.form['name'], age=request.form['age'], city=request.form['city'], user_id=u.id)
            db.session.add(p)
            db.session.commit()
        except:
            db.session.rollback()
            print("Failed to add data into database.")

    return render_template("saregister.html", title="Register")

@app.route("/")
def index():
    info = []
    try:
        info = saUsers.query.all()
    except:
        print("Failed to get users from database")

    return render_template("saindex.html", title="Main", list=info)

if __name__ == "__main__":
    db.create_all()
# Simple select's!!
    res = saUsers.query.get(2)
#    saUsers.query.all()[0].email
#    saUsers.query.limit(3).all()
#    saUsers.query.first().email
#    saUsers.query.filter_by(id = 2).all()
#    saUsers.query.filter(Users.id == 2).all()
#    saUsers.query.order_by(Users.email).all()
#    saUsers.query.order_by(Users.email.desc()).all()

# Make Join from two tables
#    res = db.session.query(saUsers, saProfiles).join(saProfiles, saUsers.id == saProfiles.user_id).all()
    print(res)
# Alternate, make var for relation in the class saUsers for saProfiles
#    pr = db.relationship('saProfiles', backref='saUsers', uselist=False)
#    print(res.pr)
    
    app.run(debug=True)



