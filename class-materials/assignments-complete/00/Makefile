CONTAINER=umass-os:assignment00

docker-build:
	docker build --pull --rm -f ./Dockerfile -t $(CONTAINER) . 

docker-run:
	docker run -it --rm -v ./xv6-riscv:/umass-os -p 5001:5000 $(CONTAINER)

# Required target for the template making script
clean:
	rm -rf xv6-riscv
# BEGIN DELETE BLOCK
# Just for convenience, don't include in the student's copy
clone-xv6:
	git clone https://github.com/mit-pdos/xv6-riscv.git
# END DELETE BLOCK