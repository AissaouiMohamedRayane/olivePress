from django.db import models
from django.utils.translation import gettext_lazy as _
from django.core.validators import RegexValidator
from django.utils import timezone
from datetime import date


def current_date():
    return timezone.now().date()



   
    

    
class States(models.Model):
    id=models.IntegerField(_("id"), unique=True, blank=False, primary_key=True)
    state=models.CharField(_("state"), max_length=50, unique=True)
    def __str__(self):
        return f"{self.id}: {self.state}" 
    
    def save(self, *args, **kwargs):
        # Convert the state to lowercase before saving
        self.state = self.state.capitalize()
        super(States, self).save(*args, **kwargs)
    class Meta:
        ordering = ['id'] 

class Customer(models.Model):
    GREEN = 1
    RED = 2
    BLACK = 3

    OLIVE_TYPE_CHOICES = [
        (GREEN, 'Green'),
        (RED, 'Red'),
        (BLACK, 'Black'),
    ]


    full_name=models.CharField(_("first name"), max_length=60, blank=False)
    date_joined = models.DateField(default=current_date)

    phone = models.CharField(
        _("phone number"),
        max_length=10,
        blank=True,
        validators=[RegexValidator(r'^\d{10}$', _('Phone number must be exactly 10 digits'))]
    )
    state = models.ForeignKey(States, verbose_name=_("state"), on_delete=models.CASCADE, related_name='customer_from_state')
    zone=models.CharField(_("Zone"), max_length=30)
    olive_type = models.CharField(max_length=5, choices=OLIVE_TYPE_CHOICES, default=GREEN)
    def __str__(self):
        return f"{self.id} {self.full_name}: {self.state.state} {self.zone}"

class Bag(models.Model):
    weight = models.IntegerField(_("bag weight"))
    number = models.IntegerField(_("bags number"))
    customer = models.ForeignKey(Customer, on_delete=models.CASCADE, related_name='bags', null=True)
    def __str__(self):
        return f"{self.customer.full_name}: nombre {self.number}"

class Container(models.Model):
    number = models.IntegerField(_("containers number"))
    capacity = models.IntegerField(_("container Capacity"))
    customer = models.ForeignKey(Customer, on_delete=models.CASCADE, related_name='containers', null=True)
    def __str__(self):
        return f"{self.customer.full_name}: nombre {self.number}"
