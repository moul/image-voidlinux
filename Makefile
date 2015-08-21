DOCKER_NAMESPACE =	armbuild/
NAME =			scw-distrib-voidlinux
VERSION =		latest
VERSION_ALIASES =	rpi2-20150713 rpi2
TITLE =			Void Linux
DESCRIPTION =		Void Linux
SOURCE_URL =		https://github.com/scaleway/image-voidlinux
SHELL =			/bin/bash


all: help


##
## Image tools  (https://github.com/scaleway/image-tools)
##
all:	docker-rules.mk
docker-rules.mk:
	wget -qO - http://j.mp/scw-builder | bash
-include docker-rules.mk
