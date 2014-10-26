/*
 * $File: fetchrun.h
 * $Date: Fri Dec 20 16:46:50 2013 +0800
 * $Author: Xinyu Zhou <zxytim[at]gmail[dot]com>
 */

#ifndef __KERN_FETCHRUN_FETCHRUN_H__
#define __KERN_FETCHRUN_FETCHRUN_H__

/**
 * fetch a program from serial bus and write to fd
 */
int fetchrun(int fd, const char *fpath_user, size_t fpath_len);

#endif // __KERN_FETCHRUN_FETCHRUN_H__

/**
 * vim: foldmethod=marker
 */

