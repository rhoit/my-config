#!/usr/bin/bash

initdb --username='postgres' --locale en_US.UTF-8 --pgdata /var/lib/postgres/data

echo "host all all all trust" >> "/var/lib/postgres/data/pg_hba.conf"
if [[ "$1" == 'server' ]]; then
    postgres -h '*' -D /var/lib/postgres/data
else
    pg_ctl --wait --options="-c listen_addresses='*'" --pgdata=/var/lib/postgres/data start
    psql
fi
