
# create directory
mkdir ~/projects/try-django
cd ~/projects/try-django

# Create vs code workspace and work in vs code terminal

# create virtual env
python3 -m venv try-django
source bin/activate

# pip install as per django project
pip install Django==4.1.4
pip freeze >> requirements.txt

# start django project
python -m django startproject trydjango

# start server
python trydjango/manage.py runserver

# probably should also git init here


