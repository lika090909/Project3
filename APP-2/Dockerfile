FROM ubuntu:latest

RUN apt update -y && \
    apt install -y apache2 curl && \
    mkdir -p /var/www/html/app2 && \
    sed -i 's|/var/www/html|/var/www/html/app2|' /etc/apache2/sites-available/000-default.conf && \
     a2enmod rewrite && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /var/www/html/app2

COPY movie-ranking.html .
COPY welcome .

EXPOSE 80
CMD ["apache2ctl", "-D", "FOREGROUND"]
