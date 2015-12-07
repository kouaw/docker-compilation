FROM debian:jessie

MAINTAINER loic

ENV SHELL_ROOT_PASSWORD root

RUN apt-get update && apt-get install -y \
wget \
ntp \
unzip \
curl \
wget \
openssh-server \
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

####################################################################SYSTEM#######################################################################################

RUN echo "root:${SHELL_ROOT_PASSWORD}" | chpasswd && \
  sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config && \
  sed -i 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' /etc/pam.d/sshd

RUN mkdir -p /var/run/sshd /var/log/supervisor
ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf

####################################################################PHPMYADMIN#######################################################################################

ADD bashrc /root/.bashrc
ADD init.sh /root/init.sh
RUN chmod +x /root/init.sh
CMD ["/root/init.sh"]
EXPOSE 22
