#!/bin/bash
# 1. Update OS and Install tools
apt-get update -y
apt-get install -y apache2 php php-curl libapache2-mod-php php-mysql jq
ufw allow 'Apache Full'

# 2. Set required permission
usermod -a -G www-data azureuser

mkdir -p /var/www/html
chown -R azureuser:www-data /var/www
chmod 2775 /var/www
find /var/www -type d -exec chmod 2775 {} \;
find /var/www -type f -exec chmod 0664 {} \;


cd /var/www/html

# 💡 Save metadata.html and allow index.php to surve
curl -s -H Metadata:true --noproxy "*" "http://169.254.169.254/metadata/instance?api-version=2021-02-01" | jq > metadata.html
sed -i '1i<pre>' metadata.html
sed -i '$a</pre>' metadata.html

# 4. Download Main Azure PHP App 
curl https://raw.githubusercontent.com/Azure/vm-scale-sets/master/terraform/terraform-tutorial/app/index.php -O

# 5. Restart apache2 for effecting changes
systemctl restart apache2