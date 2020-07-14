sysd-image-build: is-docker-service-up
	cp ~/.ssh/id_rsa.pub ./
	docker build --tag="rhoit/sysd" ./
	rm ./id_rsa.pub


sysd-run-test: is-docker-service-up
	docker run --privileged --rm -v /sys/fs/cgroup:/sys/fs/cgroup:ro rhoit/sysd
	@echo ssh is exposed


is-docker-service-up:
	systemctl is-active docker
