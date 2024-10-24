from .models import NewUser
from rest_framework import serializers

class RegisterSerializer(serializers.ModelSerializer):
    class Meta:
        model = NewUser
        fields = ('username', 'password')  

    def create(self, validated_data):
        password = validated_data.pop('password', None)
        user = NewUser.objects.create_user(**validated_data)
        if password:
            print(password)
            user.set_password(password)
            user.save()
        return user
    
class RetrieveUserSerializer(serializers.ModelSerializer):
    class Meta:
        model = NewUser
        fields = ('id', 'username', 'is_superuser', 'is_staff', 'olive_type')

class UserOliveTypeSerializer(serializers.ModelSerializer):
    class Meta:
        model = NewUser
        fields = ['olive_type']

class ModifyUserSerializer(serializers.ModelSerializer):
    class Meta:
        model = NewUser
        fields = ['id', 'username', 'password']  # Include only fields you want to allow updating
        extra_kwargs = {
            'password': {'write_only': True},  # Password should not be returned in responses
        }