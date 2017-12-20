IMAGE:=rychly/tarzan-platform-docker
REGISTRY:=registry.gitlab.com

# use LOCAL=1 for operations on local Docker images without REGISTRY prefix
ifndef LOCAL
IMAGE:=$(REGISTRY)/$(IMAGE)
endif

TAG_DEVEL:=master
TAG_LATEST:=latest
IMAGE_DEVEL:=$(IMAGE):$(TAG_DEVEL)
IMAGE_LATEST:=$(IMAGE):$(TAG_LATEST)
BIN_PATH_PREF:=/usr/local/bin/tarzan-

DOCKER_PORTS:=$(shell grep '\(ENV\|ARG\) [^ ]*_PORT=' Dockerfile | cut -d ' ' -f 2 | sed 's/^\(.*\)=\(.*\)$$/\2:\1/g' | sort -n)

all:

.PHONY: all build clean clean-latest deploy desc-ports distclean pull-devel push-devel pull-latest push-latest rebuild tag-latest shell% shell-latest% show-ports show-ips single% single-latest% test%

build:
	docker build --pull -t $(IMAGE_DEVEL) .

clean:
	docker ps -a -f ancestor=$(IMAGE_DEVEL) --format '{{.ID}}' | xargs -r docker rm -f -v
	-docker rmi $(IMAGE_DEVEL)

clean-latest:
	docker ps -a -f ancestor=$(IMAGE_LATEST) --format '{{.ID}}' | xargs -r docker rm -f -v
	-docker rmi $(IMAGE_LATEST)

deploy:
	echo "TODO: deploy"

desc-ports:
	@echo $(DOCKER_PORTS) | tr ' ' '\n'

distclean: clean clean-latest

pull-devel:
	docker pull $(IMAGE_DEVEL)

push-devel:
	docker push $(IMAGE_DEVEL)

pull-latest:
	docker pull $(IMAGE_LATEST)

push-latest:
	docker push $(IMAGE_LATEST)

rebuild: clean build

tag-latest:
	docker tag $(IMAGE_DEVEL) $(IMAGE_LATEST)

shell%:
	docker start --interactive tarzan-$(@) || docker run --init --tty --interactive --publish-all --hostname=tarzan-$(@) --name=tarzan-$(@) $(IMAGE_DEVEL)

shell-latest%:
	docker start --interactive tarzan-$(@) || docker run --init --tty --interactive --publish-all --hostname=tarzan-$(@) --name=tarzan-$(@) $(IMAGE_LATEST)

show-ports:
	docker ps -f ancestor=$(IMAGE_DEVEL) -f ancestor=$(IMAGE_LATEST) --format '{{.ID}}' | xargs -n 1 docker port

show-ips:
	docker ps -f ancestor=$(IMAGE_DEVEL) -f ancestor=$(IMAGE_LATEST) --format '{{.ID}}' | xargs -n 1 docker inspect | grep '\("Id"\|"Hostname"\|"Image"\|"IPAddress"\)'

single%:
	docker start --interactive tarzan-$(@) || docker run --init --tty --interactive --publish-all --hostname=tarzan-$(@) --name=tarzan-$(@) $(IMAGE_DEVEL) $(BIN_PATH_PREF)services-single sh

single-latest%:
	docker start --interactive tarzan-$(@) || docker run --init --tty --interactive --publish-all --hostname=tarzan-$(@) --name=tarzan-$(@) $(IMAGE_LATEST) $(BIN_PATH_PREF)services-single sh

test%:
	docker run $(IMAGE_DEVEL) $(BIN_PATH_PREF)$(@)

test shell shell-latest single single-latest:
	@echo "There must be suffix after target '$(@)' to run the target in a particular instance, e.g., as '$(@)-myinstance'."; false
