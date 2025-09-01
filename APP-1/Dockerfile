
FROM ubuntu:latest

RUN apt update -y  \
#    && apt install curl 
   && apt install -y apache2 \
   && mkdir -p /var/www/html/app1 
    
WORKDIR /var/www/html/app1

COPY    birthday-invite.html .

COPY    welcome  . 

RUN     service apache2 start 
       

# CMD ["bash"]

 RUN sed -i 's|/var/www/html|/var/www/html/app1|' /etc/apache2/sites-available/000-default.conf && \
    a2enmod rewrite

EXPOSE 80

# Start Apache in the foreground (systemd/systemctl not used in containers)
CMD ["apache2ctl", "-D", "FOREGROUND"]



