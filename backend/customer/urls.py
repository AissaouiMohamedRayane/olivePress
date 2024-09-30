from django.urls import path
from . import views

urlpatterns = [
    path('create', views.CreateCustomerView.as_view()),
    path('list_states', views.ListStates.as_view()),
]