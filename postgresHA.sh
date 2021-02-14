#ubuntu20.04 - 3 virtual mashines
sudo apt update && sudo apt upgrade

#install postgresql
sudo apt install postgresql-12 -y
sudo systemctl stop postgresql

#add to PATH
sudo ln -s /usr/lib/postgresql/9.5/bin/* /usr/sbin/

#install patroni
sudo apt install python3 python3-pip -y
sudo pip3 install --upgrade setuptools
sudo pip3 install patroni

#install etcd - 4 VM ubuntu20.04
sudo apt install etcd -y

#install HAProxy - 5 VM ubuntu20.04 
sudo apt install haproxy -y

#config /etc/defaut/etcd
ETCD_LISTEN_PEER_URLS="http://192.168.1.37:2380"

ETCD_LISTEN_CLIENT_URLS="http://localhost:2379,http://192.168.1.37:2379"

ETCD_INITIAL_ADVERTISE_PEER_URLS="http://192.168.1.37:2380"

ETCD_INITIAL_CLUSTER="etcd0=http://192.168.1.37:2380,"

ETCD_ADVERTISE_CLIENT_URLS="http://192.168.1.37:2379"

ETCD_INITIAL_CLUSTER_TOKEN="cluster1"

ETCD_INITIAL_CLUSTER_STATE="new"

#config patroni - file /etc/patroni.yml
sudo mkdir /data/patroni -p
sudo chown postgres:postgres /data/patroni
sudo chmod 700 /data/patroni

#create patroni.service - /etc/systemd/system/patroni.service
[Unit]
Description=Runners to orchestrate a high-availability PostgreSQL
After=syslog.target network.target

[Service]
Type=simple

User=postgres
Group=postgres

ExecStart=/usr/local/bin/patroni /etc/patroni.yml

KillMode=process

TimeoutSec=30

Restart=no

[Install]
WantedBy=multi-user.targ

#start patroni
sudo systemctl start patroni
sudo systemctl status patroni

#error
screenshot