#!/bin/bash
# Update the apt packages and get a couple of basic tools
# sudo apt-get update -y
# sudo apt-get install unzip curl vim jq -y

NOMAD_VERSION=0.9.5
CONSUL_VERSION=$(curl -s https://checkpoint-api.hashicorp.com/v1/check/consul | jq -r ".current_version")
KRAKEND_VERSION=1.4.1

# # make an archive folder to move old binaries into
# if [ ! -d /tmp/archive ]; then
#   sudo mkdir /tmp/archive/
# fi

# # Install Docker Community Edition
# echo "Docker Install Beginning..."
# sudo apt-get remove docker docker-engine docker.io
# sudo apt-get install apt-transport-https ca-certificates curl software-properties-common -y
# sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg |  sudo apt-key add -
# sudo apt-key fingerprint 0EBFCD88
# sudo add-apt-repository \
#       "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
#       $(lsb_release -cs) \
#       stable"
# sudo apt-get update -y
# sudo apt-get install -y docker-ce
# sudo service docker restart
# # Configure Docker to be run as the vagrant user
# sudo usermod -aG docker vagrant
# sudo docker --version

# cd /tmp/
# echo "Consul Install Beginning..."
# sudo curl -sSL https://releases.hashicorp.com/consul/${CONSUL_VERSION}/consul_${CONSUL_VERSION}_linux_amd64.zip > consul.zip
# if [ ! -d consul ]; then
#   sudo unzip /tmp/consul.zip
# fi

# if [ ! -f /usr/bin/consul ]; then
#   sudo install consul /usr/bin/consul
# fi
# if [ -f /tmp/archive/consul ]; then
#   sudo rm /tmp/archive/consul
# fi

# sudo mv /tmp/consul /tmp/archive/consul
# sudo mkdir -p /etc/consul.d
# sudo chmod a+w /etc/consul.d
# sudo cp /vagrant/consul-config/consul-server-east.hcl /etc/consul.d/
# sudo cp /vagrant/consul-config/consul.service /etc/systemd/system
# sudo systemctl start consul.service

#Installing dnsmasq/etc/systemd/resolved.conf
#echo "Setting up dnsmasq"
# sudo apt-get install -yq dnsmasq
# sudo systemctl disable systemd-resolved.service
# sudo cp /vagrant/dns-config/dnsmasq_conf /etc/dnsmasq.d/default
# sudo systemctl restart dnsmasq
# sudo rm /etc/resolv.conf


# for bin in cfssl cfssl-certinfo cfssljson
# do
#   echo "$bin Install Beginning..."
#   if [ ! -f /tmp/${bin} ]; then
#     curl -sSL https://pkg.cfssl.org/R1.2/${bin}_linux-amd64 > /tmp/${bin}
#   fi
#   if [ ! -f /usr/local/bin/${bin} ]; then
#     sudo install /tmp/${bin} /usr/local/bin/${bin}
#   fi
# done


echo "Krakend Install Beginning..."
cd /tmp/
sudo curl -sSL https://repo.krakend.io/bin/krakend_${KRAKEND_VERSION}_amd64.tar.gz -o krakend.tar.gz
sudo tar -zxvf krakend.tar.gz

sudo mv /tmp/usr/bin/krakend /usr/bin/krakend
sudo mkdir -p /etc/krakend.d
sudo chmod a+w /etc/krakend.d
sudo cp /vagrant/kraken-config/orders-krakend.json /etc/krakend.d/
sudo cp /vagrant/kraken-config/kraken.service /etc/systemd/system
sudo systemctl start kraken.service