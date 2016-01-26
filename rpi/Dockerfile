FROM ubuntu:14.04

MAINTAINER loic

ENV SHELL_ROOT_PASSWORD root

RUN apt-get update && apt-get install -y \
wget \
ntp \
unzip \
curl \
wget \
supervisor \
tar \
sudo \
htop \
net-tools \
python \
ca-certificates \
vim \
git \
locate

####################################################################MULTIARCH#######################################################################################

RUN apt-get install binfmt-support qemu qemu-user-static debootstrap kpartx lvm2 dosfstools apt-cacher-ng coreutils

####################################################################AUTRE#######################################################################################

ADD init.sh /root/init.sh
RUN chmod +x /root/init.sh
CMD ["/root/init.sh"]