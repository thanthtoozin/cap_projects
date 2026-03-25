#!/bin/bash

sudo apt update -y
sudo apt-get install net-tools zip curl jq tree unzip wget siege apt-transport-https ca-certificates software-properties-common gnupg lsb-release -y

# download application
sudo curl -L https://github.com/hashicorp/demo-consul-101/releases/download/v0.0.5/dashboard-service_linux_arm64.zip -o dashboard-service.zip 
sudo unzip dashboard-service.zip

sudo rm -rf dashboard-service.zip

sudo mv dashboard-service_linux_arm64 dashboard-service

sudo mv dashboard-service /usr/bin/dashboard-service

sudo chmod 755 /usr/bin/dashboard-service

sudo chown vagrant:vagrant /usr/bin/dashboard-service


sudo cat > /usr/lib/systemd/system/dashboard-api.service << 'EOF'
[Unit]
Description=Dashboard API service
After=syslog.target network.target

[Service]
Environment=PORT="9002"
Environment=COUNTING_SERVICE_URL="http://192.168.56.12:9003"
ExecStart=/usr/bin/dashboard-service
User=vagrant
Group=vagrant
ExecStop=/bin/sleep 5
Restart=always

[Install]
WantedBy=multi-user.target

EOF

sudo systemctl daemon-reload
sleep 1
sudo systemctl enable dashboard-api.service
sudo systemctl start dashboard-api.service
sleep 1
sudo systemctl status dashboard-api.service
sudo lsof -i -P | grep dashboard