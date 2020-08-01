#!/usr/bin/bash

echo "postgres:x:88:88:PostgreSQL user:/var/lib/postgres:/bin/bash" >> /etc/passwd
echo "postgres:x:88:" >> /etc/group

pacman --noconfirm --needed --sync audit postgresql

mkdir -m 2777 /var/run/postgresql
install -d -o postgres -g postgres /var/lib/postgres
