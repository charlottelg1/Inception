FROM debian:buster

RUN apt-get update -y 
RUN apt-get upgrade -y

RUN apt-get install -y mariadb-server

EXPOSE 3306

COPY conf/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf
COPY conf/mysql_secure /var/www/
# Maintenant aue MySQL est installe, il faut creer une database et un utilisateur associe
# Pour cela on execute un script qui cree avec MySQL le systeme de table

RUN chmod +x ./var/www/mysql_secure && bash ./var/www/mysql_secure
RUN service mysql start

COPY ./tools/table.sh table.sh

VOLUME "/var/lib/myql"

ENTRYPOINT ["bash", "table.sh"]
