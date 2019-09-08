cd /usr/local/src
sudo wget "https://github.com/coreos/etcd/releases/download/v3.3.9/etcd-v3.3.9-linux-amd64.tar.gz"
sudo tar -xvf etcd-v3.3.9-linux-amd64.tar.gz
sudo mv etcd-v3.3.9-linux-amd64/etcd* /usr/local/bin/
sudo mkdir -p /etc/etcd /var/lib/etcd
sudo groupadd -f -g 1501 etcd
sudo useradd -c "etcd user" -d /var/lib/etcd -s /bin/false -g etcd -u 1501 etcd
sudo chown -R etcd:etcd /var/lib/etcd

export ETCD_HOST_IP=$(ip addr show eth0 | grep "inet\b" | awk '{print $2}' | cut -d/ -f1)
export ETCD_NAME=$(hostname -s)

sudo -E bash -c 'cat << EOF > /lib/systemd/system/etcd.service
[Unit]
Description=etcd service
Documentation=https://github.com/coreos/etcd

[Service]
User=etcd
Type=notify
ExecStart=/usr/local/bin/etcd \\
 --data-dir /var/lib/etcd \\
 --discovery ${discoveryURL} \\
 --initial-advertise-peer-urls http://$ETCD_HOST_IP:2380 \\
 --name $ETCD_NAME \\
 --listen-peer-urls http://$ETCD_HOST_IP:2380 \\
 --listen-client-urls http://$ETCD_HOST_IP:2379,http://127.0.0.1:2379 \\
 --advertise-client-urls http://$ETCD_HOST_IP:2379 \\

[Install]
WantedBy=multi-user.target
EOF'

sudo systemctl daemon-reload
sudo systemctl enable etcd
sudo systemctl start etcd.service