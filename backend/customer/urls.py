from django.urls import path
from . import views

urlpatterns = [
    path('customers/create/', views.CreateCustomerView.as_view()),
]