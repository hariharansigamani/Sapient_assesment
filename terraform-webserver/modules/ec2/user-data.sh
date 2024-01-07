#!/bin/bash

# Update the system
yum update -y

# Install httpd (Apache HTTP web server)
yum install -y httpd

# Start the httpd service
systemctl start httpd

# Enable httpd to start on boot
systemctl enable httpd

# Modify the Apache configuration file to change the default tcp port from 80 to 8080
sed -i 's/Listen 80/Listen 8080/g' /etc/httpd/conf/httpd.conf

# Restart the httpd service to apply the changes
systemctl restart httpd