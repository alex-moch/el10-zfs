# ZFS for Enterprise Linux 10

Build scripts and specs for ZFS packages on RHEL 10-compatible distributions.

## Using the repository

Add the repository:

```bash
sudo curl -o /etc/yum.repos.d/m68k-io.repo https://el.m68k.io/10/m68k-io.repo
```

Install ZFS:

```bash
sudo dnf install zfs zfs-dkms
```

The GPG keys will be imported automatically from the repository configuration.

## Repository

Browse packages: https://el.m68k.io/10/

## Building

To download, build and sign all packages, just run:

```bash
make all
```

## Source

SPEC files are from the [OpenZFS project](https://github.com/openzfs/zfs).

See `Makefile` for configuration options (VERSION, GPG_KEY, PACKAGES).

## License

ZFS is licensed under CDDL. Build scripts are provided as-is.
