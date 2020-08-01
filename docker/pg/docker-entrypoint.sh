#!/usr/bin/bash

initdb --username='postgres' --locale en_US.UTF-8 --pgdata /var/lib/postgres/data
PGUSER=postgres pg_ctl --wait --pgdata=/var/lib/postgres/data start
psql
