#!/bin/bash
echo "----------------------------------------------------------------"
echo " Running $0 to check for letsencrypt certificate"
echo "----------------------------------------------------------------"
privateKeyHome="/etc/letsencrypt/live/$(hostname -f)"
privateKeyFile="$privateKeyHome/privkey.pem"
DOMAIN_CMD=""

echo "Checking if certificate [$privateKeyFile] exist."
if [ ! -f $privateKeyFile ]; then
  echo "Certificate file [$privateKeyFile] does not exist"
  if [[ -n "$LETS_ENCRYPT_DOMAINS" ]]; then
    DOMAIN_CMD="-d $(echo $LETS_ENCRYPT_DOMAINS | sed 's/,/ -d /')"
  fi
  cmd="certbot -n certonly --no-self-upgrade --agree-tos --standalone -m \"$LETS_ENCRYPT_EMAIL\" -d $(hostname -f) $DOMAIN_CMD"
  echo "Requesting certificates for [$cmd]"
  eval $cmd
  echo "Linking certificate folder"
  ln -s /etc/letsencrypt/live/$(hostname -f) /etc/letsencrypt/certs
else
   echo "Certificate file [$privateKeyFile] exist"
fi
echo "Cert done"

echo "Launching apache2"
a2ensite reverse_proxy.conf \
 && a2enmod ssl \
 && service apache2 reload 

apache2 -DFOREGROUND
