CONTAINER=umass-os:assignment00

docker-build:
	docker build --pull --rm -f ./Dockerfile -t $(CONTAINER) . 

docker-run:
	docker run -it --rm -v ./xv6-riscv:/umass-os -p 5001:5000 $(CONTAINER)

# Required target for the template making script
clean:
	rm -rf xv6-riscv

# TODO: Create a rule that uses git to clone the xv6-rsicv repository
# BEGIN DELETE BLOCK
clone-xv6:
	git clone https://github.com/mit-pdos/xv6-riscv.git
# END DELETE BLOCK