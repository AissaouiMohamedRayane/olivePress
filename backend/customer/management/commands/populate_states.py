from django.core.management.base import BaseCommand
from customer.models import States  # Adjust the import according to your app name

class Command(BaseCommand):
    help = 'Populate the State model with all wilayas of Algeria'

    def handle(self, *args, **kwargs):
        wilayas = [
            {'id':1,'state':"Adrar"},
            {'id':2,'state':"Chlef"},
            {'id':3,'state':"Laghouat"},
            {'id':4,'state':"Oum El Bouaghi"},
            {'id':5,'state':"Batna"},
            {'id':6,'state':"Béjaïa"},
            {'id':7,'state':"Biskra"},
            {'id':8,'state':"Béchar"},
            {'id':9,'state':"Blida"},
            {'id':10,'state':"Bouira"},
            {'id':11,'state':"Tamanrasset"},
            {'id':12,'state':"Tébessa"},
            {'id':13,'state':"Tlemcen"},
            {'id':14,'state':"Tiaret"},
            {'id':15,'state':"Tizi Ouzou"},
            {'id':16,'state':"Algiers"},
            {'id':17,'state':"Djelfa"},
            {'id':18,'state':"Jijel"},
            {'id':19,'state':"Sétif"},
            {'id':20,'state':"Saida"},
            {'id':21,'state':"Skikda"},
            {'id':22,'state':"Sidi Bel Abbès"},
            {'id':23,'state':"Annaba"},
            {'id':24,'state':"Guelma"},
            {'id':25,'state':"Constantine"},
            {'id':26,'state':"Médéa"},
            {'id':27,'state':"Mostaganem"},
            {'id':28,'state':"M'Sila"},
            {'id':29,'state':"Mascara"},
            {'id':30,'state':"Ouargla"},
            {'id':31,'state':"El Bayadh"},
            {'id':32,'state':"Illizi"},
            {'id':33,'state':"Bordj Bou Arréridj"},
            {'id':34,'state':"Boumerdès"},
            {'id':35,'state':"El Tarf"},
            {'id':36,'state':"Tindouf"},
            {'id':37,'state':"Tissemsilt"},
            {'id':38,'state':"El Oued"},
            {'id':39,'state':"Khenchela"},
            {'id':40,'state':"Souk Ahras"},
            {'id':41,'state':"Tipaza"},
            {'id':42,'state':"Mila"},
            {'id':43,'state':"Aïn Defla"},
            {'id':44,'state':"Naama"},
            {'id':45,'state':"Aïn Témouchent"},
            {'id':46,'state':"Ghardaïa"},
            {'id':47,'state':"Relizane"},
            {'id':48,'state':"Bordj Badji Mokhtar"},
            {'id':49,'state':"El M'ghair"},
            {'id':50,'state':"El Menia"},
            {'id':51,'state':"Ouled Djellal"},
            {'id':52,'state':"Timimoun"},
            {'id':53,'state':"Touggourt"},
            {'id':54,'state':"Djanet"},
            {'id':55,'state':"In Salah"},
            {'id':56,'state':"In Guezzam"}
        ]

        # Create instances of State
        for wilaya in wilayas:
            States.objects.create(id= wilaya['id'],state=wilaya['state'])
            self.stdout.write(self.style.SUCCESS(f'Successfully added: {wilaya}'))
