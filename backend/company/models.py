from django.db import models
from django.utils.translation import gettext_lazy as _
from django.utils import timezone
from django.core.validators import RegexValidator
from django.core.exceptions import ValidationError


class Company (models.Model):
    name=models.CharField(_("company"), max_length=50, blank=False)
    address=models.CharField(_("address"), max_length=80, blank=False)
    phone1 = models.CharField(
        _("phone number 1"),
        blank=False,
        max_length=10,
        validators=[RegexValidator(r'^\d{10}$', _('Phone number must be exactly 10 digits'))]
    )
    phone2 = models.CharField(
        _("phone number 2"),
        blank=True,
        max_length=10,

        validators=[RegexValidator(r'^\d{10}$', _('Phone number must be exactly 10 digits'))]
    )
    sign=models.CharField(_("sign"), max_length=100, blank=True)
    session = models.CharField(
        _("session"),
        max_length=9,  
        blank=True,
        null=True,
        # Format like "2023/2024" requires 9 characters
        validators=[RegexValidator(r'^\d{4}/\d{4}$', _('Session must be in the format YYYY/YYYY'))]
    )
    session_start = models.DateField(_("session start"), blank=True, null=True)
    price_green_olive=models.IntegerField(_("price of green olive"), blank=False,  default=0)
    price_tayeb_olive=models.IntegerField(_("price of tayb olive"), blank=False, default=0)
    price_dro_olive=models.IntegerField(_("price of drew olive"), blank=False, default=0)
    def clean(self):
        super().clean()
        start_year, end_year = map(int, self.session.split('/'))
        if end_year != start_year + 1:
            raise ValidationError(_('End year must be exactly one year after start year.'))
        
    def save(self, *args, **kwargs):
        if self.pk is None:  # Only check if this is a new instance
            if Company.objects.exists():
                raise ValidationError(_("Only one Company instance is allowed."))
        super().save(*args, **kwargs)