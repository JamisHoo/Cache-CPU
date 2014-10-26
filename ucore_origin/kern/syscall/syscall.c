#include <unistd.h>
#include <proc.h>
#include <syscall.h>
#include <trap.h>
#include <stdio.h>
#include <pmm.h>
#include <assert.h>
#include <stat.h>
#include <dirent.h>
#include <sysfile.h>
#include <fetchrun.h>
#include <console.h>

extern volatile int ticks;

static int
sys_exit(uint32_t arg[]) {
    int error_code = (int)arg[0];
    return do_exit(error_code);
}

static int
sys_fork(uint32_t arg[]) {
    struct trapframe *tf = current->tf;
    uintptr_t stack = tf->tf_regs.reg_r[MIPS_REG_SP];
    return do_fork(0, stack, tf);
}

static int
sys_wait(uint32_t arg[]) {
    int pid = (int)arg[0];
    int *store = (int *)arg[1];
    return do_wait(pid, store);
}

static int
sys_exec(uint32_t arg[]) {
    const char *name = (const char *)arg[0];
    int argc = (int)arg[1];
    const char **argv = (const char **)arg[2];
    return do_execve(name, argc, argv);
}

static int
sys_yield(uint32_t arg[]) {
    return do_yield();
}

static int
sys_kill(uint32_t arg[]) {
    int pid = (int)arg[0];
    return do_kill(pid);
}

static int
sys_getpid(uint32_t arg[]) {
    return current->pid;
}

static int
sys_putc(uint32_t arg[]) {
    int c = (int)arg[0];
    kputchar(c);
    return 0;
}

static int
sys_pgdir(uint32_t arg[]) {
    print_pgdir();
    return 0;
}

static int
sys_gettime(uint32_t arg[]) {
    return (int)ticks;
}

static int
sys_sleep(uint32_t arg[]) {
    unsigned int time = (unsigned int)arg[0];
    return do_sleep(time);
}

static int
sys_open(uint32_t arg[]) {
    const char *path = (const char *)arg[0];
    uint32_t open_flags = (uint32_t)arg[1];
    return sysfile_open(path, open_flags);
}

static int
sys_close(uint32_t arg[]) {
    int fd = (int)arg[0];
    return sysfile_close(fd);
}

static int
sys_read(uint32_t arg[]) {
    int fd = (int)arg[0];
    void *base = (void *)arg[1];
    size_t len = (size_t)arg[2];
    return sysfile_read(fd, base, len);
}

static int
sys_write(uint32_t arg[]) {
    int fd = (int)arg[0];
    void *base = (void *)arg[1];
    size_t len = (size_t)arg[2];
    return sysfile_write(fd, base, len);
}

static int
sys_seek(uint32_t arg[]) {
    int fd = (int)arg[0];
    off_t pos = (off_t)arg[1];
    int whence = (int)arg[2];
    return sysfile_seek(fd, pos, whence);
}

static int
sys_fstat(uint32_t arg[]) {
    int fd = (int)arg[0];
    struct stat *stat = (struct stat *)arg[1];
    return sysfile_fstat(fd, stat);
}

static int
sys_fsync(uint32_t arg[]) {
    int fd = (int)arg[0];
    return sysfile_fsync(fd);
}

static int
sys_chdir(uint32_t arg[]) {
    const char *path = (const char *)arg[0];
    return sysfile_chdir(path);
}

static int
sys_getcwd(uint32_t arg[]) {
    char *buf = (char *)arg[0];
    size_t len = (size_t)arg[1];
    return sysfile_getcwd(buf, len);
}


static int
sys_getdirentry(uint32_t arg[]) {
    int fd = (int)arg[0];
    struct dirent *direntp = (struct dirent *)arg[1];
    return sysfile_getdirentry(fd, direntp);
}

static int
sys_dup(uint32_t arg[]) {
    int fd1 = (int)arg[0];
    int fd2 = (int)arg[1];
    return sysfile_dup(fd1, fd2);
}

/**
 * fetch a program from serial bus
 * args:
 *		0 fd
 */
static int
sys_fetchrun(uint32_t arg[]) {
	int fd = (int)arg[0];
	const char *fpath = (const char*)arg[1];
	size_t fpath_len = (size_t)arg[2];
	fetchrun(fd, fpath, fpath_len);
}

static int
sys_redraw_console(uint32_t arg[]) {
    bool intr_flag;
    local_intr_save(intr_flag);
	vga_redraw();
    local_intr_restore(intr_flag);
	return 0;
}

static int (*syscalls[])(uint32_t arg[]) = {
  [SYS_exit]              sys_exit,
  [SYS_fork]              sys_fork,
  [SYS_wait]              sys_wait,
  [SYS_exec]              sys_exec,
  [SYS_yield]             sys_yield,
  [SYS_kill]              sys_kill,
  [SYS_getpid]            sys_getpid,
  [SYS_putc]              sys_putc,
  [SYS_pgdir]             sys_pgdir,
  [SYS_gettime]           sys_gettime,
  [SYS_sleep]             sys_sleep,
  [SYS_open]              sys_open,
  [SYS_close]             sys_close,
  [SYS_read]              sys_read,
  [SYS_write]             sys_write,
  [SYS_seek]              sys_seek,
  [SYS_fstat]             sys_fstat,
  [SYS_fsync]             sys_fsync,
  [SYS_getcwd]            sys_getcwd,
  [SYS_getdirentry]       sys_getdirentry,
  [SYS_dup]               sys_dup,
  [SYS_fetchrun]          sys_fetchrun,
  [SYS_redraw_console]    sys_redraw_console,
};

#define NUM_SYSCALLS        ((sizeof(syscalls)) / (sizeof(syscalls[0])))

//系统调用
void
syscall(void) {
  assert(current != NULL);
  struct trapframe *tf = current->tf;
  uint32_t arg[4];                              //系统调用的四个参数，从A寄存器传进来
  int num = tf->tf_regs.reg_r[MIPS_REG_V0];     //mips syscall的类型从v0寄存器传进来
  num -= SYSCALL_BASE;
  //kprintf("$ %d %d\n",current->pid, num);
  if (num >= 0 && num < NUM_SYSCALLS) {
    if (syscalls[num] != NULL) {
      arg[0] = tf->tf_regs.reg_r[MIPS_REG_A0];
      arg[1] = tf->tf_regs.reg_r[MIPS_REG_A1];
      arg[2] = tf->tf_regs.reg_r[MIPS_REG_A2];
      arg[3] = tf->tf_regs.reg_r[MIPS_REG_A3];
      tf->tf_regs.reg_r[MIPS_REG_V0] = syscalls[num](arg);    //syscall
      return ;
    }
  }
  print_trapframe(tf);
  panic("undefined syscall %d, pid = %d, name = %s.\n",
      num, current->pid, current->name);
}

