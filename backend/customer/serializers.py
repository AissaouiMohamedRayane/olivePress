from rest_framework import serializers
from .models import Customer, States, Bag, Container, Zones
from accounts.models import NewUser
from django.db import transaction
from django.utils import timezone


# Inline serializer for Bags
class BagSerializer(serializers.ModelSerializer):
    id = serializers.IntegerField(required=False)    
    class Meta:
        model = Bag
        fields = [ 'id', 'weight', 'number']
    def create(self, validated_data):
        # Remove the 'id' from validated_data before creating a new instance
        validated_data.pop('id', None)  # This will ensure 'id' is not used during creation
        return super().create(validated_data)
    def update(self, instance, validated_data):
        # Optionally, handle 'id' in the same way during updates
        validated_data.pop('id', None)  # Ensure 'id' is not used during update
        return super().update(instance, validated_data)

# Inline serializer for Containers
class ContainerSerializer(serializers.ModelSerializer):
    class Meta:
        model = Container
        fields = ['capacity', 'number']
class StatesSerializer(serializers.ModelSerializer):
    class Meta:
        model = States
        fields = ['id', 'state']
class ZonesSerializer(serializers.ModelSerializer):
    class Meta:
        model = Zones
        fields = ['id', 'zone']

class CustomerSerializer(serializers.ModelSerializer):
    # Define nested serializers
    bags = BagSerializer(many=True)
    containers = ContainerSerializer(many=True)
    state = serializers.PrimaryKeyRelatedField(
        queryset=States.objects.all()
    )  # Include nested serializer for state details.
    zone = serializers.CharField(max_length=70)


    class Meta:
        model = Customer
        fields = ['id','user', 'full_name', 'date_joined', 'phone', 'state', 'zone', 
            'bags', 'containers', 'olive_type', 'days_gone', 'is_printed','is_active', 'cancel_reason']

    def create(self, validated_data):
        # Extract bags and containers data from the validated data
        bags_data = validated_data.pop('bags')
        containers_data = validated_data.pop('containers')

        # Handle the zone as a string
        zone_name = validated_data.pop('zone')  # Get the zone name (string)
        state_id = validated_data['state'].id  # Get the state ID

        zone, created = Zones.objects.get_or_create(zone=zone_name, state_id = state_id)  # Create or get the zone
        validated_data['zone'] = zone  # Set the zone instance in validated_data
        validated_data['user'] = self.context['request'].user
        # Now create the customer with the validated data (excluding bags and containers)
        customer = Customer.objects.create(**validated_data)

        # Create related Bag instances, associating them with the customer
        for bag_data in bags_data:
            bag_data.pop('id')
            Bag.objects.create(customer=customer, **bag_data)

        # Create related Container instances, associating them with the customer
        for container_data in containers_data:
            Container.objects.create(customer=customer, **container_data)

        return customer
    def update(self, instance, validated_data):

    # Extract bags, containers, and zone data from the validated data
        bags_data = validated_data.pop('bags', [])
        containers_data = validated_data.pop('containers', [])
        zone_data = validated_data.pop('zone')
        state_id = validated_data['state'].id

        with transaction.atomic():
            # Update the customer fields
            instance.full_name = validated_data.get('full_name', instance.full_name)
            instance.phone = validated_data.get('phone', instance.phone)
            instance.state = validated_data.get('state', instance.state)
            instance.olive_type = validated_data.get('olive_type', instance.olive_type)
            instance.days_gone = validated_data.get('days_gone', instance.days_gone)
            instance.is_printed = validated_data.get('is_printed', instance.is_printed)
            instance.is_active = validated_data.get('is_active', instance.is_active)
            instance.cancel_reason = validated_data.get('cancel_reason', instance.cancel_reason)
            if validated_data.get('is_active'):
                instance.modified = True
                instance.modification_date = timezone.now()
                instance.modification_user = self.context['request'].user
            else:
                instance.cancel_date = timezone.now()
                instance.cancel_user = self.context['request'].user
                

            # Handle zone update if new zone data is provided
            if zone_data:
                zone, created = Zones.objects.get_or_create(zone=zone_data, state_id = state_id)  # Create or get the zone
                instance.zone = zone

            instance.save()
            new_bag_ids = [bag_data.get('id') for bag_data in bags_data if 'id' in bag_data]  # Set of new bag IDs
            
        
            # Delete bags that are not in the new bags list
            for bag in instance.bags.all():
                
                if bag.id not in new_bag_ids:
                    print('deleted')
                    bag.delete()

            # Update bags: delete old ones and recreate for simplicity
            existing_bags = {bag.id: bag for bag in instance.bags.all()}  # Keep track of existing bags by ID
            for bag_data in bags_data:
                bag_id = bag_data.get('id')  # Assume each bag_data dict has an 'id' field
                if bag_id and bag_id in existing_bags:
                    # Update existing bag
                    for attr, value in bag_data.items():
                        setattr(existing_bags[bag_id], attr, value)
                    existing_bags[bag_id].save()  # Save the updated bag
                else:
                    # Create a new bag if it doesn't exist
                    bag_data.pop('id')
                    Bag.objects.create(customer=instance, **bag_data)

            # Update containers: delete old ones and recreate for simplicity
            instance.containers.all().delete()
            for container_data in containers_data:
                Container.objects.create(customer=instance, **container_data)

        return instance

class CustomerListSerializer(serializers.ModelSerializer):
    bags = BagSerializer(many=True, read_only=True)
    containers = ContainerSerializer(many=True, read_only=True)
    state = StatesSerializer(read_only=True)  # Use nested serializer to display state details.
    zone = ZonesSerializer(read_only=True)

    class Meta:
        model = Customer
        fields = [
            'id', 'full_name', 'date_joined', 'phone', 'state', 'zone', 
            'bags', 'containers', 'olive_type', 'days_gone', 'is_printed','is_active', 'cancel_reason'
        ]
        read_only_fields = fields 
        
class CustomerCancelSerializer(serializers.ModelSerializer):

    class Meta:
        model = Customer
        fields = ['is_active', 'cancel_reason']