build-image: is-docker-service-up
	docker build --tag="rhoit/sysd" ./


test-run: is-docker-service-up
	docker run --privileged --rm --tty -v /sys/fs/cgroup:/sys/fs/cgroup:ro rhoit/sysd
	@echo ssh is exposed


is-docker-service-up:
	systemctl is-active docker
