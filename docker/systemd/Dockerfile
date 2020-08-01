FROM rhoit/arch:latest

COPY setup.sh /tmp/
COPY ssh-banner /etc/ssh-banner

# pre-change, post-volume-declaration changes are discarded
VOLUME /var/cache/pacman/pkg

RUN /tmp/setup.sh

EXPOSE 22

VOLUME [ "/sys/fs/cgroup" ]
CMD [ "/usr/sbin/init", "--default-standard-output=tty", "--default-standard-error=tty" ]
