#!/bin/bash
# Script para instalar prestashop en su propio directorio. 
#Esto muestra todos los comandos que se van ejecutando
set -ex 
#Actualizamos los repositorios
apt update

#Actualizamos los paquetes de la máquina 

#apt upgrade -y

#Incluimos las variables del archivo .env

source .env

# Instalamos Unzip para descomprimir el archivo de prestashop.zip

sudo apt install unzip -y


#Borramos los archivos por si tenemos que volver a lanzar el script.

rm -rf /tmp/8.0.0.zip

#Descargamos la última versión de PrestaShop con el comando wget.


wget https://github.com/PrestaShop/PrestaShop/archive/refs/tags/8.0.0.zip -P /tmp


#Eliminamos el directorio para posteriores instalaciones.


rm -rf /var/www/html/PrestaShop-8.0.0

#Descomprimimos el archivo.

unzip /tmp/8.0.0.zip -d /var/www/html/ 

#Ejecutamos el comando para dar permisos al usuario de apache.

sudo chown www-data:www-data /var/www/html/* -R

#Creamos la base de datos

mysql -u root <<< "DROP DATABASE IF EXISTS $PRESTASHOP_DB_NAME"
mysql -u root <<< "CREATE DATABASE $PRESTASHOP_DB_NAME"
mysql -u root <<< "DROP USER IF EXISTS $PRESTASHOP_DB_USER@$IP_CLIENTE_MYSQL"
mysql -u root <<< "CREATE USER $PRESTASHOP_DB_USER@$IP_CLIENTE_MYSQL IDENTIFIED BY '$PRESTASHOP_DB_PASSWORD'"
mysql -u root <<< "GRANT ALL PRIVILEGES ON $PRESTASHOP_DB_NAME.* TO $PRESTASHOP_DB_USER@$IP_CLIENTE_MYSQL"

#Reiniciamos apache

sudo systemctl restart apache2



#----------------- INSTALAMOS LOS PAQUETES RECOMENDADOS -----------------------------#

#1.PAQUETE

apt install php-bcmath -y

#2. PAQUETE

apt install php-intl -y

#3. PAQUETE

apt install memcached -y

apt install libmemcached-tools -y

#4. PAQUETE

apt install php-curl -y
#5. PAQUETE

apt install php-gd -y

#6. PAQUETE

apt install php-mbstring -y

#7. PAQUETE

apt-get install php-dom php-xml -y

#8. PAQUETE

apt install php-zip -y


#Reiniciamos de nuevo apache

sudo systemctl restart apache2

#-----------------------------------------------------------------------------------------------------

#Modificamos los parametros de sed dentro de prestashop y php.

sed -i "s/memory_limit = 128M/$memorylimit/" /etc/php/8.1/apache2/php.ini
sed -i "s/max_input_vars = 1000/$maxinputvars/" /etc/php/8.1/apache2/php.ini
sed -i "s/post_max_size = 8M/$postmaxsize/" /etc/php/8.1/apache2/php.ini
sed -i "s/upload_max_filesize = 2M/$uploadmaxfilesize/" /etc/php/8.1/apache2/php.ini


#Reiniciamos de nuevo apache

sudo systemctl restart apache2

#--- INSTALACIÓN PRESTASHOP ---

php /var/www/html/PrestaShop-8.0.0/install-dev/index_cli.php \
    --domain=$CERTIFICATE_DOMAIN \
    --db_server=$PRESTASHOP_DB_HOST \
    --db_name=$PRESTASHOP_DB_NAME \
    --db_user=$PRESTASHOP_DB_USER \
    --db_password=$PRESTASHOP_DB_PASSWORD \
    --prefix=myshop_ \
    --email=$CERTIFICATE_EMAIL \
    --password=$PRESTASHOP_DB_PASSWORD
