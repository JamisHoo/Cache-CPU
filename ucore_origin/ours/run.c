/*
 * $File: run.c
 * $Date: Fri Dec 20 20:05:32 2013 +0800
 * $Author: Xinyu Zhou <zxytim[at]gmail[dot]com>
 */

#include <syscall.h>
#include <error.h>
#include <file.h>
#include <unistd.h>
#include <ulib.h>
#include <stdio.h>

#include "progdef.h"


#define BUFSIZE			4096

int testfile(const char *name) {
    int ret;
    if ((ret = open(name, O_RDONLY)) < 0) {
		dprintf("testfile: %s, ret = %d\n", name, ret);
        return ret;
    }
	dprintf("testfile: %s, ret = %d\n", name, ret);
    close(ret);
    return ret;
}

int run_prog(const char *fname, int argc, char *_argv[]) {
	static char argv0[BUFSIZE];
	const char *argv[EXEC_MAX_ARG_NUM + 1];
	int ret;
	if ((ret = testfile(fname)) != 0) {
		if (ret < 0) {
			return ret;
		}
		snprintf(argv0, sizeof(argv0), "/%s", fname);
		argv[0] = argv0;
	}
	int i;
	for (i = 2; i < argc; i ++)
		argv[i - 1] = _argv[i];
	argc --;
	argv[argc] = NULL;
	for (i = 0; i < argc; i ++)
		dprintf("argv[%d]: %s\n", i, argv[i]);

	dprintf("== exec now ==\n");
	return __exec(NULL, argv);
}

int main(int argc, char *argv[]) {
	if (argc < 2) {
		cprintf("usage: %s <file path> [args to prog ...]\n", argv[0]);
		return 0;
	}
	int fd;
	fd = open(PROG_FILE_NAME, O_WRONLY);
	int size = sys_fetchrun(fd, argv[1]);
	if (size <= 0) {
		if (size == -1)
			cprintf("failed to fetch: bad fpath ?WTF\n");
		else if (size == -2)
			cprintf("failed to fetch: remote error\n");
		else
			cprintf("failed to fetch: %d\n", size);
		return -1;
	} else
		cprintf("fetch: size=%d\n", size);
	close(fd);
	int pid, ret, i;
	if ((pid = fork()) == 0) {
		ret = run_prog(PROG_FILE_NAME, argc, argv);
		exit(ret);
	}
	if (waitpid(pid, &ret) == 0) {
		if (ret != 0) {
			cprintf("error: %d - %e\n", ret, ret);
		}
	}
	return ret;
}

/**
 * vim: foldmethod=marker
 */

