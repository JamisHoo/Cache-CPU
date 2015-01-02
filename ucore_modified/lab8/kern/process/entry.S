.text
.globl kernel_thread_entry
kernel_thread_entry:        # void kernel_thread(void)

    addiu   $sp, $sp, -0x10 # reserved for arg
    move    $fp, $sp
    jalr    $a1             # call fn

    move    $a0, $v0        # save the return value of fn(arg)
    jal     do_exit         # call do_exit to terminate current thread

