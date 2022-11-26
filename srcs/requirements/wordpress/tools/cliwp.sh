# Pour s'assurer que MariaDB a eu le temps de se lancer correctement 
sleep 10

# Si le fichier wp-config n'existe pas 
if [ ! -e /var/www/wordpress/wp-config.php ]; then
	wp config create --allow-root --dbname=$SQL_DATABASE --dbuser=$SQL_USER --dbpass=$SQL_PASSWORD \
	--dbhost=mariadb:3306 --path='/var/www/wordpress'
fi
sleep 2
# Creer les tables wordpress en utilisant l'URL, le tite et l'admin user par defaut 
# https://developer.wordpress.org/cli/commands/core/install/
wp core install --url=$DOMAIN_NAME --title=$SITE_TITLE --admin_user=$ADMIN_USER \
	--admin_password=$ADMIN_PASSWORD --admin_email=$ADMIN_EMAIL --locale=FR --skip-email --allow-root \
	--path='/var/www/wordpress'

# Creer un user avec wp user create
# https://developer.wordpress.org/cli/commands/user/create/
wp user create --allow-root --role=author $USER1_LOGIN $USER1_MAIL --user_pass=$USER1_PASS \
	--path='/var/www/wordpress' >> /log.txt

# Si le dossier /run/php n'existe pas 
if [ ! -d /run/php ]; then
	mkdir ./run/php
fi

# Lancer php-fpm 
exec /usr/sbin/php-fpm7.3 -F -R