#ifndef _MMU_H
#define _MMU_H 1

#define CR0_PE 0x00000001
#define CR0_WP 0x00010000
#define CR0_PG 0x80000000

#define CR4_PSE 0x00000010

#define DPL_USER 0x3

#define NUM_PDE 1024
#define NUM_PTE 1024
#define PGSIZE 4096

#define PTE_P 0x001
#define PTE_W 0x002
#define PTE_U 0x004
#define PTE_PS 0x080

typedef uint32_t pde_t;
#endif
