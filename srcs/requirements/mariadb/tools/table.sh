if [ -f "/var/lib/mysql/entry" ];then
	exec mysqld
	exit
else
	# Script qui va creer le systeme de table avec MySQL
	# mysql -e (execute) permet d'utiliser directement SQL
	# -u = --user=name for login if not current user
	# -p = --pasword[=name] Password to use whe connecting to the server
	# Demarrer MySQL pour le configurer
	service mysql restart

	# Creer notre table avec le nom de la variable d4environnement SQL_DATABASE de mon .env
	mysql -e "CREATE DATABASE $SQL_DATABASE"

	# Creer une utiliateur pour manipuer la table 
	mysql -e "CREATE USER '${SQL_USER}'@'%' IDENTIFIED BY '${SQL_PASSWORD}';"

	# Donner tous les droits a cet utilisateur
	mysql -e "GRANT ALL PRIVILEGES ON $SQL_DATABASE.* TO '$SQL_USER'@'%' IDENTIFIED BY '$SQL_PASSWORD';"

	# Modifier mon utilisateur root 
	mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '$SQL_ROOT_PASSWORD';"

	mysql -e "SET PASSWORD FOR 'root'@'localhost' = PASSWORD('abc') ;"
	
	# Rafraichir pour que MySQL prenne ces modifications en compte
	mysql -e "flush privileges;"

	# Eteindre et redemarrer MySQL pour que cela soit effectif
	mysqladmin -u root -p$MYSQL_ROOT_PASSWORD shutdown

	touch /var/lib/mysql/entry
	chmod 777 /var/lib/mysql/*
	exec mysqld_safe
fi
