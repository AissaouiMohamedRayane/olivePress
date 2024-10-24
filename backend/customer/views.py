from rest_framework.generics import CreateAPIView, ListAPIView, UpdateAPIView
from rest_framework.authentication import TokenAuthentication
from rest_framework.permissions import IsAuthenticated
from rest_framework.response import Response
from rest_framework import status

from .models import Customer, States
from .models import States
from django.shortcuts import get_object_or_404

from .serializers import CustomerSerializer, StatesSerializer, CustomerListSerializer, CustomerCancelSerializer

from custom_permissions.permissions import IsActiveUser


class CreateCustomerView(CreateAPIView):
    queryset = Customer.objects.all()
    serializer_class = CustomerSerializer
    authentication_classes = [TokenAuthentication]
    permission_classes = [IsActiveUser]

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
        print(serializer.errors)  # Add this line


        # Return an error response if validation fails
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
    
class ModifyCustomerView(UpdateAPIView):
    queryset = Customer.objects.all()
    serializer_class = CustomerSerializer
    authentication_classes = [TokenAuthentication]
    permission_classes = [IsActiveUser]
    lookup_field = 'pk'  # Assuming you're using 'id' or 'pk' to identify the customer

    def put(self, request, *args, **kwargs):
        # Fetch the existing customer instance
        customer = self.get_object()
        print(request.data)

        # Deserialize the incoming data into the existing customer instance
        serializer = self.get_serializer(customer, data=request.data)

        # Validate the data
        if serializer.is_valid():
            # Save the updated customer data
            serializer.save()

            # Return a success response
            return Response(serializer.data, status=status.HTTP_200_OK)

        # Return an error response if validation fails
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    def patch(self, request, *args, **kwargs):
        # Fetch the existing customer instance
        customer = self.get_object()
        print(request.data)

        # Deserialize the incoming partial data into the existing customer instance
        serializer = self.get_serializer(customer, data=request.data, partial=True)

        # Validate the data
        if serializer.is_valid():
            # Save the updated customer data
            serializer.save()

            # Return a success response
            return Response(serializer.data, status=status.HTTP_200_OK)

        # Return an error response if validation fails
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

class ListStates(ListAPIView):
    queryset= States.objects.all()
    serializer_class = StatesSerializer
    authentication_classes=[TokenAuthentication]
    permission_classes=[ IsActiveUser]
    
class SetPrintedView(UpdateAPIView):
    queryset = Customer.objects.all()
    serializer_class = CustomerSerializer
    authentication_classes=[TokenAuthentication]
    permission_classes=[ IsActiveUser]

    def update(self, request, *args, **kwargs):
        customer = self.get_object()
        if not customer.is_printed:
            customer.is_printed = True
            customer.save()
            serializer = self.get_serializer(customer)
            return Response(serializer.data, status=status.HTTP_200_OK)
        else:
            return Response({'response': 'Customer is already printed'}, status=status.HTTP_400_BAD_REQUEST)
        


class CustomerSearchView(ListAPIView):
    serializer_class = CustomerListSerializer
    authentication_classes=[TokenAuthentication]
    permission_classes=[ IsActiveUser]

    def get_queryset(self):
        """
        Optionally restricts the returned customers to a name or id query,
        by filtering against a `name` or `id` value provided in the `name` query parameter.
        """
        user = self.request.user
        queryset = Customer.objects.filter(olive_type=user.olive_type)

        # Get the `name` query parameter, which can either be a name or an ID
        name_or_id = self.request.query_params.get('name', None)

        if name_or_id is not None:
            try:
                # Try to convert `name_or_id` to an integer (assuming it's an ID)
                customer_id = int(name_or_id)
                # If successful, filter by `id`
                queryset = queryset.filter(pk=customer_id)
            except ValueError:
                # If it's not an integer, assume it's a name and filter by `full_name`
                queryset = queryset.filter(full_name__icontains=name_or_id)

        return queryset