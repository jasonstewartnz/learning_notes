
https://docker-curriculum.com/
install 
https://docs.docker.com/engine/install/ubuntu/
https://docs.docker.com/engine/install/linux-postinstall/

Groups
/etc/group - contains config
getent group docker

not done: https://docs.docker.com/engine/install/linux-postinstall/#configure-docker-to-start-on-boot-with-systemd

# busybox

docker pull busybox
docker images
# run a command within the container
docker run busybox echo "hello from busybox"

# running interactively with sh
docker run -it busybox sh
# It makes sense to spend some time getting comfortable with it. 
# To find out more about run, use docker run --help to see a list of all flags it supports.

# clean up exited containers
docker rm $(docker ps -a -q -f status=exited)
# --rm flag that can be passed to docker run which automatically deletes the container once it''s exited from.
# you can also delete images that you no longer need by running docker rmi.

# list container stats 
docker stats 
docker kill <container_id>
# kill all containers
docker kill $(docker ps -q)

# installing docker desktop
# https://docs.docker.com/desktop/install/linux-install/
# requires install kvm virtualization
# https://docs.docker.com/desktop/install/linux-install/#kvm-virtualization-support
modprobe kvm
modprobe kvm_amd # throws error

# sudo /usr/sbin/kvm-ok
# INFO: /dev/kvm does not exist
# HINT:   sudo modprobe kvm_amd
# INFO: Your CPU supports KVM extensions
# INFO: KVM (svm) is disabled by your BIOS
# HINT: Enter your BIOS setup and enable Virtualization Technology (VT),
#       and then hard poweroff/poweron your system
# KVM acceleration can NOT be used

# going to BIOS to enable virtualization

# not found
# trying: https://techlibrary.hpe.com/docs/iss/proliant-gen10-uefi/GUID-5F2EFF02-A6E6-45C1-985C-143135D44298.html

# ok, in BIOS, searched for SVM 
# found setting SVM enable changed from disabled

# ok, now this command works: 
modprobe kvm_amd 
lsmod | grep kvm
# output: 
# kvm_amd               167936  0
# ccp                   126976  1 kvm_amd
# kvm                  1089536  1 kvm_amd
# irqbypass              16384  1 kvm
ls -al /dev/kvm
sudo usermod -aG kvm $USER

reboot # so that group membership will be recognized


# Followed these steps
# https://docs.docker.com/desktop/install/ubuntu/#install-docker-desktop


# Set up Docker’s package repository.

# Download latest DEB package.

# Install the package with apt as follows:
sudo apt-get update
# sudo apt-get install ./docker-desktop-<version>-<arch>.deb
sudo apt-get install ~/Downloads/docker-desktop-4.15.0-amd64.deb

# This message shows at the end of the install
# N: Download is performed unsandboxed as root as file '/home/jasonstewartnz/Downloads/docker-desktop-4.15.0-amd64.deb' couldn't be accessed by user '_apt'. - pkgAcquire::Run (13: Permission denied)

# The post-install script:
# These steps not done
#     Sets the capability on the Docker Desktop binary to map privileged ports and set resource limits.
#     Adds a DNS name for Kubernetes to /etc/hosts.
#     Creates a link from /usr/bin/docker to /usr/local/bin/com.docker.cli.

# however, the following works:
systemctl --user start docker-desktop
# but, it just says Docker Desktop starting
# followed these instructions (using vs code to craeate the files)
# https://github.com/docker/desktop-linux/issues/51#issuecomment-1200774715
# found via https://askubuntu.com/questions/1415053/docker-desktop-stuck-at-docker-desktop-starting

# rebooted. then had some weird issue that seems to have ironed itself out
# note that installing docker desktop effectively kills all the existing containers, so better to do that before starting


# 
# so I am returning to my getting-started/app folder and rerunning
docker build -t getting-started .

# shows up in docker images now
# navigate to http://localhost:3000/
# added items
# and now they show up in Docker Desktop
# I am now officially at the bottom of https://docs.docker.com/get-started/02_our_app/

# Tried the following to start the deamon
# sudo systemctl status docker
# check if service is running
sudo service docker status 
sudo service docker start

sudo dockerd
sudo service --status-all
sudo systemctl start docker

systemctl restart docker

# This article was helpful for troubleshooting
# trying: https://phoenixnap.com/kb/cannot-connect-to-the-docker-daemon-error
systemctl --user start docker-desktop

# this reveals that the process is owned by root
sudo ls -la /var/run/docker.sock
# srw-rw---- 1 root docker 0 Jan 11 08:24 /var/run/docker.sock

docker push docker/getting-started
#  The push refers to repository [docker.io/docker/getting-started]
#  An image does not exist locally with the tag: docker/getting-started

sudo chown jasonstewartnz:docker /var/run/docker.sock

# https://phoenixnap.com/kb/cannot-connect-to-the-docker-daemon-error
# was  very helpful 
# TODO - understand how to *start* the daemon as user (I think there's a user flag as we discovered witht he docker desktop)
# start docker desktop command (to be modified to start the docker daemon without desktop) 
# systemctl --user start docker-desktop

docker login -u jasonstewartnz # resolved password issues

docker tag getting-started jasonstewartnz/getting-started
docker image ls

docker push jasonstewartnz/getting-started

# ok, so I was having an issue with the credentials
# googled, followed this post:  https://stackoverflow.com/questions/71770693/error-saving-credentials-error-storing-credentials-err-exit-status-1-out
service docker stop
rm ~/.docker/config.json
service docker start
# then relogged in with 
docker login -u jasonstewartnz # resolved password issues
# Password: 
# WARNING! Your password will be stored unencrypted in /home/jasonstewartnz/.docker/config.json.
# Configure a credential helper to remove this warning. See
# https://docs.docker.com/engine/reference/commandline/login/#credentials-store

# Login Succeeded

# Logging in with your password grants your terminal complete access to your account. 
# For better security, log in with a limited-privilege personal access token. Learn more at https://docs.docker.com/go/access-tokens/
# @TODO go back and fix security issue by choosing the second (more secure) answer

# had to then re-tag 
docker tag getting-started jasonstewartnz/getting-started
# and finally, push worked 
docker push jasonstewartnz/getting-started



# run on another machine using Play With Docker "playground"
# https://docs.docker.com/get-started/04_sharing_app/#run-the-image-on-a-new-instance
# https://labs.play-with-docker.com/
# 1) connected account
# 2) added instance
# 3) in terminal ran 
docker run -dp 3000:3000 jasonstewartnz/getting-started
# opened port 3000 to view app

## Persisting data 
# https://docs.docker.com/get-started/05_persisting_data/
# started process 
docker run -d ubuntu bash -c "shuf -i 1-10000 -n 1 -o /data.txt && tail -f /dev/null"

# containers don't show up in docker desktop
# stumbled upon this post suggesting I need to set the context 
# https://stackoverflow.com/questions/71926492/docker-desktop-not-showing-running-containers
# todo: FURTHER reading: https://docs.docker.com/engine/context/working-with-contexts/

# halted existing containers 
# change context
docker context use desktop-linux

# start container in correct context
docker run -d ubuntu bash -c "shuf -i 1-10000 -n 1 -o /data.txt && tail -f /dev/null"
docker exec 1500fb01381d cat /data.txt


## Volumes: introduction
# Reference: https://docs.docker.com/storage/volumes/
# execute command within the container
docker volume create todo-db

# start the container, but mount the volume
docker run -dp 3000:3000 --mount type=volume,src=todo-db,target=/etc/todos getting-started

# While running in Docker Desktop, the Docker commands are actually 
# running inside a small VM on your machine. If you wanted to look 
# at the actual contents of the Mount point directory, you would need to look inside of that VM.

## Using bind mounts
# https://docs.docker.com/get-started/06_bind_mounts/
# google search: docker bind mount vs volume
# 
 # Docker manages Volumes and is usually not affected by other processes running
 # on the same host. In contrast, Bind Mounts are just a directory on the 
 # host file system and may be modified by other processes other than docker.

 # So for example, if we wanted to trigger some particular behaviour from an 
 # external process (e.g. Airflow controlled flag file) or inject some code at 
 # runtime, we could use a bing mount. 
 # When we want to ensure the integrity of some data within the context of a set
 # of cotainers, we would use a volume mount (e.g. shared database). Still want to
 # understand if/how we can mount an external volume such as an S3 bucket.

 # https://docs.docker.com/get-started/06_bind_mounts/#quick-volume-type-comparisons

 # E.g. you could have a bunch of machines waiting to perform a particular 
 # class of tasks/requests, say data pipeline tasks they could all work
 # with the same volume (e.g. database) to track what has been done and what is needed 
 # to do. We wouldn't want an external resource to interfere with this, and the volume 
 # could be called something like etl-pipeline-status (or be the airflow shared db)
 # which would be monitored by containers from the etl-images, and other images responsible 
 # for the management/addition of tasks, and dags, but which may be different images or
 # different run commands for the contains that include a bind mount.
 # TODO: Diagram this

# https://docs.docker.com/storage/images/types-of-mounts-volume.png

## trying out bind mounts
docker run -it --mount type=bind,src="$(pwd)",target=/src ubuntu bash

ls src # inspect contents and confirm they match to ~/projects/docker/getting-started

# Run your app in a development container
# from within getting-started/app
docker run -dp 3000:3000 \
    -w /app --mount type=bind,src="$(pwd)",target=/app \
    node:18-alpine \
    sh -c "yarn install && yarn run dev"

# Using bind mounts is common for local development setups.

# @todo
# To learn more about the advanced storage concepts, see Manage data in Docker.


# Multi-container apps / container networking
# In general, each container should do one thing and do it well. 

# Rule
# If two containers are on the same network, they can talk to each other. 
# If they aren’t, they can’t.

docker network create todo-app

docker run -d \
     --network todo-app --network-alias mysql \
     -v todo-mysql-data:/var/lib/mysql \
     -e MYSQL_ROOT_PASSWORD=secret \
     -e MYSQL_DATABASE=todos \
     mysql:8.0


# network-alias: alias of service ip that can be searched for on the network using dig
# -v creates volume with name at mount location


# view running container / get id
docker ps 


docker exec -it 9c51e1a7cf6f mysql -u root -p
# password from run command
# Welcome to the MySQL monitor.  Commands end with ; or \g.
# Your MySQL connection id is 8
# Server version: 8.0.31 MySQL Community Server - GPL

# Copyright (c) 2000, 2022, Oracle and/or its affiliates.

# Oracle is a registered trademark of Oracle Corporation and/or its
# affiliates. Other names may be trademarks of their respective
# owners.

# Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

# mysql> 

# run new container on the network
docker run -it --network todo-app nicolaka/netshoot

 2ab61917eee8  ~  dig mysql # find service on network by ip

# ; <<>> DiG 9.18.8 <<>> mysql
# ;; global options: +cmd
# ;; Got answer:
# ;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 58971
# ;; flags: qr rd ra; QUERY: 1, ANSWER: 1, AUTHORITY: 0, ADDITIONAL: 0

# ;; QUESTION SECTION:
# ;mysql.                         IN      A

# ;; ANSWER SECTION:
# mysql.                  600     IN      A       172.18.0.2

# ;; Query time: 0 msec
# ;; SERVER: 127.0.0.11#53(127.0.0.11) (UDP)
# ;; WHEN: Fri Jan 13 22:14:18 UTC 2023
# ;; MSG SIZE  rcvd: 44

# @todo: READ: https://blog.diogomonica.com//2017/03/27/why-you-shouldnt-use-env-variables-for-secret-data/
# use the secret support provided by your container orchestration framework. 


# starts app running the app, connected to the network
docker run -dp 3000:3000 \
   -w /app -v "$(pwd):/app" \
   --network todo-app \
   -e MYSQL_HOST=mysql \
   -e MYSQL_USER=root \
   -e MYSQL_PASSWORD=secret \
   -e MYSQL_DB=todos \
   node:18-alpine \
   sh -c "yarn install && yarn run dev"


docker exec -it 9c51e1a7cf6f mysql -p todos 
# this is the container we started 34 minutes ago to run the db

sql> select * from todo_items;
