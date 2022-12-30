# codingforentrepreneurs tutorial repo
# youtube: https://youtu.be/zgQ4WFGMgRM
# https://github.com/codingforentrepreneurs/Try-Django-3.2


# create directory
mkdir ~/projects/try-django
cd ~/projects/try-django

# Create vs code workspace and work in vs code terminal

# create virtual env
python3 -m venv .
source bin/activate

# pip install as per django project
pip install Django==4.1.4
pip freeze > requirements.txt

# choose python interpreter from within venv folder
# ~/projects/try-django/bin/python3

# start django project
python3 -m django startproject trydjango

# start server
python3 trydjango/manage.py runserver

# probably should also git init here






