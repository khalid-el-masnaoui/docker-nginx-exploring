FROM nginx:latest AS prod

SHELL ["/bin/bash", "-c"]

RUN chmod 1777 /tmp
RUN chown -R www-data:www-data /var/log/nginx
RUN  apt-get update -y && apt-get install -y procps 

#ADD user www-data
RUN (id -u www-data &> /dev/null || useradd www-data) && (groups www-data | grep -qw www-data || (groupadd www-data &&  usermod -a -G www-data www-data))
#USER www-data

#ADD directories
RUN mkdir /etc/nginx/sites-available && mkdir /etc/nginx/sites-enabled

COPY configurations/nginx.conf /etc/nginx/nginx.conf
COPY configurations/sites-available /etc/nginx/sites-available
COPY src/ /var/www/html/
 
#ADD sumbolic linlk
RUN  ln -s /etc/nginx/sites-available/default.conf /etc/nginx/sites-enabled/  

EXPOSE 80/tcp
EXPOSE 443/tcp 

CMD ["/usr/sbin/nginx", "-g", "daemon off;"] 

#Define mountable directories.
VOLUME ["/var/log/nginx"]


#-----------------
FROM prod as dev

# Define mountable directories.
VOLUME ["/etc/nginx/sites-enabled", "/var/log/nginx", "/var/www/html"]

