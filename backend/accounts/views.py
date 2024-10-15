from rest_framework.response import Response
from rest_framework.decorators import api_view

from rest_framework.authentication import TokenAuthentication
from rest_framework.authtoken.models import Token  



from rest_framework.permissions import IsAuthenticated
from rest_framework.decorators import api_view, authentication_classes, permission_classes
from rest_framework.generics import CreateAPIView, RetrieveAPIView, ListAPIView, DestroyAPIView, UpdateAPIView
from rest_framework.views import APIView
from rest_framework import status

from custom_permissions.permissions import IsSuperUser
from .serializers import RegisterSerializer, RetrieveUserSerializer, UserOliveTypeSerializer
from .models import NewUser



@api_view(['GET'])
@authentication_classes([TokenAuthentication])
@permission_classes([IsAuthenticated])
def validate_token(request):
    return Response({'message': 'Token is valid'}, status=200)


class RegisterView(CreateAPIView):
    
    def post(self, request):
        serializer = RegisterSerializer(data=request.data)
        if serializer.is_valid():
            user = serializer.save()  # Save the user
            # Create a token for the new user
            token, created = Token.objects.get_or_create(user=user)
            return Response({
                'message': 'User registered successfully',
                'token': token.key  # Return the token in the response
            }, status=status.HTTP_201_CREATED)
        
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
class LogoutView(APIView):
    authentication_classes = [TokenAuthentication]
    permission_classes = [IsAuthenticated]

    def post(self, request):
        try:
            # Get the user's token
            token = Token.objects.get(user=request.user)
            token.delete()  # Delete the token to log the user out
            return Response({"detail": "Successfully logged out."}, status=status.HTTP_200_OK)
        except Token.DoesNotExist:
            return Response({"detail": "No active session found."}, status=status.HTTP_400_BAD_REQUEST)

class GetUserView(RetrieveAPIView):
    queryset = NewUser.objects.all()
    serializer_class=RetrieveUserSerializer
    authentication_classes=[TokenAuthentication]
    permission_classes=[IsAuthenticated]
    
    def get_object(self):
        return self.request.user
    
class GetStaffUsers(ListAPIView):
    queryset = NewUser.objects.filter(is_staff=False)
    serializer_class = RetrieveUserSerializer
    authentication_classes=[TokenAuthentication]
    permission_classes=[IsAuthenticated, IsSuperUser]

class DeleteUser(DestroyAPIView):
    queryset = NewUser.objects.all()
    authentication_classes = [TokenAuthentication]
    permission_classes = [IsAuthenticated, IsSuperUser]  

    def delete(self, request, *args, **kwargs):
        # Retrieve the user ID from the URL
        user_id = self.kwargs.get('pk')
        print(user_id)

        # Get the user instance
        try:
            user = self.get_object()  # Fetch the user based on the ID
            user.delete()  # Delete the user
            return Response(status=status.HTTP_204_NO_CONTENT)  # Return a no content response
        except NewUser.DoesNotExist:
            return Response(
                {"detail": "User not found."},
                status=status.HTTP_404_NOT_FOUND
            )    
            
class AddUserToStaf(UpdateAPIView):
    queryset = NewUser.objects.all()  # Queryset to retrieve all users
    authentication_classes = [TokenAuthentication]
    permission_classes = [IsAuthenticated, IsSuperUser]  # Restrict to superusers only
    serializer_class = RetrieveUserSerializer 
    
    def update(self, request, *args, **kwargs):
        user_id = self.kwargs.get('pk')  # Get the user ID from the URL
        try:
            user = self.get_object()  # Fetch the user based on the ID
            user.is_staff = True  # Set is_staff to True
            user.save()  # Save the updated user instance
            return Response({"detail": "User added to staff successfully."}, status=status.HTTP_200_OK)
        except NewUser.DoesNotExist:
            return Response({"detail": "User not found."}, status=status.HTTP_404_NOT_FOUND)


class ChangeUserOliveTypeView(UpdateAPIView):
    """
    API view to allow superusers to change a user's olive_type.
    """
    queryset = NewUser.objects.all()
    serializer_class = UserOliveTypeSerializer
    permission_classes = [IsAuthenticated, IsSuperUser]  # Ensure only authenticated superusers can access

    def update(self, request, *args, **kwargs):
        # Validate the olive_type before saving
        olive_type = request.data.get('olive_type')
        
        # Check if the provided olive_type is valid
        if olive_type not in [NewUser.GREEN, NewUser.RED, NewUser.BLACK]:
            return Response({"detail": "Invalid olive type."}, status=status.HTTP_400_BAD_REQUEST)
        
        return super().update(request, *args, **kwargs)