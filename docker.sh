
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

sudo chown jasonstewartnz:docker /var/run/docker.sock

# https://phoenixnap.com/kb/cannot-connect-to-the-docker-daemon-error
# was  very helpful 
# TODO - understand how to *start* the daemon as user (I think there's a user flag as we discovered witht he docker desktop)
# start docker desktop command (to be modified to start the docker daemon without desktop) 
# systemctl --user start docker-desktop




