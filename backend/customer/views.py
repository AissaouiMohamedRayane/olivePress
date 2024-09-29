from rest_framework.generics import CreateAPIView
from .models import Customer
from .serializers import CustomerSerializer

class CreateCustomerView(CreateAPIView):
    queryset = Customer.objects.all()
    serializer_class = CustomerSerializer