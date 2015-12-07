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

RUN dpkg --add-architecture armhf
RUN dpkg --add-architecture armel
RUN sed -i -e 's/deb /deb [arch=amd64] /g' /etc/apt/sources.list
RUN echo "deb [arch=armhf] http://ports.ubuntu.com/ubuntu-ports  trusty main universe" >> /etc/apt/sources.list
RUN apt-get update

####################################################################AUTRE#######################################################################################

ADD init.sh /root/init.sh
RUN chmod +x /root/init.sh
CMD ["/root/init.sh"]