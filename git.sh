
# adds 
git status
git add recap
git commit -m "Initial add for my notes so far"
edit recap
# rename file 
mv recap recap.txt
git status
# manual rename, git figured it out
git rm recap
git add recap.txt
git status
git commit -m "renamed recap file"

history tail 20
open recap.txt 
git add recap.txt 
git commit -m "Added ls statement description"

git push
# failure, research authentication with person keys and SSH 

git push
# sign in with authentication key 

git config --get user.email
git push
# Generate a key so that I can trust the github server
ssh-keygen -t ed25519 -C jason.stewart@gmail.com
cat /home/jasonstewartnz/.ssh/id_ed25519.pub
# copy-pasted to git hub settings

ssh -T git@github.com
# still issues

# Generated person authentication key with permissions to repos and projects
git push
# authenticated here with new key
touch git.txt




# setting up git for django (so far )
  502  git init .
  503  echo "trydjango/trydjango/__pychache__" >> .gitignore
  504  git add trydjango/trydjango/
  505  git status
  506  git add .gitignore
  507  git add requirements.txt
  508  git add trydjango/manage.py
  509  git commit -m "Initial project commit"
  510  history