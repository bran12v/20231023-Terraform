#!/bin/bash
sudo yum update -y
sudo yum install httpd -y
sudo systemctl start httpd
sudo systemctl enable httpd
sudo aws s3 cp s3://bvanek-demo/index.html  /var/www/html/index.html
TOKEN=`curl -s -X PUT "http://169.254.169.254/latest/api/token" -H "X-aws-ec2-metadata-token-ttl-seconds: 21600"`
INSTANCE_AZ=`curl -s -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/placement/availability-zone`
INSTANCE_ID=`curl -s -H "X-aws-ec2-metadata-token: $TOKEN" http://169.254.169.254/latest/meta-data/instance-id`
sudo sed -i "s/_AZ_/$INSTANCE_AZ/" /var/www/html/index.html
sudo sed -i "s/_instanceID_/$INSTANCE_ID/" /var/www/html/index.html