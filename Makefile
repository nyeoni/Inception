PROJECT_NAME	=	inception

USER			=	nkim

COMPOSE_SOURCE	=	./srcs/docker-compose.yml

VOLUME_PATH		=	/Users/chloek/42Seoul/Inception/srcs/data/mariadb \
					/Users/chloek/42Seoul/Inception/srcs/data/wordpress

.PHONY	:	help
help	:
			@echo "Usage: make [OPTION]"
			@echo "Options:"
			@echo "  build\t\t\tBuild docker images"
			@echo "  up\t\t\tRun docker containers"
			@echo "  all\t\t\tBuild and run docker containers"
			@echo "  down\t\t\tStop and remove docker containers"
			@echo "  fclean\t\tStop and remove docker containers and images"
			@echo "  prune\t\t\tStop and remove docker containers and images and volumes"
			@echo "  re\t\t\tStop and remove docker containers and images and volumes and build and run docker containers"

.PHONY	: build
build	:
			mkdir -p $(VOLUME_PATH)
			docker compose -f $(COMPOSE_SOURCE) build --no-cache

.PHONY	: up
up		:
			docker compose -f $(COMPOSE_SOURCE) up

.PHONY	:	all
all		:
			$(MAKE) build
			$(MAKE) up

.PHONY	:	down
down	:
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