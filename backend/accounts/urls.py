from django.urls import path
from rest_framework.authtoken.views import obtain_auth_token
from .views import *

urlpatterns = [
    path('login', obtain_auth_token),
    path('validate-token/', validate_token),
    path('register', RegisterView.as_view()),
    path('get_user_data', GetUserView.as_view()),
]
