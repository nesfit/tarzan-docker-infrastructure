IMAGE=rychly/tarzan-platform
TAG_DEVEL=devel
TAG_LATEST=latest
IMAGE_DEVEL=$(IMAGE):$(TAG_DEVEL)
IMAGE_LATEST=$(IMAGE):$(TAG_LATEST)
TEST_PATH_PREF=/usr/local/bin/tarzan-

.PHONY: all build clean deploy pull-devel push-devel push-latest rebuild tag-latest shell test%

all:

build:
	docker build --pull -t $(IMAGE_DEVEL) .

clean:
	docker ps -a -f ancestor=$(IMAGE_DEVEL) --format '{{.ID}}' | xargs -r docker rm -f -v
	-docker rmi $(IMAGE_DEVEL)

deploy:
	echo "TODO: deploy"

pull-devel:
	docker pull $(IMAGE_DEVEL)

push-devel:
	docker push $(IMAGE_DEVEL)

push-latest:
	docker push $(IMAGE_LATEST)

rebuild: clean build

tag-latest:
	docker tag $(IMAGE_DEVEL) $(IMAGE_LATEST)

shell:
	docker run --init --tty --interactive --publish-all $(IMAGE_DEVEL) bash

test%:
	docker run $(IMAGE_DEVEL) $(TEST_PATH_PREF)$(@)
