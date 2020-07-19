# systemd in docker


Image is based archlinux.

Configuration for for running systemd in *privileged* container.

multi-user login has been enable modifing
*systemd-user-sessions.services*

## RUNNING

``` bash
docker run --privileged --rm --tty -v /sys/fs/cgroup:/sys/fs/cgroup:ro rhoit/sysd
```

default ssh credentials:

*user*: =root= *pass*: =toor=

## COMPOSE

```yaml
cap_add: [ 'all' ]
tty: true
```
