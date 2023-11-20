#!/bin/bash

#Esto muestra todos los comandos que se van ejecutando
set -x 
#Actualizamos los repositorios
apt update

#Actualizamos los paquetes de la máquina 

#apt upgrade -y

# Instalamos el servidor web apache A.

apt install apache2 -y

#Copiamos el directorio 000-default.conf

cp ../conf/000-default.conf /etc/apache2/sites-available/000-default.conf

# Instalamos Mysql L.

sudo apt install mysql-server -y

# Instalamos PHP.

sudo apt install php libapache2-mod-php php-mysql -y

# Reiniciamos el servicio (apache)

systemctl restart  apache2


#Movemos el código de PHP.info al directorio /var/Www/html/Prestashop.8.0.0

cp /home/ubuntu/Practica01-8IAW/php/phpinfo.php /var/www/html

# Modificamos el propietario y el grupo del directorio /var/www/html

chown -R www-data:www-data /var/www/html






