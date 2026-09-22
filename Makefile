all:
	docker-compose -f srcs/docker-compose.yml up -d --build

down:
	docker-compose -f srcs/docker-compose.yml down

re: down all

clean: down
	docker system prune -af

fclean: clean
	docker volume rm $$(docker volume ls -q)
	sudo rm -rf /home/user/data/mariadb/*;
	sudo rm -rf /home/user/data/wordpress/*;