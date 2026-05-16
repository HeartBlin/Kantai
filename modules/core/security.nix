_:

{
  boot = {
    # Seeds RNG from the CPU's jitter
    initrd.kernelModules = [ "jitterentropy_rng" ];

    kernelParams = [
      "randomize_kstack_offset=on" # Random stack offset for every system call
      "slab_nomerge" # Disables merging of similar slab caches
      "efi=disable_early_pci_dma" # Block DMA attacks at boot
      "page_alloc.shuffle=1" # Randomizes page allocator freelist
      "vsyscall=none" # Some old ass acceleration
      "debugfs=off" # Debugging not needed here
      "random.trust_cpu=off" # Dont trust the CPU to seed RNG
      "random.trust_bootloader=off" # Even worse than above
    ];

    kernel.sysctl = {
      "kernel.kptr_restrict" = 2; # Hides kernel pointers in /proc for root
      "kernel.dmesg_restrict" = 1; # Restrict dmesg to CAP_SYSLOG
      "kernel.kexec_load_disabled" = 1; # Denies kexecs
      "kernel.unprivileged_bpf_disabled" = 1; # Restricts bpf() calls to root
      "kernel.yama.ptrace_scope" = 2; # Only for CAP_SYS_PTRACE, doesnt kill gdb entirely
      "net.core.bpf_jit_harden" = 2; # Mitigate JIT Spray attacks
      "net.ipv4.tcp_rfc1337" = 1; # Hahah LEET. Prevents TIME-WAIT Assassination
      "dev.tty.ldisc_autoload" = 0; # Dont auto-load TTY line disciplines
    };

    blacklistedKernelModules = [
      "adfs"
      "af_802154"
      "affs"
      "appletalk"
      "atm"
      "ax25"
      "befs"
      "bfs"
      "cifs"
      "cramfs"
      "dccp"
      "decnet"
      "econet"
      "efs"
      "erofs"
      "esp4"
      "esp6"
      "exofs"
      "f2fs"
      "firewire-core"
      "freevxfs"
      "gfs2"
      "hfs"
      "hfsplus"
      "hpfs"
      "ipx"
      "jffs2"
      "jfs"
      "ksmbd"
      "minix"
      "n-hdlc"
      "netrom"
      "nfs"
      "nfsv3"
      "nfsv4"
      "nilfs2"
      "omfs"
      "qnx4"
      "qnx6"
      "rds"
      "rose"
      "rxrpc"
      "sctp"
      "squashfs"
      "sysv"
      "thunderbolt" # It's still in type-c mode on my laptop. Still
      "tipc"
      "udf"
      "vivid"
      "x25"
    ];
  };
}
