FROM rhoit/arch:latest

COPY sysd.sh /tmp/

# pre-change, post-volume-declaration changes are discarded
VOLUME /var/cache/pacman/pkg

RUN /tmp/sysd.sh

EXPOSE 22

VOLUME [ "/sys/fs/cgroup" ]
CMD [ "/usr/sbin/init" ]
