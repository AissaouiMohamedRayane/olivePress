from .serializers import CompanySerializer
from rest_framework import viewsets, authentication
from rest_framework.permissions import IsAdminUser, SAFE_METHODS
from rest_framework.generics import UpdateAPIView
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
        if self.request.method in SAFE_METHODS:  # GET, HEAD, OPTIONS
            return [IsActiveUser()]  # Allow access to non-admin users for GET requests
        return [IsAdminUser()]  
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
    def update(self, request, *args, **kwargs):
        """
        Handle updating a Company instance.
        """
        partial = kwargs.pop('partial', False)  # Check if the update is partial
        instance = self.get_object()  # Get the object to update
        serializer = self.get_serializer(instance, data=request.data, partial=partial)  # Serialize the data
        serializer.is_valid(raise_exception=True)  # Validate the data
        self.perform_update(serializer)  # Perform the update
        return Response(serializer.data) 