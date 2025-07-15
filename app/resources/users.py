from flask import make_response
from flask_jwt_extended import jwt_required
from flask_restful import Resource

from models.user_model import UserModel
from schemas.user import UserSchema

class Users(Resource):
    @jwt_required
    def get(self):
        """
        This in an example that returns Hello World!
        ---
        responses:
            200:
                description: A successful response
                examples:
                    application/json: "Hello, World!"
        """
        try:
            users = UserModel.objects()
            user_schema = UserSchema(many=True)
            return make_response(user_schema.dump(users))
        except Exception as e:
            return ("Internal Server Error", e, 500)
