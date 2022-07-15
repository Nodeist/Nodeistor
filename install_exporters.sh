#!/usr/bin/env bash

read -p "Denom degeri yazın. örneğin kujira için ukuji: " BOND_DENOM
read -p "Bench Prefix değeri yazın. örneğin kujira için kujira: " BENCH_PREFIX
read -p "address portunuzu yazın, default 9090dır. app.toml dan kontrol edin.: " ADRESPORT
read -p "laddr portunuzu yazın, default 26657dir. config.toml dan kontrol edin.: " LADRPORT

echo '================================================='
echo -e "bond_denom: \e[1m\e[32m$BOND_DENOM\e[0m"
echo -e "bench_prefix: \e[1m\e[32m$BENCH_PREFIX\e[0m"
echo -e "adresport: \e[1m\e[32m$ADRESPORT\e[0m"
echo -e "ladrport: \e[1m\e[32m$LADRPORT\e[0m"
echo '================================================='
sleep 3

echo -e "\e[1m\e[32m1. COSMOS EXPORTER YUKLENIYOR... \e[0m" && sleep 1
# COSMOS EXPORTER KURULUMU
wget https://github.com/solarlabsteam/cosmos-exporter/releases/download/v0.2.2/cosmos-exporter_0.2.2_Linux_x86_64.tar.gz
tar xvfz cosmos-exporter*
sudo cp ./cosmos-exporter /usr/bin
rm cosmos-exporter* -rf

sudo useradd -rs /bin/false cosmos_exporter

sudo tee <<EOF >/dev/null /etc/systemd/system/cosmos-exporter.service
[Unit]
Description=Cosmos Exporter
After=network-online.target

[Service]
User=cosmos_exporter
Group=cosmos_exporter
TimeoutStartSec=0
CPUWeight=95
IOWeight=95
ExecStart=cosmos-exporter --denom $BOND_DENOM --denom-coefficient 1000000 --bech-prefix $BENCH_PREFIX --node localhost:$ADRESPORT --tendermint-rpc http://localhost:$LADRPORT
Restart=always
RestartSec=2
LimitNOFILE=800000
KillSignal=SIGTERM

[Install]
WantedBy=multi-user.target
EOF

echo -e "\e[1m\e[32m2. NODE EXPORTER YUKLENIYOR... \e[0m" && sleep 1
# NODE EXPORTER KURULUMU
wget https://github.com/prometheus/node_exporter/releases/download/v1.3.1/node_exporter-1.3.1.linux-amd64.tar.gz
tar xvfz node_exporter-*.*-amd64.tar.gz
sudo mv node_exporter-*.*-amd64/node_exporter /usr/local/bin/
rm node_exporter-* -rf

sudo useradd -rs /bin/false node_exporter

sudo tee <<EOF >/dev/null /etc/systemd/system/node_exporter.service
[Unit]
Description=Node Exporter
After=network.target

[Service]
User=node_exporter
Group=node_exporter
Type=simple
ExecStart=/usr/local/bin/node_exporter

[Install]
WantedBy=multi-user.target
EOF

sleep 1

# SERVISLER BASLATILIYOR
sudo systemctl daemon-reload
sudo systemctl enable cosmos-exporter
sudo systemctl start cosmos-exporter
sudo systemctl enable node_exporter
sudo systemctl start node_exporter

echo -e "\e[1m\e[32mKURULUM TAMAMLANDI... \e[0m" && sleep 1
echo -e "\e[1m\e[32m9100 ve 9300 PORTLARINIZIN ACIK OLDUGUNDAN EMIN OLUN! \e[0m" && sleep 1
