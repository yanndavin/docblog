DOCKER_OPTIONS=

include .env
export

include .secret
export

images := git-server blog-builder web-server

.PHONY: build

build-git-server:
	docker build $(DOCKER_OPTIONS) \
		-t $(DOCKER_REGISTRY)docblog/git-server:$(GIT_SERVER_DOCKER_IMAGE_VERSION) \
		dockerfiles/git-server/
	# Create the first admin user
	docker volume create git-server
	docker run --rm --env-file=.env -v git-server:/data $(DOCKER_REGISTRY)docblog/git-server:$(GIT_SERVER_DOCKER_IMAGE_VERSION) /bin/bash -c \
		"envsubst < /tmp/conf/app.ini.template > /data/gogs/conf/app.ini && (export USER=git && /app/gogs/gogs admin create-user --name=$(GIT_SERVER_ADMIN_USER) --password=$(GIT_SERVER_ADMIN_PASSWORD) --email=$(GIT_SERVER_ADMIN_EMAIL) --admin=true)" || true
	
build-blog-builder:
	docker build $(DOCKER_OPTIONS) \
		--build-arg blog_builder_git_url=$(BLOG_BUILDER_GIT_URL) \
		-t $(DOCKER_REGISTRY)docblog/blog-builder:$(BLOG_BUILDER_DOCKER_IMAGE_VERSION) \
        dockerfiles/blog-builder/

build-web-server:
	docker build $(DOCKER_OPTIONS)\
		-t $(DOCKER_REGISTRY)docblog/web-server:$(WEB_SERVER_DOCKER_IMAGE_VERSION) \
        dockerfiles/web-server/
        
build: 
	$(foreach image,$(or $(filter-out $@,$(MAKECMDGOALS)),$(images)), @$(MAKE) build-$(image))

create-certificates:
	docker pull certbot/certbot
	docker run -it --rm --name certbot -p 80:80 -p 443:443 -v "/etc/letsencrypt:/etc/letsencrypt" -v "/var/lib/letsencrypt:/var/lib/letsencrypt" certbot/certbot certonly

renew-certificates:
	docker run -it --rm --name certbot -p 80:80 -v "/etc/letsencrypt:/etc/letsencrypt" -v "/var/lib/letsencrypt:/var/lib/letsencrypt" certbot/certbot renew

%:
	@:
