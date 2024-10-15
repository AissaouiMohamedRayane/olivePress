from django.db import models
from django.utils.translation import gettext_lazy as _
from django.contrib.auth.models import AbstractBaseUser, PermissionsMixin, BaseUserManager
from django.utils import timezone
from django.core.validators import RegexValidator




class CustomAccountManager (BaseUserManager):
    def create_user(self,  username, password= None, **other_fields):
        if not username:
            raise ValueError(_("You must provied an email addres"))
        user = self.model( username = username, **other_fields)
        user.set_password(password)
        user.save(using=self._db)
        return user
    
    def create_superuser(self,  username, password=None, **other_fields):
        other_fields.setdefault('is_staff', True)
        other_fields.setdefault('is_active', True)
        other_fields.setdefault('is_superuser', True)
        other_fields.setdefault('olive_type', NewUser.GREEN)

        
        return self.create_user( username, password, **other_fields)
    

class NewUser (AbstractBaseUser, PermissionsMixin):
    GREEN = 1
    RED = 2
    BLACK = 3

    OLIVE_TYPE_CHOICES = [
        (GREEN, 'Green'),
        (RED, 'Red'),
        (BLACK, 'Black'),
    ]
    
    username = models.CharField(_("username"), max_length=50, unique=True)
    date_joined = models.DateField(default=timezone.now)
    phone = models.CharField(
        _("phone number"),
        max_length=10,
        blank=True,
        validators=[RegexValidator(r'^\d{10}$', _('Phone number must be exactly 10 digits'))]
    )
    olive_type = models.IntegerField(choices=OLIVE_TYPE_CHOICES, null=True, blank=True)
    
    
    is_active = models.BooleanField(default=True)
    is_staff = models.BooleanField(default=False)
    
    objects = CustomAccountManager()
    
    USERNAME_FIELD = 'username'
    
    
    def __str__(self):
        return f"{self.username}"