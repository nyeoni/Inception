PROJECT_NAME	=	inception

USER			=	nkim

COMPOSE_SOURCE	=	./srcs/docker-compose.yml

VOLUME_PATH		=	/Users/chloek/42Seoul/Inception/srcs/data/mariadb \
					/Users/chloek/42Seoul/Inception/srcs/data/wordpress

.PHONY	:	all
all		:
			mkdir -p $(VOLUME_PATH)
			docker compose -f $(COMPOSE_SOURCE) build --no-cache
			docker compose -f $(COMPOSE_SOURCE) up

.PHONY	:	clean
clean	:
			docker compose -f $(COMPOSE_SOURCE) down

.PHONY	:	fclean
fclean:
			docker compose -f $(COMPOSE_SOURCE) down \
			--remove-orphans --rmi all -v

.PHONY	:	prune
prune:	fclean
			sudo rm -rf $(VOLUME_PATH)
			docker image prune
			docker container prune

.PHONY	:	re
re		:	prune
			$(MAKE) all