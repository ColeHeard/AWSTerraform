#! /bin/bash
# Install NGINX.
sudo amazon-linux-extras install -y nginx1
# Start NGINX service.
sudo service nginx start
# Copy html and image files to the NGINX server.
aws s3 cp s3://${remoteshare}/files/index.html /home/ec2-user/index.html
aws s3 cp s3://${remoteshare}/files/image.png /home/ec2-user/image.png
# Clean up old index.html. Move files to the correct location.
sudo rm /usr/share/nginx/html/index.html
sudo cp /home/ec2-user/index.html /usr/share/nginx/html/index.html
sudo cp /home/ec2-user/image.png /usr/share/nginx/html/image.png