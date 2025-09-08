
FROM ubuntu:latest
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update -y && \
    apt-get install -y apache2 curl && \
    mkdir -p /var/www/html/app2 /var/run/apache2 /var/lock/apache2 && \
    rm -rf /var/lib/apt/lists/*

# Redirect Apache logs to stdout/stderr
RUN ln -sf /dev/stdout /var/log/apache2/access.log \
 && ln -sf /dev/stderr /var/log/apache2/error.log

WORKDIR /var/www/html/app2

COPY movie-ranking.html /var/www/html/app2/index.html
COPY welcome /var/www/html/app2/welcome

EXPOSE 80
CMD ["apache2ctl", "-D", "FOREGROUND"]
