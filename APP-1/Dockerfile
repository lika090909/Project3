
FROM ubuntu:latest

RUN apt update -y && \
    apt install -y apache2 && \
    mkdir -p /var/www/html/app1 && \
    sed -i 's|/var/www/html|/var/www/html/app1|' /etc/apache2/sites-available/000-default.conf && \
    a2enmod rewrite

WORKDIR /var/www/html/app1

COPY birthday-invite.html .
COPY welcome .

EXPOSE 80
CMD ["apache2ctl", "-D", "FOREGROUND"]


docker