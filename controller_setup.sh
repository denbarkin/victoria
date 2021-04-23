#! /bin/sh

cp /vagrant/controller_interfaces /etc/netplan/config.yaml
cp /vagrant/hosts /etc/hosts
cp /vagrant/grub /etc/default/grub

update-grub

netplan apply

apt update -y
apt upgrade -y

apt install -y python3-dev libffi-dev gcc libssl-dev
apt install -y python3-pip
pip3 install -U pip -y


reboot
