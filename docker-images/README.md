# TARZAN Platform Docker Images

## Download

The individual docker images are available in their Git repositories. To **clone all the required repositories**, run:

~~~sh
git submodule init
git submodule update --recursive
~~~

To update the repositories to the latest "bleeding edge" commits (which is a really bad idea), run:

~~~sh
# for all submodules in the project (not only those in this directory)
git submodule foreach git checkout master
# for submodules in this directory
./update.sh
~~~

## Usage

You need not to build the images -- it is recommended to use their release builds/images
that are available at Docker registries, e.g., in the Docker Container Registry integrated into GitLab.

For example, for Apache Spark Docker image use [its project Docker registry](https://gitlab.com/rychly-edu/docker/docker-spark/container_registry)
and its Docker name in your `Dockerfile` or `docker-compose.yml`:

~~~
# Dockerfile fragment
FROM registry.gitlab.com/rychly-docker/docker-spark
# docker-compose.yml fragment
image: registry.gitlab.com/rychly-docker/docker-spark
~~~
