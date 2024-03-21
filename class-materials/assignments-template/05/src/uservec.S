        #
        # low-level code to handle traps from user space into
        # the kernel, and returns from kernel to user.
        #
        # the kernel maps the page holding this code
        # at the same virtual address (TRAMPOLINE)
        # in user and kernel space so that it continues
        # to work when it switches page tables.
        # kernel.ld causes this code to start at 
        # a page boundary.
        #

.align 4
.globl uservec
uservec:    
	#
    # trap_usertrap_return sets stvec to point here, so
    # traps from user space start here,
    # in supervisor mode
    #

    # mscratch holds the pointer to the proc block
    # swap with a0 to get the pointer into a 
    # general pupose register
    csrrw a0, mscratch, a0
    
    # save the user registers in proc's user_context
    sd ra, 16(a0)
    sd sp, 24(a0)
    sd gp, 32(a0)
    sd tp, 40(a0)
    sd t0, 48(a0)
    sd t1, 56(a0)
    sd t2, 64(a0)
    sd s0, 72(a0)
    sd s1, 80(a0)
    # leave blank for a0
    sd a1, 96(a0)
    sd a2, 104(a0)
    sd a3, 112(a0)
    sd a4, 120(a0)
    sd a5, 128(a0)
    sd a6, 136(a0)
    sd a7, 144(a0)
    sd s2, 152(a0)
    sd s3, 160(a0)
    sd s4, 168(a0)
    sd s5, 176(a0)
    sd s6, 184(a0)
    sd s7, 192(a0)
    sd s8, 200(a0)
    sd s9, 208(a0)
    sd s10, 216(a0)
    sd s11, 224(a0)
    sd t3, 232(a0)
    sd t4, 240(a0)
    sd t5, 248(a0)
    sd t6, 256(a0)

    # save the user a0 in p->trapframe->a0
    csrr t0, mscratch
    sd t0, 88(a0)

    # restore mscratch
    csrw mscratch, a0

    # initialize kernel stack pointer, from p->trapframe->kernel_sp
    ld sp, 0(a0)

    # jump to usertrap(), which does not return
    j trap_usertrap

.globl uservec_ret
uservec_ret:
    # mscratch holds the pointer to the proc block
    # swap with a0 to get the pointer into a 
    # general pupose register
    csrr a0, mscratch

    # restore all but a0 from TRAPFRAME
    ld ra, 16(a0)
    ld sp, 24(a0)
    ld gp, 32(a0)
    ld tp, 40(a0)
    ld t0, 48(a0)
    ld t1, 56(a0)
    ld t2, 64(a0)
    ld s0, 72(a0)
    ld s1, 80(a0)
    # leave blank for a0
    ld a1, 96(a0)
    ld a2, 104(a0)
    ld a3, 112(a0)
    ld a4, 120(a0)
    ld a5, 128(a0)
    ld a6, 136(a0)
    ld a7, 144(a0)
    ld s2, 152(a0)
    ld s3, 160(a0)
    ld s4, 168(a0)
    ld s5, 176(a0)
    ld s6, 184(a0)
    ld s7, 192(a0)
    ld s8, 200(a0)
    ld s9, 208(a0)
    ld s10, 216(a0)
    ld s11, 224(a0)
    ld t3, 232(a0)
    ld t4, 240(a0)
    ld t5, 248(a0)
    ld t6, 256(a0)

    # restore user a0
    ld a0, 88(a0)
    
    # return to user mode and user pc.
    # trap_usertrap_return() set up mstatus and mepc.
    mret
