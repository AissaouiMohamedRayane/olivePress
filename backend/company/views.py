from .serializers import CompanySerializer
from rest_framework import viewsets, authentication, permissions, generics
from .models import Company
from rest_framework.exceptions import ValidationError
from rest_framework.exceptions import NotFound
from rest_framework.response import Response
from rest_framework import status
from .permissions import IsActiveUser

class CompanyViewSet(viewsets.ModelViewSet):
    queryset = Company.objects.all()
    serializer_class = CompanySerializer
    authentication_classes = [authentication.TokenAuthentication]

    def get_permissions(self):
        if self.request.method in permissions.SAFE_METHODS:  # GET, HEAD, OPTIONS
            return [IsActiveUser()]  # Allow access to non-admin users for GET requests
        return [permissions.IsAdminUser()]  
    def perform_create(self, serializer):
        try:
            print(self.request.user)
            serializer.save()
        except ValidationError as e:
            raise ValidationError(detail=str(e))
    
    def list(self, request, *args, **kwargs):
        """
        Override to handle retrieving a single Company instance.
        """
        if Company.objects.exists():
            company = Company.objects.first()
            serializer = self.get_serializer(company)
            return Response({'company': serializer.data, 'exists': True}, status=status.HTTP_200_OK)
        else:
            return Response({'company': None, 'exists': False}, status=status.HTTP_200_OK)
        