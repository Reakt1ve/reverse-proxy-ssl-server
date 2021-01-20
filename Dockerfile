FROM enoniccloud/apache2:latest	
MAINTAINER Andrey Senushchenkov "r3akt1vee@gmail.com"

# Set timezone for certbot client
ENV TZ=Europe/Moscow
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Fix sources.list file and installation of neccesary packages  
RUN sed -i s/archive/old-releases/g /etc/apt/sources.list \
 && sed -i /security/d /etc/apt/sources.list \
 && apt update \
 && apt install certbot -y \
                python-certbot-apache -y \   
 && apt clean

# Open ports for letsencrypt service
EXPOSE 80 443

# Copy startup shell script
COPY ./launcher.sh /usr/local/bin/

# Adjusting permissions and right locations
RUN chmod +x /usr/local/bin/launcher.sh

# Switch reverse-proxy mode on
RUN a2enmod proxy proxy_http \
 && service apache2 restart 

# launch ssl script
CMD ["/usr/local/bin/launcher.sh"]
