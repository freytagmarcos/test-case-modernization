from flask import request, make_response
from flask_restful import Resource

from models.user_model import UserModel
from schemas.user import UserSchema

from mongoengine.errors import FieldDoesNotExist, NotUniqueError, DoesNotExist, InvalidQueryError
from marshmallow.exceptions import ValidationError

class User(Resource):
    def get(self, username):
        """
        Esse endpoint retorna os dados de um usuário
        ---
        responses:
            200:
                description: A successful response
                examples:
                    application/json:
            404:
                description: User doesn't exists
            500:
                description: Internal Server Error
        """
        try:
            user = UserModel.objects.get(username=username)
            user_schema = UserSchema()
            return make_response(user_schema.dump(user))
        except DoesNotExist:
            return ({"error": "User with given username doesn't exists"}, 404)
        except Exception as e:
            return ("Internal Server Error", e, 500)

    def post(self):
        """
        Insere um usuário
        ---
        post:
            description: Cria um usuário
            parameters:
            - in: body
              first_name: body
              required: true
              schema: 
                $ref: '#/definitions/User'
        responses:
            201:
                description: User created
                content:
                    application/json:
                        status: string
            400:
                description: Missing required fields
                content:
                    application/json:
                        status: string
        """
        try:
            user_schema = UserSchema()
            data = user_schema.load(request.json)
            user = UserModel(**data)
            user.hash_password()
            user.save()
            return 'OK', 201
        except (FieldDoesNotExist, ValidationError):
            return ({"error":"Request is missing required fields"}, 400)
        except NotUniqueError:
            return ({"error":"User with given username already exists"}, 400)
        except Exception as e:
            return ("Internal Server Error", e, 500)

    def patch(self, username):
        try:
            user = UserModel.objects.get(username=username)
        except DoesNotExist:
            return ({"error": "User with given username doesn't exists"}, 404)
        
        try:
            user_schema = UserSchema(partial=True)

            data = user_schema.load(request.json)
            user.update(**data)
            user.save()
        
        except Exception as e:
            return ("Internal Server Error", 500)

    def delete(self, username):
        try:
            user = UserModel.objects.get(username=username)
        except DoesNotExist:
            return ({"error": "User with given username doesn't exists"}, 404)
        
        try:
            user.delete()
        except Exception as e:
            return ("Internal Server Error", 500)