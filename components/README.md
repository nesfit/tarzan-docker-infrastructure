# TARZAN Platform Components

## Download

The components are ususally available in their Git repositories. To **clone all the required repositories**, run:

~~~sh
git submodule init
git submodule update --recursive
~~~

To update the repositories to the latest "bleeding edge" commits (which is a really bad idea), run:

~~~sh
git submodule foreach git checkout master
~~~

## Build

Some of the components need to be build. Run `../build-components.sh` to build all the components, or for each of them, run:

~~~sh
docker-compose -f mycomponent.yml run --rm builder
~~~
