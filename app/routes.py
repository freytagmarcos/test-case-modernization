from resources.user import User
from resources.users import Users
from resources.health import Health
from resources.authentication import Authentication

def initialize_routes(api):
    api.add_resource(Health, '/health')
    api.add_resource(User, '/user', '/user/<string:username>')
    api.add_resource(Users, '/users')
    api.add_resource(Authentication, '/login')
