from rest_framework import serializers
from .models import Customer, States, Bag, Container

# Inline serializer for Bags
class BagSerializer(serializers.ModelSerializer):
    class Meta:
        model = Bag
        fields = ['weight', 'number']

# Inline serializer for Containers
class ContainerSerializer(serializers.ModelSerializer):
    class Meta:
        model = Container
        fields = ['capacity', 'number']

class CustomerSerializer(serializers.ModelSerializer):
    # Define nested serializers
    bags = BagSerializer(many=True)
    containers = ContainerSerializer(many=True)

    class Meta:
        model = Customer
        fields = ['full_name', 'date_joined', 'phone', 'state', 'zone', 'bags', 'containers', 'olive_type', 'days_gone']

    def create(self, validated_data):
        # Extract bags and containers data from the validated data
        bags_data = validated_data.pop('bags')
        containers_data = validated_data.pop('containers')

        # Now create the customer with the validated data (excluding bags and containers)
        customer = Customer.objects.create(**validated_data)

        # Create related Bag instances, associating them with the customer
        for bag_data in bags_data:
            Bag.objects.create(customer=customer, **bag_data)

        # Create related Container instances, associating them with the customer
        for container_data in containers_data:
            Container.objects.create(customer=customer, **container_data)

        return customer




class StatesSerializer(serializers.ModelSerializer):
    class Meta:
        model = States
        fields = ['id', 'state']