#! /bin/sh

cp /vagrant/compute1_interfaces /etc/netplan/config.yaml
cp /vagrant/hosts /etc/hosts
cp /vagrant/grub /etc/default/grub

update-grub

netplan apply

if [[ "$(systemctl is-enabled ufw)" == "enabled" ]]; then
            systemctl stop ufw
            systemctl disable ufw
fi

apt update -y
apt upgrade -y


apt install -y python3-dev libffi-dev gcc libssl-dev
apt install -y python3-pip
pip3 install -U pip -y

echo "configfs" >> /etc/modules
update-initramfs -u
systemctl daemon-reload

reboot
