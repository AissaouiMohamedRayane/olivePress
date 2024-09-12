from rest_framework.response import Response
from rest_framework.decorators import api_view

from rest_framework.authentication import TokenAuthentication
from rest_framework.authtoken.models import Token  



from rest_framework.permissions import IsAuthenticated, IsAdminUser
from rest_framework.decorators import api_view, authentication_classes, permission_classes
from rest_framework.generics import CreateAPIView, RetrieveAPIView
from rest_framework import status

from .serializers import RegisterSerializer, RetrieveUserSerializer
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

class GetUserView(RetrieveAPIView):
    queryset = NewUser.objects.all()
    serializer_class=RetrieveUserSerializer
    authentication_classes=[TokenAuthentication]
    permission_classes=[IsAuthenticated]
    
    def get_object(self):
        return self.request.user