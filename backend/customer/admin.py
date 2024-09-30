from django.contrib import admin
from .models import States, Customer, Bag, Container
# Register your models here.
admin.site.register(States)
admin.site.register(Customer)
admin.site.register(Bag)
admin.site.register(Container)