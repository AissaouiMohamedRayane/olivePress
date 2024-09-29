from rest_framework import serializers
from .models import Customer, Bags, Containers

class CustomerSerializer(serializers.ModelSerializer):
    class Meta:
        model = Customer
        fields = ['first_name', 'last_name', 'date_joined', 'phone', 'state', 'zone', 'bags', 'Containers', 'olive_type']

    # You can add validation here if needed
    def create(self, validated_data):
        bags_data = validated_data.pop('bags')
        containers_data = validated_data.pop('Containers')
        
        # Create Customer instance
        customer = Customer.objects.create(**validated_data)
        
        # Add Bags and Containers relationships
        customer.bags.set(bags_data)
        customer.Containers.set(containers_data)
        
        return customer
