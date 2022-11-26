NAME = Inception
SUDO_PWD = Salutuser
PATH_TO_DB_VOLUME = /home/cle-gran/data/mariadb1
PATH_TO_WP_VOLUME = /home/cle-gran/data/wordpress1

all: $(NAME)

$(NAME):
	@echo $(SUDO_PWD) | sudo -Sk systemctl start docker
	@echo $(SUDO_PWD) | sudo -Sk mkdir -p $(PATH_TO_DB_VOLUME)
	@echo $(SUDO_PWD) | sudo -Sk mkdir -p $(PATH_TO_WP_VOLUME)
	@sudo docker-compose -f ./srcs/docker-compose.yml up -d --build

nginx:
	@sudo docker-compose -f ./srcs/docker-compose.yml -p $(NAME) build nginx

mariadb:
	@sudo docker-compose -f ./srcs/docker-compose.yml -p $(NAME) build mariadb

wordpress:
	@sudo docker-compose -f ./srcs/docker-compose.yml -p $(NAME) build wordpress

clean:
	@sudo docker-compose -f ./srcs/docker-compose.yml  down

fclean: clean
	
	@-docker stop $$(docker ps -a -q)
	@-docker rm $$(docker ps -a -q)
	@-docker container rm $$(docker ps -aq) -f
	@docker container ls -aq | xargs --no-run-if-empty docker container rm -f
	@docker system prune
	@sudo rm -rf $(PATH_TO_DB_VOLUME)
	@sudo rm -rf $(PATH_TO_WP_VOLUME)

re: fclean all


.PHONY: all down re clean
