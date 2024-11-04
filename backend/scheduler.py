# scheduler.py
import schedule
import time
import os

def run_command():
    os.system('python manage.py generate_excel')

# Schedule the task every 10 minutes
schedule.every(1).seconds.do(run_command)

while True:
    schedule.run_pending()
    time.sleep(1)
