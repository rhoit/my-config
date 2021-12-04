# postgres server


Starting systemd 248 (as host systemd), mounting /sys/fs/cgroup
read-only is not possible anymore.

https://github.com/systemd/systemd/issues/19245

Image is based archlinux.

This is bare image for running postgresql server and getting psql shell.

Pre-build image at [rhoit/pg](https://hub.docker.com/repository/docker/rhoit/pg)

## RUNNING

run **psql**

``` bash
docker run -it --rm rhoit/pg
```

run as **server**

``` bash
docker run -it --rm rhoit/pg server
```
