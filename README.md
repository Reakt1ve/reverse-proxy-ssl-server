# Reverse-proxy-ssl-server

<h2>Requirements</h2>
<p>
  <ul>
    <li>Opened 80 port</li>
    <li>Working internet</li>
  </ul>
</p>

<h2>Volume</h2>
<p>Run as a single container</p>

<pre>
docker run -dit --rm -e LETS_ENCRYPT_MAIL="josoh89952@pashter.com" /
            -v $(pwd)/sites-available/:/etc/apache2/sites-available/ /
            -v $(pwd)/letsencrypt/:/etc/letsencrypt --name test -h citis-test.zapto.org /
            -p "80:80" -p "443:443" reverse-ssl
</pre>

<p>
  You can store your data in a volume. Use this command <code>docker volume create --name your_name</code>
  Next, just bind new volume to a container like this <code>docker run -v volume:/container_dir</code>
</p>

<h2>Environment</h2>
<p>
  In this schema <code>LETS_ENCRYPT_DOMAINS</code> is optional variable. By default algorithm get hostname binding to server.
</p>
<pre>
LETS_ENCRYPT_MAIL="examle@mail.com" - email variable as Let's Encrypt Authority registration and recovery contact 
LETS_ENCRYPT_DOMAINS="example.com, srv1.example.com, docs.example.com" - domains variable as list of domains for which need security
                                                                         certificates
</pre>

<h2>Docker-compose</h2>
<pre>
services:
  reverse-proxy-apache2:
    image: reverse-ssl:latest
    container_name: reverse-proxy-apache2
    hostname: example.com
    restart: always
    ports:
      - 80:80
      - 443:443
    environment:
      LETS_ENCRYPT_EMAIL: "example@mail.com"
    volumes:
      - reverse-ssl-ssl:/etc/letsencrypt
      - reverse-ssl-proxy:/etc/apache2/sites-available
    networks:
      channel_net:
        ipv4_address: 127.0.0.1
      default:
</pre>
