FROM rhoit/arch:latest

COPY setup.sh /tmp/

# pre-change, post-volume-declaration changes are discarded
VOLUME /var/cache/pacman/pkg

RUN /tmp/setup.sh

USER postgres

COPY docker-entrypoint.sh /usr/local/bin/
ENTRYPOINT ["docker-entrypoint.sh"]

EXPOSE 5432
