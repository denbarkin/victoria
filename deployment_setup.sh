#! /bin/sh

cp /vagrant/deployment_interfaces /etc/netplan/config.yaml
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
pip3 install -U pip

apt install -y python-jinja2 python-pip libssl-dev

apt install -y lvm2 thin-provisioning-tools curl vim

apt install  -y ansible

mkdir -p /home/vagrant/kolla

cp /vagrant/globals.yml /home/vagrant/kolla
cp /vagrant/run-kolla.sh /home/vagrant/kolla
cp /vagrant/init-runonce /home/vagrant/kolla
cp /vagrant/multinode /home/vagrant/kolla

reboot
