LOGIN			:= jfrancis
COMPOSE			:= srcs/docker-compose.yml
VOLUMES_PATH	:= /home/$(LOGIN)/data
DOMAIN = $(shell awk '/jfrancis.42.fr/{print $$2}' /etc/hosts)

ifeq ($(shell uname), Darwin)
VOLUMES_PATH	:= $(HOME)/data
endif

all: hosts
	sudo mkdir -p /home/$(LOGIN)/data/mysql
	sudo mkdir -p /home/$(LOGIN)/data/mariadb
	sudo mkdir -p /home/$(LOGIN)/data/wordpress
	docker-compose --file=$(COMPOSE) up --build --detach

hosts:
ifneq (${DOMAIN}, mavinici.42.fr)
	sudo cp /etc/hosts  ./host_backup
	sudo touch /etc/hosts
	sudo rm /etc/hosts
	sudo cp ./srcs/requirements/tools/hosts /etc/
endif

down:
	docker compose --file=$(COMPOSE) down

clean:
	docker compose --file=$(COMPOSE) down
	docker volume rm mariadb_volume
	docker volume rm wordpress_volume
	sudo rm -rf /home/$(LOGIN)/data

fclean: clean
	docker rmi inception-nginx inception-mariadb inception-wordpress
	sudo rm -rf /home/$(LOGIN)/
	sudo rm -rf /etc/hosts
	sudo mv ./host_backup /etc/hosts


.PHONY: all down clean fclean