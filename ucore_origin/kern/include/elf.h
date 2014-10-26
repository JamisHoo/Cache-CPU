#ifndef __LIBS_ELF_H__
#define __LIBS_ELF_H__

#include <defs.h>

#define ELF_MAGIC   0x464C457FU         // "\x7FELF" in little endian

/* file header */
struct __elfhdr {
    uint32_t e_magic;     // must equal ELF_MAGIC
    uint8_t e_elf[12];
    unsigned short e_type;      // 1=relocatable, 2=executable, 3=shared object, 4=core image
    unsigned short e_machine;   // 3=x86, 4=68K, etc.
    uint32_t e_version;   // file version, always 1
    uint32_t e_entry;     // entry point if executable
    uint32_t e_phoff;     // file position of program header or 0
    uint32_t e_shoff;     // file position of section header or 0
    uint32_t e_flags;     // architecture-specific flags, usually 0
    unsigned short e_ehsize;    // size of this elf header
    unsigned short e_phentsize; // size of an entry in program header
    unsigned short e_phnum;     // number of entries in program header or 0
    unsigned short e_shentsize; // size of an entry in section header
    unsigned short e_shnum;     // number of entries in section header or 0
    unsigned short e_shstrndx;  // section number that contains section name strings
};

struct elfhdr32 {
    uint32_t e_magic;     // must equal ELF_MAGIC
    uint8_t e_elf[12];
    uint32_t e_type;      // 1=relocatable, 2=executable, 3=shared object, 4=core image
    uint32_t e_machine;   // 3=x86, 4=68K, etc.
    uint32_t e_version;   // file version, always 1
    uint32_t e_entry;     // entry point if executable
    uint32_t e_phoff;     // file position of program header or 0
    uint32_t e_shoff;     // file position of section header or 0
    uint32_t e_flags;     // architecture-specific flags, usually 0
    uint32_t e_ehsize;    // size of this elf header
    uint32_t e_phentsize; // size of an entry in program header
    uint32_t e_phnum;     // number of entries in program header or 0
    uint32_t e_shentsize; // size of an entry in section header
    uint32_t e_shnum;     // number of entries in section header or 0
    uint32_t e_shstrndx;  // section number that contains section name strings
};

static inline void _load_elfhdr(unsigned char* base, struct elfhdr32 *hdr)
{
  struct __elfhdr *eh = (struct __elfhdr*)base;
  hdr->e_magic = eh->e_magic;
  hdr->e_version = eh->e_version;
  hdr->e_entry = eh->e_entry;
  hdr->e_phoff = eh->e_phoff;
  hdr->e_shoff = eh->e_shoff;
  hdr->e_flags = eh->e_flags;

  uint32_t t = *(uint32_t*)(&eh->e_type);
  hdr->e_type = t & 0xFFFF;
  hdr->e_machine = t >> 16;

  t = *(uint32_t*)(&eh->e_ehsize);
  hdr->e_ehsize = t & 0xFFFF;
  hdr->e_phentsize = t >> 16;

  t = *(uint32_t*)(&eh->e_phnum);
  hdr->e_phnum = t & 0xFFFF;
  hdr->e_shentsize = t >> 16;

  t = *(uint32_t*)(&eh->e_shnum);
  hdr->e_shnum = t & 0xFFFF;
  hdr->e_shstrndx = t >> 16;
}

/* program section header */
struct proghdr {
    uint32_t p_type;   // loadable code or data, dynamic linking info,etc.
    uint32_t p_offset; // file offset of segment
    uint32_t p_va;     // virtual address to map segment
    uint32_t p_pa;     // physical address, not used
    uint32_t p_filesz; // size of segment in file
    uint32_t p_memsz;  // size of segment in memory (bigger if contains bss）
    uint32_t p_flags;  // read/write/execute bits
    uint32_t p_align;  // required alignment, invariably hardware page size
};

/* values for Proghdr::p_type */
#define ELF_PT_LOAD                     1

/* flag bits for Proghdr::p_flags */
#define ELF_PF_X                        1
#define ELF_PF_W                        2
#define ELF_PF_R                        4

#endif /* !__LIBS_ELF_H__ */

