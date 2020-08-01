#!/usr/bin/bash

initdb --username='postgres' --locale en_US.UTF-8 --pgdata /var/lib/postgres/data

if [[ "$1" == psql ]]; then
    pg_ctl --wait --pgdata=/var/lib/postgres/data start
    psql
else
    echo "host all all all trust" >> "/var/lib/postgres/data/pg_hba.conf"
    postgres -h '*' -D /var/lib/postgres/data
fi
