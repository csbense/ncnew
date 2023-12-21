
#!/bin/bash

# Update and upgrade the server
sudo apt update && sudo apt upgrade -y

# Install Apache
sudo apt install apache2 -y

# Install MariaDB
sudo apt install mariadb-server -y

# Install PHP and required extensions
sudo apt install php php-gd php-mysql php-curl php-xml php-zip php-intl php-mbstring php-bcmath php-gmp -y

# Secure MariaDB installation
# Note: This part usually requires interactive input. It's recommended to run this part manually.
# sudo mysql_secure_installation

# Create a Nextcloud database and user
# Note: Replace 'yourpassword' with a secure password.
sudo mysql -e "CREATE DATABASE nextcloud;"
sudo mysql -e "CREATE USER 'nextclouduser'@'localhost' IDENTIFIED BY 'yourpassword';"
sudo mysql -e "GRANT ALL PRIVILEGES ON nextcloud.* TO 'nextclouduser'@'localhost';"
sudo mysql -e "FLUSH PRIVILEGES;"

# Download and extract the latest version of Nextcloud
wget https://download.nextcloud.com/server/releases/latest.tar.bz2 -O nextcloud-latest.tar.bz2
tar -xjf nextcloud-latest.tar.bz2
sudo mv nextcloud /var/www/html/nextcloud

# Set the correct permissions
sudo chown -R www-data:www-data /var/www/html/nextcloud/

# Apache configuration
echo "Alias /nextcloud "/var/www/html/nextcloud/"
<Directory /var/www/html/nextcloud/>
  Options +FollowSymlinks
  AllowOverride All

 <IfModule mod_dav.c>
  Dav off
 </IfModule>

 SetEnv HOME /var/www/html/nextcloud
 SetEnv HTTP_HOME /var/www/html/nextcloud

</Directory>" | sudo tee /etc/apache2/sites-available/nextcloud.conf

# Enable the new site and required Apache modules
sudo a2ensite nextcloud
sudo a2enmod rewrite headers env dir mime
sudo systemctl restart apache2

# Reminder for manual steps
echo "Nextcloud is now downloaded and configured."
echo "Please visit your server's IP/domain in a web browser to complete the setup."
echo "Don't forget to set up a secure SSL certificate."
