from datetime import timedelta
from flask_restful import Resource
from flask_jwt_extended import create_access_token
from flask import request
from models.user_model import UserModel


class Authentication(Resource):
    def post(self):
        body = request.get_json()
        user = UserModel.objects.get(email=body.get('email'))
        authorized = user.check_password(body.get('password'))
        if not authorized:
            return {'Error': 'Email or password incorrect'}, 401

        expires = timedelta(days=7)
        access_token = create_access_token(identity=str(user.id), expires_delta=expires)
        return {'Token': access_token}, 200