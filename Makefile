CMD = docker compose
SRC = ./srcs/docker-compose.yml

# export DOCKERVOLUMEPATH="/Users/soohalee/Documents/DockerVolume"
all :
	mkdir -p $(DOCKERVOLUMEPATH)/wordpressDB
	mkdir -p $(DOCKERVOLUMEPATH)/mariadbDB
	$(CMD) -f $(SRC) up -d

clean :
	$(CMD) -f $(SRC) down --rmi "all" --volumes

fclean : clean
	rm -rf $(DOCKERVOLUMEPATH)

re : fclean all

stop :
	$(CMD) -f $(SRC) stop

start :
	$(CMD) -f $(SRC) start

status :
	$(CMD) -f $(SRC) ps
