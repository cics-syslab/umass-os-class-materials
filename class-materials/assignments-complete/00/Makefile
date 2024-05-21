CONTAINER=umass-os:assignment00

# --pull was removed from this rule after discussing with Tim and successfully building without it
# Previously it appeared that it was required to build the image. If something goes wrong building
# the image try including --pull.
docker-build:
	docker build --rm -f ./Dockerfile -t $(CONTAINER) . 

docker-run:
	docker run -it --rm -v ./xv6-riscv:/umass-os -p 5001:5000 $(CONTAINER)

# Required target for the template making script
clean:
	rm -rf xv6-riscv

# TODO: Create a rule called `clone-xv6` that uses git to clone the xv6-rsicv repository,
# available at https://github.com/mit-pdos/xv6-riscv.git.
# BEGIN DELETE BLOCK
clone-xv6:
	git clone https://github.com/mit-pdos/xv6-riscv.git
# END DELETE BLOCK