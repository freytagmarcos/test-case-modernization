from flask import Flask
from flask_restful import Api
from flask_bcrypt import Bcrypt
from flask_jwt_extended import JWTManager
from flasgger import Swagger
from extensions import db
from routes import initialize_routes
from os import getenv

app = Flask(__name__)

if getenv('FLASK_ENV') == 'PRD':
    app.config.from_object('config.PrdConfig')
else:
    app.config.from_object('config.DevConfig')


api = Api(app)
bcrypt = Bcrypt(app)
jwt = JWTManager(app)
swagger = Swagger(app)

db.init_app(app)
initialize_routes(api)

if __name__ == '__main__':
    
    app.logger.info('Processing default request')
    print("Configuration from environment:")
    for key, value in app.config.items():
        print(f'{key}: {value}')

    app.run(debug=True, host="0.0.0.0")
