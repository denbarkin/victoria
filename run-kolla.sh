#! /bin/sh

mount -t vboxsf vagrant /vagrant

# make sure ssh to all host before kolla-ansible deploy
cp /vagrant/.vagrant/machines/controller/virtualbox/private_key .ssh/controller.pem
cp /vagrant/.vagrant/machines/compute1/virtualbox/private_key .ssh/compute1.pem
cp /vagrant/.vagrant/machines/block1/virtualbox/private_key .ssh/block1.pem
cp /vagrant/.vagrant/machines/monitor1/virtualbox/private_key .ssh/monitor1.pem

chmod 600 .ssh/controller.pem
chmod 600 .ssh/compute1.pem
chmod 600 .ssh/block1.pem
chmod 600 .ssh/monitor1.pem

ssh -i .ssh/controller.pem vagrant@controller echo "OK"
ssh -i .ssh/compute1.pem vagrant@compute1 echo "OK"
ssh -i .ssh/block1.pem vagrant@block1 echo "OK"
ssh -i .ssh/monitor1.pem vagrant@monitor1 echo "OK"

apt install ansible

pip3 install kolla-ansible

sudo mkdir -p /etc/kolla

cp -r /usr/local/share/kolla-ansible/etc_examples/kolla /etc/
sudo chown $USER:$USER /etc/kolla


# Custom Configurations 
mkdir -p /etc/kolla/config/nova


cat << EOF > /etc/kolla/config/nova/nova-compute.conf
[libvirt]
virt_type = qemu
cpu_mode = none

[DEFAULT]
cpu_allocation_ratio = 16.0
ram_allocation_ratio = 5.0

EOF

mkdir -p /etc/kolla/config/zun-compute
cat << EOF > /etc/kolla/config/zun-compute/zun.conf
[compute]
cpu_allocation_ratio = 16
ram_allocation_ratio = 5

EOF

# vim /etc/kolla/globals.yml
# ifconfig
# ip a

# copy modified Globals to /etc/kolla
#cp /home/vagrant/kolla/globals.yml /etc/kolla
cp /vagrant/globals.yml /etc/kolla/

kolla-genpwd
kolla-ansible -i kolla/multinode bootstrap-servers
kolla-ansible -i kolla/multinode prechecks
kolla-ansible -i kolla/multinode deploy

kolla-ansible post-deploy

# openstackclient
pip3 install -U pip
pip install python3-openstackclient
apt install python3-openstackclient

cp /home/vagrant/kolla/init-runonce /usr/local/share/kolla-ansible/init-runonce
. /etc/kolla/admin-openrc.sh

cd /usr/local/share/kolla-ansible
./init-runonce

echo "Horizon available at 10.0.0.10, user 'admin', password below:"
grep keystone_admin_password /etc/kolla/passwords.yml
