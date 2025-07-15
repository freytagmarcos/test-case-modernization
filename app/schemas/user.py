from extensions import ma

class UserSchema(ma.Schema):
    """Marshmallow user schema"""
    username = ma.String(required=True)
    first_name = ma.String(required=True)
    last_name = ma.String(required=True)
    email = ma.Email(required=True)
    password = ma.String(required=True,load_only=True)
    #birth_date = ma.DateTime(required=True)