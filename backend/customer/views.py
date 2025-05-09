from rest_framework.generics import CreateAPIView, ListAPIView, UpdateAPIView
from rest_framework.authentication import TokenAuthentication
from rest_framework.response import Response
from rest_framework import status

from .models import Customer, States, Zones
from .models import States
from django.shortcuts import get_object_or_404

from .serializers import CustomerSerializer, StatesSerializer, CustomerListSerializer, ZonesSerializer, BagSerializer

from custom_permissions.permissions import IsActiveUser


class CreateCustomerView(CreateAPIView):
    queryset = Customer.objects.all()
    serializer_class = CustomerSerializer
    authentication_classes = [TokenAuthentication]
    permission_classes = [IsActiveUser]

    def post(self, request, *args, **kwargs):
        # Deserialize the incoming data
        serializer = self.get_serializer(data=request.data)
        serializer.context['request'] = request  # Set the request in the context


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

        # Deserialize the incoming data into the existing customer instance
        serializer = self.get_serializer(customer, data=request.data)
        serializer.context['request'] = request  # Set the request in the context


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
    
class ListZones(ListAPIView):
    serializer_class = ZonesSerializer
    authentication_classes=[TokenAuthentication]
    permission_classes=[ IsActiveUser]
    
    def get_queryset(self):
        state = self.kwargs.get('pk')
        queryset = Zones.objects.filter(state = state)
       

        return queryset
    
class ListBags(ListAPIView):
    serializer_class=BagSerializer
    authentication_classes=[TokenAuthentication]
    permission_classes=[IsActiveUser]
    def get_queryset(self):
        customer_id = self.kwargs.get('pk')
        customer = get_object_or_404(Customer, pk=customer_id)
        if self.request.user.olive_type == customer.olive_type:
              
            return customer.bags.all() 
        
        return Response({'response': "not your olive type"}, status=status.HTTP_401_UNAUTHORIZED)    