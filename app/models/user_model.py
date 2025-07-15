
from extensions import db
from flask_bcrypt import generate_password_hash, check_password_hash

class UserModel(db.Document):
    username = db.StringField(required=True, unique=True)
    first_name = db.StringField(required=True)
    last_name = db.StringField(required=True)
    email = db.EmailField(required=True)
    password = db.StringField(required=True)
    #birth_date = db.DateTimeField(required=True)

    def hash_password(self):
        self.password = generate_password_hash(self.password).decode('utf-8')

    def check_password(self, password):
        return check_password_hash(self.password, password)