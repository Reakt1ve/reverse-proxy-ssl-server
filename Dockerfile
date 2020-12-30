FROM enoniccloud/apache2-letsencrypt
EXPOSE 80 443
WORKDIR /etc/notification_sys/apache2
COPY ./sites-available/* /etc/apache2/sites-available/
COPY ./letsencrypt/ /etc/letsencrypt/
RUN a2enmod proxy proxy_http && service apache2 restart && a2ensite reverse_proxy.conf && a2enmod ssl && service apache2 reload
