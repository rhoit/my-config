build-image: is-docker-service-up
	docker build --tag="rhoit/sysd" ./


sysd-run-test: is-docker-service-up
	docker run --privileged --rm -v /sys/fs/cgroup:/sys/fs/cgroup:ro rhoit/sysd
	@echo ssh is exposed


is-docker-service-up:
	systemctl is-active docker
