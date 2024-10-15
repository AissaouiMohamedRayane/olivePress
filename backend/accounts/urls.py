from django.urls import path
from rest_framework.authtoken.views import obtain_auth_token
from .views import *

urlpatterns = [
    path('login', obtain_auth_token),
    path('validate-token', validate_token),
    path('register', RegisterView.as_view()),
    path('get_user_data', GetUserView.as_view()),
    path('get_staff_users', GetStaffUsers.as_view()),
    path('delete_user_by_id/<int:pk>', DeleteUser.as_view()),
    path('add_user_to_staff/<int:pk>', AddUserToStaf.as_view()),
    path('change_olive_type/<int:pk>', ChangeUserOliveTypeView.as_view()),
    path('logout', LogoutView.as_view()),  

]
