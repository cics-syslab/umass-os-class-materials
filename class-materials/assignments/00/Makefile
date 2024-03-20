CONTAINER=umass-os:assignment00

docker-build:
	docker build --pull --rm -f ./Dockerfile -t $(CONTAINER) . 

docker-run:
	docker run -it --rm -v ./xv6-riscv:/umass-os -p 5001:5000 $(CONTAINER)
