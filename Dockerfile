# Usar a imagem base do Ubuntu
FROM ubuntu:24.04

ENV OCOMON_LINK="https://sourceforge.net/projects/ocomonphp/files/OcoMon_5.0/Final/ocomon-5.0.tar.gz/download"
ENV DB_FILE_PATH="/var/www/html/install/5.x/01-DB_OCOMON_5.x-FRESH_INSTALL_STRUCTURE_AND_BASIC_DATA.sql"
ENV FOLDER_NAME="ocomon-5.0"

COPY ./assets/start_ocomon.sh /start_ocomon
RUN chmod +x /start_ocomon


# Instalar Apache, PHP 8.3, MySQL e alguns pacotes adicionais
RUN apt-get update && apt-get install -y \
    ca-certificates apt-transport-https software-properties-common lsb-release \
    apache2 && apt-get install -y \
    php8.3 \
    libapache2-mod-php8.3 \
    libapache2-mod-fcgid \
    php8.3-mysql \
    php8.3-curl \
    php8.3-iconv \
    php8.3-gd \
    php8.3-imap \
    php8.3-ldap \
    php8.3-mbstring \
    curl \
    cron \
    nano \
    mysql-server


# Configurar o timezone do PHP para o Brasil
RUN echo "date.timezone = America/Sao_Paulo" >> /etc/php/8.3/cli/php.ini


# Apache ServerName
RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf
# Configurar o Apache para suportar index.php
RUN sed -i -e 's/DirectoryIndex index.html/DirectoryIndex index.php index.html/' /etc/apache2/mods-enabled/dir.conf
# Copiar o arquivo de configuração do Apache para permitir reescrita de URLs
COPY ./assets/000-default.conf /etc/apache2/sites-available/000-default.conf
# Habilitar o mod_rewrite do Apache
RUN a2enmod rewrite

# Evitar o erro de nonexistent directory ao iniciar o MySQL
RUN usermod -d /var/lib/mysql/ mysql

# Copiar o arquivo de crontab
COPY ./assets/mycrontab /etc/cron.d/ocomon-cron
RUN chmod 0644 /etc/cron.d/ocomon-cron
# Apply cron job
RUN crontab /etc/cron.d/ocomon-cron
RUN touch /var/log/cron.log

RUN curl -L ${OCOMON_LINK} | tar -xz -C /var/www/html
RUN mv /var/www/html/${FOLDER_NAME}/* /var/www/html
RUN rm -Rf /var/www/html/${FOLDER_NAME}
RUN cp /var/www/html/includes/config.inc.php-dist /var/www/html/includes/config.inc.php
RUN sed -i -e 's/localhost/localhost:3306/g' /var/www/html/includes/config.inc.php
RUN chmod -R 755 /var/www/html
RUN chown -R www-data:www-data /var/www/html


# Expor a porta 80 para o serviço web
EXPOSE 80

CMD ["cron", "-f"]
