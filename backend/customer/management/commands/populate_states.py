from django.core.management.base import BaseCommand
from customer.models import States  # Adjust the import according to your app name

class Command(BaseCommand):
    help = 'Populate the State model with all wilayas of Algeria'

    def handle(self, *args, **kwargs):
        wilayas = [
          {'id': 1, 'state': "أدرار"},
          {'id': 2, 'state': "الشلف"},
          {'id': 3, 'state': "الأغواط"},
          {'id': 4, 'state': "أم البواقي"},
          {'id': 5, 'state': "باتنة"},
          {'id': 6, 'state': "بجاية"},
          {'id': 7, 'state': "بسكرة"},
          {'id': 8, 'state': "بشار"},
          {'id': 9, 'state': "البليدة"},
          {'id': 10, 'state': "البويرة"},
          {'id': 11, 'state': "تمنراست"},
          {'id': 12, 'state': "تبسة"},
          {'id': 13, 'state': "تلمسان"},
          {'id': 14, 'state': "تيارت"},
          {'id': 15, 'state': "تيزي وزو"},
          {'id': 16, 'state': "الجزائر"},
          {'id': 17, 'state': "الجلفة"},
          {'id': 18, 'state': "جيجل"},
          {'id': 19, 'state': "سطيف"},
          {'id': 20, 'state': "سعيدة"},
          {'id': 21, 'state': "سكيكدة"},
          {'id': 22, 'state': "سيدي بلعباس"},
          {'id': 23, 'state': "عنابة"},
          {'id': 24, 'state': "قالمة"},
          {'id': 25, 'state': "قسنطينة"},
          {'id': 26, 'state': "المدية"},
          {'id': 27, 'state': "مستغانم"},
          {'id': 28, 'state': "المسيلة"},
          {'id': 29, 'state': "معسكر"},
          {'id': 30, 'state': "ورقلة"},
          {'id': 31, 'state': "البيض"},
          {'id': 32, 'state': "إيليزي"},
          {'id': 33, 'state': "برج بوعريريج"},
          {'id': 34, 'state': "بومرداس"},
          {'id': 35, 'state': "الطارف"},
          {'id': 36, 'state': "تندوف"},
          {'id': 37, 'state': "تيسمسيلت"},
          {'id': 38, 'state': "الوادي"},
          {'id': 39, 'state': "خنشلة"},
          {'id': 40, 'state': "سوق أهراس"},
          {'id': 41, 'state': "تيبازة"},
          {'id': 42, 'state': "ميلة"},
          {'id': 43, 'state': "عين الدفلى"},
          {'id': 44, 'state': "النعامة"},
          {'id': 45, 'state': "عين تموشنت"},
          {'id': 46, 'state': "غرداية"},
          {'id': 47, 'state': "غليزان"},
          {'id': 48, 'state': "برج باجي مختار"},
          {'id': 49, 'state': "المغير"},
          {'id': 50, 'state': "المنيعة"},
          {'id': 51, 'state': "أولاد جلال"},
          {'id': 52, 'state': "تيميمون"},
          {'id': 53, 'state': "تقرت"},
          {'id': 54, 'state': "جانت"},
          {'id': 55, 'state': "عين صالح"},
          {'id': 56, 'state': "عين قزام"}
        ]

        # Create instances of State
        for wilaya in wilayas:
            States.objects.create(id= wilaya['id'],state=wilaya['state'])
            self.stdout.write(self.style.SUCCESS(f'Successfully added: {wilaya}'))
