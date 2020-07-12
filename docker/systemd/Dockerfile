FROM rhoit/arch:latest

COPY id_rsa.pub sysd.sh /tmp/

# pre-change, post-volume-declaration changes are discarded
VOLUME /var/cache/pacman/pkg

RUN /tmp/sysd.sh

EXPOSE 22

VOLUME [ "/sys/fs/cgroup" ]
CMD [ "/usr/sbin/init" ]
