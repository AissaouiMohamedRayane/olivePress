from django.db import models
from django.utils.translation import gettext_lazy as _
from django.core.validators import RegexValidator
from django.utils import timezone
from accounts.models import NewUser


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
        
class Zones(models.Model):
    state = models.ForeignKey(States, verbose_name=_("state"), on_delete=models.CASCADE, related_name='zone_from_state')
    zone=models.CharField(_("zone"), max_length=50, unique=True)
    
    def __str__(self):
        return f"{self.state.id} : {self.zone} "

class Customer(models.Model):
    def get_default_user():
        try:
            return NewUser.objects.get(pk=1)
        except NewUser.DoesNotExist:
            return None 
    GREEN = 1
    RED = 2
    BLACK = 3

    OLIVE_TYPE_CHOICES = [
        (GREEN, 'Green'),
        (RED, 'Red'),
        (BLACK, 'Black'),
    ]

    user = models.ForeignKey(NewUser, verbose_name=_("user"), on_delete=models.SET_NULL, null=True)
    full_name=models.CharField(_("first name"), max_length=60, blank=False)

    date_joined = models.DateTimeField(default=timezone.now)

    phone = models.CharField(
        _("phone number"),
        max_length=10,
        blank=True,
        validators=[RegexValidator(r'^\d{10}$', _('Phone number must be exactly 10 digits'))]
    )
    state = models.ForeignKey(States, verbose_name=_("state"), on_delete=models.SET_NULL, related_name='customer_from_state', null=True)
    zone=models.ForeignKey(Zones, verbose_name=_("zone"), on_delete=models.SET_NULL, related_name='customer_from_zone', null=True)
    days_gone=models.IntegerField(_("days gone by"), default=0)
    olive_type = models.IntegerField(choices=OLIVE_TYPE_CHOICES, null=True, blank=True)
    is_printed=models.BooleanField(_("is customer printed"), default=False)
    
    modified = models.BooleanField(_("is customer modified"), default=False)
    modification_date = models.DateTimeField(_("modification date"), auto_now=False, auto_now_add=False, blank=True, null=True)
    modification_user = models.ForeignKey(NewUser, verbose_name=_(""), on_delete=models.SET_NULL, blank=True, null=True, related_name='customer_modified')

    is_active = models.BooleanField(_("is user active"), default=True)
    cancel_reason = models.CharField(_("Reason for cancellation"), max_length=100, blank=True, null=True)
    cancel_date = models.DateTimeField(_("modification date"), auto_now=False, auto_now_add=False, blank=True, null=True)
    cancel_user =models.ForeignKey(NewUser, verbose_name=_(""), on_delete=models.SET_NULL, blank=True, null=True, related_name='customer_canceler')

    
    
    def __str__(self):
        return f"{self.id} {self.full_name}: {self.state.state} {self.zone}"

class Bag(models.Model):
    weight = models.IntegerField(_("bag weight"))
    number = models.IntegerField(_("bags number"))
    customer = models.ForeignKey(Customer, on_delete=models.CASCADE, related_name='bags', null=True)
    def __str__(self):
        return f"id: {self.pk} {self.customer.full_name}: nombre {self.number}"
    

class Container(models.Model):
    number = models.IntegerField(_("containers number"))
    capacity = models.IntegerField(_("container Capacity"))
    customer = models.ForeignKey(Customer, on_delete=models.CASCADE, related_name='containers', null=True)
    def __str__(self):
        return f"{self.customer.full_name}: nombre {self.number}"
