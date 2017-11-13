LOCAL_IMAGE=tarzan-platform
REMOTE_IMAGE=rychly/tarzan-platform

.PHONY: build clean push

rebuild: clean build

build:
	docker build -t $(LOCAL_IMAGE) .

clean:
	docker ps -a -f ancestor=$(LOCAL_IMAGE) --format '{{.ID}}' | xargs -r docker rm -f -v
	-docker rmi $(LOCAL_IMAGE)

push: build
	docker tag $(LOCAL_IMAGE) $(SPARK_IMAGE)
	docker push $(SPARK_IMAGE)

shell:
	docker run --init --tty=true --interactive=true $(LOCAL_IMAGE) bash
