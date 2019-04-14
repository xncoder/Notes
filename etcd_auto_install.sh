#lastest version
export RELEASE="3.3.12"

#use wget etcd release
wget https://github.com/etcd-io/etcd/releases/download/v${RELEASE}/etcd-v${RELEASE}-linux-amd64.tar.gz

#extract the file
tar xvf etcd-v${RELEASE}-linux-amd64.tar.gz

#chdir to the extracted dir
cd etcd-v${RELEASE}-linux-amd64

#move to /usr/local/bin/
sudo cp -r etcd* /usr/local/bin/

#delete release file and extracted files
rm etcd-v${RELEASE}-linux-amd64.tar.gz
rm -r etcd-v${RELEASE}-linux-amd64

#get the version of the installed etcd
version=$(etcd --version | grep "etcd Version" | cut -d ":" -f 2 | awk '{$1=$1};1')

if [ "$RELEASE" == $version ]
then
    echo "etcd install success!"
fi

#create etcd configuration file and data directory
sudo mkdir -p /var/lib/etcd/
sudo mkdir /etc/etcd

#create etcd system user
sudo groupadd --system etcd
sudo useradd -s /sbin/nologin --system -g etcd etcd

#set /var/lib/etcd/ directory ownership to etcd user
sudo chown -R etcd:etcd /var/lib/etcd/

#configure Systemd and Start etcd service
sudo touch /etc/systemd/system/etcd.service

sudo cat ./etcd.service >> /etc/systemd/system/etcd.service

#reload systemd service and start etcd
sudo systemctl  daemon-reload
sudo systemctl  start etcd.service
