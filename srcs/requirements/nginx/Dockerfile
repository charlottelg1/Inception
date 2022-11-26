FROM	debian:buster

RUN apt-get update
RUN apt-get install -y nginx openssl  

# stocker le certificat et la clef pour une connexion securisee
RUN mkdir -p /etc/nginx/ssl

EXPOSE 443

# generer un certificat TLS/SSL
RUN openssl req -x509 -newkey rsa:2048 -nodes -keyout /etc/nginx/cle-gran.42.fr.key \
	-out /etc/nginx/cle-gran.42.fr.crt -days 365 \
	-subj "/C=FR/ST=IDF/L=Paris/O=42School/OU=42/CN=cle-gran42/UID=cle-gran"

# stocker les fichiers de config de NGINX
RUN mkdir -p /run/nginx

# modifier le fichier de configuration nginx a partir du mien
COPY ./conf/nginx.conf /etc/nginx/conf.d

VOLUME "/var/www/wordpress"

# lancer le container en premier plan pour qu'il ne se stoppe pas
ENTRYPOINT nginx -g 'daemon off;'
