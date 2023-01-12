PROJECT_NAME	=	inception

USER			=	nkim

COMPOSE_SOURCE	=	./srcs/docker-compose.yml

VOLUME_PATH		=	/Users/chloek/42Seoul/Inception/srcs/data/mariadb \
					/Users/chloek/42Seoul/Inception/srcs/data/wordpress

.PHONY	:	help
help	:
			@echo "Usage: make [OPTION]"
			@echo "Options:"
			@echo "  all: Build and run containers"
			@echo "  clean: Stop and remove containers"
			@echo "  fclean: Stop and remove containers, images, and volumes"
			@echo "  prune: Stop and remove containers, images, and volumes, and remove data"
			@echo "  re: Stop and remove containers, images, and volumes, and remove data, and build and run containers"

.PHONY	: build
build	:
			mkdir -p $(VOLUME_PATH)
			docker compose -f $(COMPOSE_SOURCE) build --no-cache

.PHONY	: run
run		:
			docker compose -f $(COMPOSE_SOURCE) up

.PHONY	:	all
all		:
			$(MAKE) build
			$(MAKE) run

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