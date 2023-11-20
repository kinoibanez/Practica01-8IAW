#!/bin/bash
# Script para instalar wordpress en su propio directorio. 
# /var/www/html/wordpress
#Esto muestra todos los comandos que se van ejecutando
set -ex 
#Actualizamos los repositorios
apt update

#Actualizamos los paquetes de la máquina 

#apt upgrade -y

#Incluimos las variables del archivo .env

source .env

#Eliminamos instalaciones previas 

rm -rf /tmp/prestashop_8.0.0.zip

# Instalamos Unzip para descomprimir el archivo de prestashop.zip

sudo apt install unzip -y

#Descargamos la última versión de PrestaShop con el comando wget.


wget https://github.com/PrestaShop/PrestaShop/releases/tag/8.0.0/prestashop_8.0.0.zip



#Borramos los archivos por si tenemos que volver a lanzar el script.

rm -f /tmp/prestashop*



#Descomprimimos el archivo.

unzip /tmp/prestashop_8.0.0.zip

unzip /tmp/prestashop.zip -d /var/www/html/

#Ejecutamos el comando para dar permisos al usuario de apache.

sudo chown www-data:www-data /var/www/html -R

