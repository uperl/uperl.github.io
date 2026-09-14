# Frequently Asked Questions

## One of your distributions' tarballs contains macOS extended attributes (like `com.apple.provenance`). What's going on?

Depending on which `tar` you use to extract it, you might see something
harmless like GNU `tar`'s:

```
tar: Ignoring unknown extended header keyword 'LIBARCHIVE.xattr.com.apple.provenance'
```

or, with a `tar` that actually attempts to honor the attribute (for example
when extracting as root), an outright error trying to restore an attribute
that makes no sense on your platform.

The easiest workaround is to avoid extracting the tarball as root, and/or tell
`tar` not to bother with the extended attributes at all:

 * With GNU `tar`, use the option `--warning=no-unknown-keyword` to
   supress the warnings explicitly.

   ```
   tar --warning=no-unknown-keyword -xf Some-Dist-1.23.tar.gz
   ```

 * With a `libarchive`-based `tar` (the default on macOS, FreeBSD and
   NetBSD), extracting as a non-root user already skips extended attributes
   by default. As root, it tries to restore them, which is what triggers the
   error — so either extract as a normal user, or pass `--no-xattrs`
   explicitly:

   ```
   tar --no-xattrs -xf Some-Dist-1.23.tar.gz
   ```

This shouldn't normally happen. The vast majority of my
distributions releases are from Linux, and/or built using a `Dist::Zilla`
plugin that produces the release tarball itself, rather than shelling out to
the system `tar`. Neither of those paths pick up macOS extended attributes.

If you've run into a tarball that does contain them, it's almost certainly one
of the few older, "classic" distributions that are still built the old
fashioned way, with a hand-written `Makefile.PL` and `ExtUtils::MakeMaker`'s
own `make dist`. On macOS, that target shells out to the system `tar`, which
by default stores any extended attributes present on the files being archived
(such as `com.apple.provenance`, which macOS adds to files automatically, for
example when they've been downloaded or extracted from another archive) as
extended `pax` headers in the resulting tarball.

If this is a bug, then it is a bug in `ExtUtils::MakeMaker`'s `make dist`
target, which doesn't strip or disable extended attribute propagation when it
invokes `tar` on macOS. If you run into it, please report it to
[`ExtUtils::MakeMaker`](https://github.com/Perl-Toolchain-Gang/ExtUtils-MakeMaker)
rather than the individual distribution — it isn't something specific to any
one distribution's code, and any classic `Makefile.PL`-based dist released
from a Mac is equally exposed to it.
