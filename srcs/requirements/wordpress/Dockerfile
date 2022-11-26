FROM debian:buster

RUN apt-get install -y
RUN apt-get update -y

# wget est un programme en ligne de comande non interactif de elechargement de fichiers 
# depuis le web
RUN apt-get -y install wget

# Installer PHP et ses dependances dans le conainer WordPress, qui communique avec NGINX 
# sur le port 9000
RUN apt-get install -y php7.3 \
						php-fpm\
						php-mysql\
						mariadb-client\
						php-cli\
						php-curl\
						php-gd\
						php-intl\
						php-mysqli

EXPOSE 9000

# Utiliser wget en indiquant le lien d'installation et le dossier dqns leauel on veut 
# telecharger le fichier
RUN wget https://fr.wordpress.org/wordpress-5.9.3-fr_FR.tar.gz -P /var/www

# Decompresser le fichier et en obtenir le dossier wordpress et supprimer le .tar 
# qui ne sert plus
RUN cd /var/www && tar xzf wordpress-5.9.3-fr_FR.tar.gz && rm wordpress-5.9.3-fr_FR.tar.gz

# PHP
COPY ./conf/php.conf /etc/php/7.3/fpm/pool.d
# COPY ./conf/wp-config.php /var/www/wordpress/

RUN	chown -R root:root /var/www/wordpress

# Wordpress est installe mais pas configure
# WP a besoin d'une base de donner pour fonctionner (au moins connaitre mdp, nom et host)
# Configurer fichier wp-config.php avec CLI
RUN wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar

# Donner les bons doits et le placer dans les binaires 
RUN chmod +x wp-cli.phar
RUN mv wp-cli.phar /usr/local/bin/wp

COPY tools/cliwp.sh cliwp.sh

RUN chown -R www-data:www-data /var/www/wordpress/
RUN service php7.3-fpm start
RUN service php7.3-fpm stop 

ENTRYPOINT ["bash", "cliwp.sh"]
