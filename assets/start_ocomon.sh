#!/bin/sh

SQL_FILEPATH="/var/www/html/install/5.x/"
SQL_FILENAME=01-DB_OCOMON_5.x-FRESH_INSTALL_STRUCTURE_AND_BASIC_DATA.sql

service mysql start && \
echo "Aguarde a importação da base de dados do OcoMon..." && \
mysql -u root < ${SQL_FILEPATH}${SQL_FILENAME} && \
echo "Base importada com sucesso!" && \
service apache2 start \ 
echo "Acesse o site http://localhost:8080/ para iniciar o OcoMon" && \
service cron start \
&& /bin/bash
