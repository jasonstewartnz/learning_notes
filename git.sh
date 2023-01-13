
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

  ## Connecting with SSH 
  # https://docs.github.com/en/authentication/connecting-to-github-with-ssh/about-ssh
  # "You can also use an SSH key to sign commits"
  # the ssh is proving that it it you that made those changes 
  # (or at least someone with access to your machine - which 
  # should only be you)
# I prefer SSH because I cannot authenticate using a password via HTTP

# For more information, see "Generating a new SSH key and adding it to the ssh-agent", "Adding a new SSH key to your GitHub account" and "About commit signature verification."
# 

# Step 1
# https://docs.github.com/en/authentication/connecting-to-github-with-ssh/generating-a-new-ssh-key-and-adding-it-to-the-ssh-agent
ssh-keygen -t ed25519 -C "jason.stewart@gmail.com"
# <enter> 
# <enter>
# <enter> (backed up existing file. Compare cat files and they are the same)

# start ssh agent
eval "$(ssh-agent -s)"
# add key (but this was already done for me previously)
ssh-add ~/.ssh/id_ed25519

cat ~/.ssh/id_ed25519.pub
# Copy and paste output to GitHub SSH key in settings

cd ~/projects 
git clone git@github.com:jasonstewartnz/gj_dbt_sandbox.git


