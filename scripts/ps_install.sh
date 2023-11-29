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

#--- INSTALACIÓN PRESTASHOP ----------------------------------------------

php /var/www/html/install/index_cli.php \
    --domain=$CERTIFICATE_DOMAIN \
    --db_server=$PRESTASHOP_DB_HOST \
    --db_name=$PRESTASHOP_DB_NAME \
    --db_user=$PRESTASHOP_DB_USER \
    --db_password=$PRESTASHOP_DB_PASSWORD \
    --prefix=myshop_ \
    --email=$email \
    --password=$PRESTASHOP_DB_PASSWORD \
    --ssl=1


#Reiniciamos de nuevo apache

sudo systemctl restart apache2