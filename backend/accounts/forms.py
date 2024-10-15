from django import forms
from django.contrib.auth.forms import UserCreationForm, UserChangeForm
from .models import NewUser

class CustomUserCreationForm(UserCreationForm):
    class Meta:
        model = NewUser
        fields = ('username', 'phone', 'olive_type')

class CustomUserChangeForm(UserChangeForm):
    class Meta:
        model = NewUser
        fields = ('username', 'phone', 'olive_type')
