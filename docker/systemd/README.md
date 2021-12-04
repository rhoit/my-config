# systemd in docker


Starting systemd 248 (as host systemd), mounting /sys/fs/cgroup
read-only is not possible anymore.

https://github.com/systemd/systemd/issues/19245

Image is based archlinux.

Configuration for running systemd in *privileged* container.

multi-user login has been enable modifing
*systemd-user-sessions.services*

Pre-build image at [rhoit/sysd](https://hub.docker.com/repository/docker/rhoit/sysd)


## RUNNING

``` bash
docker run --privileged --rm --tty -v /sys/fs/cgroup:/sys/fs/cgroup:ro rhoit/sysd
```

default ssh credentials:

**user**: `root` **pass**: `toor`

## COMPOSE

compose yaml setting for enabling all capability and tty.

```yaml
cap_add: [ 'all' ]
tty: true
```
