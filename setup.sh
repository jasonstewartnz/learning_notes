# install vs code

# install steam from apt
sudo apt-get install steam

# install vs code from installer file

# install docker 
# See lines 1 - 71 of ./docker.sh

# add code command to path
cat << EOF >> ~/.zprofile
# Add Visual Studio Code (code)
export PATH="\$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"
EOF

# password holder setup
pass init "ZX2C4 Password Storage Key"

# restart docker 
service docker stop
rm ~/.docker/config.json
service docker start

# docker 
docker login -u jasonstewartnz

# venv for setting up projects 
sudo apt install python3.10-venv

# set up non-encrypted private key for Snowsql


# generate key for key value pair authentication
# https://docs.snowflake.com/en/user-guide/key-pair-auth.html
openssl genrsa 2048 | openssl pkcs8 -topk8 -v2 des3 -inform PEM -out rsa_key.p8 -nocrypt

openssl rsa -in rsa_key.p8 -pubout -out rsa_key.pub

# Configure the client to use key-pair authentication
# https://docs.snowflake.com/en/user-guide/snowsql-start.html#label-snowsql-key-pair-authn-rotation
# added private_key_file to snowsql config
snowsql -a $SNOWFLAKE_ACCOUNT -u $SNOWFLAKE_USERNAME --private-key-path ~/rsa_key.p8
