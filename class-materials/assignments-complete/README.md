# Lesson 0: Setting Up The Environment

### Table of contents:
- [TLDR](#tldr)
- [Intro](#intro)
- [Docker](#docker)
- [Qemu](#qemu)
- [Make](#make)
- [Tmux](#tmux)
- [GDB](#gdb)
	- [Pwndbg](#pwndbg)
	- [Gdbugi](#gdbgui)

### TLDR: 
- Duration: two classes
- Homework assignments: one
- Topics covered: 
	- Docker
	- Tmux
	- Qemu
	- Make
	- GDB
		- Pwndbg
- Prerequisites:
	- Familiarity with Linux CLI
	
### Intro
This lesson is designed to help students get setup with an environment that will let them develop `umass-os`. Students are expected to be familiar with command line environments but are not expected to know any of the tools we will be using, although having at least some knowledge of them will be helpful. 

To achieve as uniform an environment as possible for all students, this course will use [Docker](#docker). To simplify the build process we will use [Make](#make). To run the OS we will use [Qemu](#qemu) and [Tmux](#tmux). To debug it we will use [GDB](#gdb) with the [Pwndbg](#pwndbg) front end. 

Students are encouraged to use their own environment if they choose, however for the instructor's sake, this is the only environment officially supported.

### Docker
In order to create a uniform environment, a dockerfile is provided that comes with all of the tools necessary to work on `umass-os`. It can be found at `class-materials/dockerfiles/Dockerfile-pwndbg`. It sets up the environment discussed above and is suitable for all assignments. This is the recommended environment.

Additionally, another dockerfile can be found at `class-materials/dockerfiles/Dockerfile-gdbgui` that sets up an environment based around an experimental web-based frontend for GDB. It is slightly trickier to setup and somewhat more brittle, but it is suitable for all assignments. The author believes that having a familiarity with command line debugging is essential to anyone wishing to do serious systems development, therefore this environment is not recommended. It may be provided to students at the instructor's discretion.

Both dockerfiles can be built with `docker build --rm -f <dockerfile> -t <container-name> . ` and ran with `docker run -it --rm -v ./xv6-riscv:/umass-os -p 5001:5000 <container-name>` from the `class-assignmentsalthough the `Makefile` contains rules to build and run them.

### Sample Header
some text
