#!/bin/bash

# Author: info@itgenius.io

# Description: A Shell script to automate the process of configuring a simple HTML Website 

# Function to detect the Linux distribution
detect_distribution() {
    if [ -f /etc/centos-release ]; then
        echo "centos"
    elif [ -f /etc/lsb-release ]; then
        echo "ubuntu"
    else
        echo "unsupported"
    fi
}

echo ""

echo "*****Welcome to the Automated HTML Website Builder!******"

sleep 3

# Prompt user for name, IP address, and HTML Template URL
read -p "May I know your name? : " NAME

sleep 3

read -p "Thanks, $NAME! Enter this server's IP address : " IPADDRESS

sleep 3

read -p "Enter the HTML Template URL You want to Use : " URL

sleep 3

echo "Fantastic, $NAME! Allow me a moment..."

sleep 3

echo "-----Got it! Sit back, relax, and grab a cup of tea while I build your website!-----"

sleep 5


# Detect the Linux distribution
DISTRIBUTION=$(detect_distribution)

# Install and configure Apache based on the detected distribution
if [ "$DISTRIBUTION" == "centos" ]; then
    # Install httpd (Apache) for CentOS
    sudo yum install unzip -y
    sudo yum install wget -y
    sudo yum install httpd -y

    # Start httpd service
    sudo systemctl start httpd

    # Enable httpd to start on boot
    sudo systemctl enable httpd

    # Open necessary firewall ports for CentOS
    if command -v firewall-cmd &> /dev/null; then
        sudo firewall-cmd --permanent --add-service=http
        sudo firewall-cmd --reload
    fi
elif [ "$DISTRIBUTION" == "ubuntu" ]; then
    # Install httpd (Apache) for Ubuntu
    sudo apt-get update
    sudo apt-get install unzip -y
    sudo apt-get install wget -y
    sudo apt-get install apache2 -y

    # Start Apache service
    sudo systemctl start apache2

    # Enable Apache to start on boot
    sudo systemctl enable apache2

    # Open necessary firewall ports for Ubuntu
    if command -v ufw &> /dev/null; then
        sudo ufw allow 'Apache'
    fi
else
    echo "Unsupported distribution: $DISTRIBUTION"
    exit 1
fi

sudo mkdir ~/html-template

sudo rm -rf ~/html-template/*

sudo wget -P ~/html-template/ $URL

sudo unzip ~/html-template/*.zip -d ~/html-template/

sudo rm -rf ~/html-template/*.zip

sudo rm -rf /var/www/html/*

sudo cp -r ~/html-template/*/* /var/www/html/

sleep 5

echo ">>>"

sleep 2

echo ">>>>>>"

sleep 2

echo ">>>>>>>>>>"

sleep 3


echo ">>>>>>> Your website is ready. Access it using the URL: http://$IPADDRESS:80"

sleep 5
