#https://wtforms.readthedocs.io
# /en/2.3.x/validators
#WTForms Library, Flask-WTF package, email-validator
#  included shield from CSRF (Cross-Site Request Forgery)
#Base class: FlaskForm
#Form classes: StfingField, PasswordField, BooleanField, TexAreaField, SelectField, SubmitField

from flask_wtf import FlaskForm
from wtforms import StringField, PasswordField, BooleanField, SubmitField
from wtforms.validators import DataRequired, Email, Length, EqualTo

class LoginForm(FlaskForm):
    email = StringField("Email: ", validators=[Email("Invalid email")])
    password = PasswordField("Password: ", validators=[DataRequired(), Length(min=3, max=100, message="Minimal length from 3 till 100")])
    remember = BooleanField("Remember me: ", default=False)
    submit = SubmitField("Sing in")

