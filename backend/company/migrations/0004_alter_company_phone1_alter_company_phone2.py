# Generated by Django 5.1.1 on 2024-09-11 19:19

import django.core.validators
from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('company', '0003_company_session'),
    ]

    operations = [
        migrations.AlterField(
            model_name='company',
            name='phone1',
            field=models.CharField(max_length=10, validators=[django.core.validators.RegexValidator('^\\d{10}$', 'Phone number must be exactly 10 digits')], verbose_name='phone number 1'),
        ),
        migrations.AlterField(
            model_name='company',
            name='phone2',
            field=models.CharField(blank=True, max_length=10, validators=[django.core.validators.RegexValidator('^\\d{10}$', 'Phone number must be exactly 10 digits')], verbose_name='phone number 2'),
        ),
    ]
