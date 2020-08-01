build-image: is-docker-service-up
	docker build --tag="rhoit/pg" ./


test-run: is-docker-service-up
	docker run -it --rm rhoit/pg


is-docker-service-up:
	systemctl is-active docker
