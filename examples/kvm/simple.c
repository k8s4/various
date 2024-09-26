#include <stdio.h>
#include <stdlib.h>
#include <inttypes.h>
#include <linux/kvm.h>
#include <sys/mman.h>
#include <fcntl.h>
#include <sys/ioctl.h>
#include <string.h>
#include <err.h>
#include <errno.h>

#define BIOS_FILE "/usr/share/seabios/bios-256k.bin"
#define BIOS_SIZE 256 * 1024
#define RAM_SIZE 2 * 1024 * 1024
#define BIOS_DEBUG_PORT 0x402
#define BIOS_DEBUG_VALUE 0xe9

int main ()
{
    struct kvm_sregs sregs;
    struct kvm_pit_config pit_config;

    int kvm_fd = open("/dev/kvm", O_RDWR);

    if (kvm_fd < 0) {
        err(1, "open /dev/kvm");
    }

    int vm_fd = ioctl(kvm_fd, KVM_CREATE_VM, 0);

    if (vm_fd < 0) {
        err(1, "ioctl KVM_CREATE_VM");
    }

    if (ioctl(vm_fd, KVM_CREATE_IRQCHIP) < 0) {
        err(1, "ioctl KVM_CREATE_IRQCHIP");
    }

    memset(&pit_config, 0, sizeof(pit_config));

    if (ioctl(vm_fd, KVM_CREATE_PIT2, &pit_config) < 0) {
        err(1, "ioctl KVM_CREATE_PIT2");
    }

    int vcpu_fd = ioctl(vm_fd, KVM_CREATE_VCPU, 0);

    if (vcpu_fd < 0) {
        err(1, "ioctl KVM_CREATE_VCPU");
    }

    FILE *f = fopen(BIOS_FILE, "rb");
    if (!f) {
        err(1, "fopen %s", BIOS_FILE);
    }

    uint8_t *bios_buf = malloc(BIOS_SIZE);

    if (fread(bios_buf, 1, BIOS_SIZE, f) != BIOS_SIZE) {
        err(1, "fread bios");
    }

    fclose(f);

    uint8_t *ptr = mmap(NULL, RAM_SIZE, PROT_READ | PROT_WRITE, MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);

    if (ptr == MAP_FAILED) {
        err(1, "mmap ram");
    }

    struct kvm_userspace_memory_region region;
    region.slot = 0;
    region.flags = 0;
    region.guest_phys_addr = 0;
    region.memory_size = RAM_SIZE;
    region.userspace_addr = (uintptr_t)ptr;

    if (ioctl(vm_fd, KVM_SET_USER_MEMORY_REGION, &region) < 0) {
        err(1, "ioctl KVM_SET_USER_MEMORY_REGION");
    }

    memcpy(ptr + 0x100000 - BIOS_SIZE, bios_buf, BIOS_SIZE);

    int kvm_run_size = ioctl(kvm_fd, KVM_GET_VCPU_MMAP_SIZE, NULL);

    struct kvm_run *kvm_run = mmap(NULL, kvm_run_size, PROT_READ | PROT_WRITE, MAP_SHARED, vcpu_fd, 0);

    if (kvm_run == MAP_FAILED) {
        err(1, "mmap kvm_run");
    }

    ioctl(vcpu_fd, KVM_GET_SREGS, &sregs);
    sregs.cs.base = sregs.cs.selector << 4;
    ioctl(vcpu_fd, KVM_SET_SREGS, &sregs);

    while (1) {
        int ret = ioctl(vcpu_fd, KVM_RUN, 0);
        if (ret < 0) {
            if (ret == -EINTR || ret == -EAGAIN) {
                continue;
            }
            err(1, "KVM_RUN");
        }

        switch (kvm_run->exit_reason) {
            case KVM_EXIT_IO:
                ptr = (uint8_t *)kvm_run + kvm_run->io.data_offset;
                for (int i = 0; i < kvm_run->io.count; i++) {
                    if (kvm_run->io.port == BIOS_DEBUG_PORT) {
                        if (kvm_run->io.direction == KVM_EXIT_IO_OUT) {
                            putchar(*ptr);
                        } else {
                            *ptr = BIOS_DEBUG_VALUE;
                        }
                    }
                    ptr += kvm_run->io.size;
                }
                break;
        }
    }

    return 0;
}


