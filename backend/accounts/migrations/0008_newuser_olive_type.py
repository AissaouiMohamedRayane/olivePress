# Generated by Django 5.1.1 on 2024-10-12 15:08

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('accounts', '0007_alter_newuser_is_active'),
    ]

    operations = [
        migrations.AddField(
            model_name='newuser',
            name='olive_type',
            field=models.IntegerField(choices=[(1, 'Green'), (2, 'Red'), (3, 'Black')], default=None),
        ),
    ]
