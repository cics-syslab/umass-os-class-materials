#
# low-level code to handle traps from user space into
# the kernel, and returns from kernel to user.
#

.align 4
.globl uservec
uservec:    
	#
    # trap_usertrap_return sets mtvec to point here, so
    # traps from user space start here,
    # in machine mode
    #

    # mscratch holds a pointer to proc.kernel_context
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

    # save the user a0 in kernel_context->a0
    csrr t0, mscratch
    sd t0, 88(a0)

    # restore mscratch
    csrw mscratch, a0

    # initialize kernel stack pointer, from user_context->kernel_sp
    ld sp, 0(a0)

    # jump to usertrap(), which does not return
    j trap_usertrap

.globl uservec_ret
uservec_ret:
    # mscratch holds a pointer to proc.kernel_context
    # We don't need to swap with mscratch as above
    # because we are exiting kernel mode and all current
    # registers can be junked. The only important part
    # is that the user state is restored properly.
    # Kernel context is not preserved across.
    # Note that this preserves mscratch, so we don't
    # have to restore it after loading the registers.
    csrr a0, mscratch

    # Note that we don't save the kernel sp at this point.
    # This may seem a little counterintuitive because the
    # switching code relies on having certain values on the
    # stack, right? That is only true while it is in kernel 
    # mode. Recall that switching always happens in kernel
    # mode, so a process that has been saved in the kernel
    # and is waiting to be run is always in kernel mode.
    # The kernel context will save the kernel sp while in 
    # kernel mode so that when it is switched back to, it
    # can access the stack values it relies on. If we are 
    # reaching this point, then the process must be about 
    # to run (in user mode), therefore we don't need to 
    # preserve the kernel stack position and can safely 
    # junk the kernel context. The next time we enter kernel
    # mode we will start at the first address on the kernel
    # stack (highest address) and the switching code will 
    # save our kernel stack pointer when we call
    # switch_to_process.

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

    # restore user a0 last, mscratch is untouched
    ld a0, 88(a0)
    
    # return to user mode and user pc.
    # trap_usertrap_return() set up mstatus and mepc.
    mret
