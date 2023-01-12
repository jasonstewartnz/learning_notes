Recap of pop os learning
for 
do 
	command 
done
printf 'Hello, World!'



ls -l
chmod u=rwx <filename>

nano
CTRL+K (cut)
CTRL+U (paste)

lspci (hardware)
top (processes)
ps aux |sort -rnk 4 | head -5

super+shift+down (drags window)
super+ctrl+down (nagivates only)
super+m (maximize window/windowed frame)

find . -type f -amin "$recently"

challenge: install presto db
call it from python
build something that reads from the net and puts it in a database

# may not be best practice
$PATH=`cat newpath.txt`

# create sub-terminal
bash --login


# idea should be to rerun .bashrc and start that file with deleting the PATH and rebuilding

# etc is configuration folder



# virtual envs 
# Great article on virtual env
# https://www.infoworld.com/article/3239675/virtualenv-and-venv-python-virtual-environments-explained.html


# create
python -m venv /path/to/directory
or 
virtualenv airflow2

source ./.venv/airflow/bin/activate


# nice way to present files
# -l - long format
# -A - includes hidden files, excludes current and parent directories
# -F - includes / indicator for directories
ls -l -AF

git clone https://github.com/jasonstewartnz/learning_notes.git

# show that we have a .git folder
ls -l -A


cd learning_notes/
ls -l -AF
# bring file into repository from parent folder
mv ../recap ./recap
ls
ls -l -AF

history | tail -n 50

git diff HEAD

sudo chown [username]:docker /var/run/docker.sock

# initialize password holder
pass init # fail
# reading: https://www.passwordstore.org/
# pass init "ZX2C4 Password Storage Key"

# jasonstewartnz@pop-os:~/projects/docker/getting-started$ docker login -u jasonstewartnz
# Password: 
# Error saving credentials: error storing credentials - err: exit status 1, out: `error storing credentials - err: exit status 1, out: `exit status 1: gpg: ZX2C4 Password Storage Key: skipped: No public key
# gpg: [stdin]: encryption failed: No public key
# Password encryption aborted.``
