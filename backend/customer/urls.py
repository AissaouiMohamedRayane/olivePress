from django.urls import path
from . import views

urlpatterns = [
    path('create', views.CreateCustomerView.as_view()),
    path('update/<int:pk>', views.ModifyCustomerView.as_view()),
    path('list_states', views.ListStates.as_view()),
    path('set_printed/<int:pk>', views.SetPrintedView.as_view()),
    path('search', views.CustomerSearchView.as_view()),
]