## -*- docker-image-name: "armbuild/scw-distrib-voidlinux:latest" -*-
FROM armbuild/voidlinux:rpi2-20150713
MAINTAINER Scaleway <opensource@scaleway.com> (@scaleway)

RUN rm -f /sbin/init /bin/init \
 && ln -s runit-init ../sbin/init

ADD ./patches/etc/ /etc/
ADD ./patches/usr/ /usr/

RUN xbps-install -Suv -y \
 && xbps-install -S vim -y \
 && xbps-install -S curl -y \
 && curl -Lq http://j.mp/scw-skeleton | FLAVORS=common bash -e


RUN sed -ri 's/BAUD_RATE=([0-9]*)/BAUD_RATE=9600/g' /etc/sv/agetty-ttyS0/conf \
 && ln -s /etc/sv/agetty-ttyS0 /etc/runit/runsvdir/current/

RUN rm /etc/runit/runsvdir/current/agetty-tty[1-6]
RUN chsh -s '/bin/bash'

RUN sed -ri 's/exec/\/usr\/local\/sbin\/oc-fetch-ssh-keys &\n\/usr\/local\/sbin\/oc-generate-ssh-keys &\nwait `jobs -p` || true\nexec/g' /etc/sv/sshd/run

# Change root password
RUN sed -i -e "s/^root:[^:]\+:/root:$(< /dev/urandom tr -dc _A-Z-a-z-0-9 | head -c${1:-32};echo;):/" /etc/shadow

# Cleaning
RUN rm -fr /var/cache/xbps/*

# Environment
ENV SCW_BASE_IMAGE armbuild/scw-voidlinux:latest
