# Generated by Django 5.1.1 on 2024-09-30 16:11

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('customer', '0004_rename_state_states_alter_customer_containers_and_more'),
    ]

    operations = [
        migrations.AlterField(
            model_name='customer',
            name='olive_type',
            field=models.CharField(choices=[(1, 'Green'), (2, 'Red'), (3, 'Black')], default=1, max_length=5),
        ),
    ]
