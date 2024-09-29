from django.db import models
from django.utils.translation import gettext_lazy as _
from django.core.validators import RegexValidator
from django.utils import timezone

class Bags(models.Model):
    weight = models.IntegerField(_("bag weight"))
    number = models.IntegerField(_("bags number"))
    
class Containers(models.Model):
    number = models.IntegerField(_("containers number"))
    capacity = models.IntegerField(_("container Capacity"))



class Customer(models.Model):
    
    GREEN = 'green'
    RED = 'red'
    BLACK = 'black'

    OLIVE_TYPE_CHOICES = [
        (GREEN, 'Green'),
        (RED, 'Red'),
        (BLACK, 'Black'),
    ]


    first_name=models.CharField(_("first name"), max_length=50, blank=False)
    last_name=models.CharField(_("last name"), max_length=50, blank=False)
    date_joined = models.DateField(default=timezone.now)

    phone = models.CharField(
        _("phone number"),
        max_length=10,
        blank=True,
        validators=[RegexValidator(r'^\d{10}$', _('Phone number must be exactly 10 digits'))]
    )
    state=models.CharField(_("state"), max_length=30)
    zone=models.CharField(_("state"), max_length=30)
    bags=models.ManyToManyField(Bags, verbose_name=_('bags'), related_name="customer_bags")
    Containers=models.ManyToManyField(Containers, verbose_name=_('bags'), related_name="customer_containers")
    olive_type = models.CharField(max_length=5, choices=OLIVE_TYPE_CHOICES, default=GREEN)
