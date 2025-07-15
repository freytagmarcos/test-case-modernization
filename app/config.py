from os import getenv


class DevConfig:

    JWT_SECRET_KEY = getenv('JWT_SECRET_KEY')

    MONGODB_SETTINGS = {
        'db': getenv('MONGODB_DB'),
        'host': getenv('MONGODB_HOST'),
        'port': 27017,
        'username': getenv('MONGODB_USERNAME'),
        'password': getenv('MONGODB_PASSWORD')
    }


class PrdConfig:

    JWT_SECRET_KEY = getenv('JWT_SECRET_KEY')

    MONGODB_USER = getenv('MONGODB_USER')
    MONGODB_PASSWORD = getenv('MONGODB_PASSWORD')
    MONGODB_HOST = getenv('MONGODB_HOST')
    MONGODB_DB = getenv('MONGODB_DB')

    MONGODB_SETTINGS = {
        'host': 'mongodb+srv://%s:%s@%s/%s' % (
          MONGODB_USER,
          MONGODB_PASSWORD,
          MONGODB_HOST,
          MONGODB_DB
        )
    }