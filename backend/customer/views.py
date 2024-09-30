from rest_framework.generics import CreateAPIView, ListAPIView
from rest_framework.authentication import TokenAuthentication
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from rest_framework import status

from .models import Customer, States
from .models import States, Bag

from .serializers import CustomerSerializer, StatesSerializer

from custom_permissions.permissions import IsActiveUser


class CreateCustomerView(CreateAPIView):
    queryset = Customer.objects.all()
    serializer_class = CustomerSerializer
    authentication_classes = [TokenAuthentication]
    permission_classes = [IsAuthenticated]

    def post(self, request, *args, **kwargs):
        # Deserialize the incoming data
        print(request.data)
        serializer = CustomerSerializer(data=request.data)

        # Validate the data
        if serializer.is_valid():
            # Save the new customer and its related data
            serializer.save()

            # Return a success response
            return Response(serializer.data, status=status.HTTP_201_CREATED)

        # Return an error response if validation fails
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

class ListStates(ListAPIView):
    queryset= States.objects.all()
    serializer_class = StatesSerializer
    authentication_classes=[TokenAuthentication]
    permission_classes=[IsAuthenticated, IsActiveUser]