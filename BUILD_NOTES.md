# GMMPS build notes: macOS (arm64) and Linux, Oct 2026

Work on branch `add_mike` to make `install.sh` build GMMPS with current
compilers: Apple clang on Apple Silicon, and GCC 4.8.5 to 11.4.0 on Linux.
Tcl/Tk 8.4 and all of skycat now build on every platform tested. The last
step (linking the GMMPS programs in `src/`) is waiting on a decision about
the cfitsio version; see "Still open".

## Starting point: the rollback

- On Oct 6, 2026, `add_mike` was reset to `d27ec68` (Sep 14, "one more
  detail in blt.h from Mike's updates"), before the skycat folder was
  replaced with the GitHub version.
- The four commits after it (`d030d47`, `eff2c11`, `0c3b6b7`, `dbb3b2c`) are
  kept on the local branch `add_mike-newskycat`.
- `origin/add_mike` still contains `d030d47`. Nothing has been pushed since
  the rollback; pushing `add_mike` will need `git push --force-with-lease`.

## Commits since the rollback

| Commit | Date | Summary |
| --- | --- | --- |
| `8b87d21` | Oct 7 | New `install.sh` (based on `install.withCoPilot.sh`) and the first skycat C++11 source fixes |
| `918e574` | Oct 7 | Stop tracking 353 build-output files; add `.gitignore` rules |
| `348e1ac` | Oct 8 | `scripts/cc_accepts_flag.sh`: use only the old-C warning flags the compiler accepts |
| `4d23c39` | Oct 8 | Pass CFLAGS/LDFLAGS to Tcl/Tk and skycat through the environment |
| `892547b` | Oct 8 | `std::isnan` in rtd |

## Build problems and fixes

In the order the builds hit them.

| # | Symptom | Cause | Fix |
| --- | --- | --- | --- |
| 1 | Tcl configure: "C compiler cannot create executables" | Current clang rejects pre-C99 code (`main(){...}` without `int`) | `OLDC_CFLAGS`: `-std=gnu89 -Wno-implicit-int -Wno-implicit-function-declaration` for the Tcl/Tk family and wcstools |
| 2 | astrotcl/rtd: `./libwcs/version: unknown type name 'wcstools'` | Plain-text `VERSION` files in `-I` folders; macOS's case-insensitive file system makes libc++'s `<version>` header resolve to them | Renamed `tclutil/VERSION`, `astrotcl/libwcs/VERSION`, `astrotcl/cfitsio/VERSION` to `VERSION.txt` |
| 3 | GMMPS link: `libcfitsio.a ... missing arch 'arm64'` | A stale Intel-only `cfitsio/libcfitsio.a` (old 3.41 build) was checked and copied over the new one | `install.sh` deletes it, checks libtool's `.libs/libcfitsio.a`, no longer copies it, and verifies the installed library with `lipo -archs` |
| 4 | Itcl: `incompatible function pointer types` | Clang 16+ makes `char *` vs `const char *` callback mismatches an error | `-Wno-error=incompatible-function-pointer-types`; later fixed at the source by restoring Mike's casts (see below) |
| 5 | skycat: `invalid argument '-std=gnu89' not allowed with 'C++'` | skycat's Makefiles compile `.C` files with `CFLAGS` | Split flags: `OLDC_WFLAGS` (warnings only, C and C++) for skycat, `OLDC_CFLAGS` (adds `-std=gnu89`) for pure C |
| 6 | tclutil `util.C`: `invalid operands ... '__bind<...>'` | `using namespace std;` makes `bind()` resolve to C++11 `std::bind` | `::bind` in `tclutil/generic/util.C` and `rtd/generic/RtdRemote.C` |
| 7 | rtd `BiasData.C`: cannot return `char` as `char *` | C++11 no longer treats `'\0'` as a null pointer | `return NULL;` |
| 8 | rtd `RtdPerf.C`: no matching `Tcl_SetVar2` | Same rule, `'\0'` passed as a string | `""` in the 11 `Tcl_SetVar2` calls |
| 9 | rtd `rtdCLNT.C`: comparison between pointer and integer | `ReqName() == '\0'` compared the pointer, so the check never ran | `*ReqName() == '\0'` (test for an empty name, as `Attached()` does) |
| 10 | CentOS 7: "C compiler cannot create executables" again | GCC 4.8 rejects the clang-only `-Wno-error=incompatible-function-pointer-types` | `scripts/cc_accepts_flag.sh` tests each candidate flag with `$CC -Werror`; `install.sh` keeps only the accepted ones and prints them as `OLDC_WFLAGS` |
| 11 | Linux, TclX: `relocation R_X86_64_32 ... recompile with -fPIC` | `make CFLAGS=...` on the command line overrode the `-fPIC` that configure adds | CFLAGS/LDFLAGS passed through the environment; skycat's `make install` no longer overrides them |
| 12 | CentOS 7, rtd: `call of overloaded 'isnan(double&)' is ambiguous` | Older glibc also declares a global `isnan(double)` | `std::isnan` in `DoubleImageData.C` and `FloatImageData.C` |

Other `install.sh` changes in `8b87d21`:

- Stops at the first failure (`set -e`).
- wcstools keeps its `-D_FILE_OFFSET_BITS=64`; `src/` is built with a plain
  `make` so its own `+=` flags (`-std=c99`, `-I../include`, `-lcfitsio`)
  are kept.
- The final `rm -rf` of `tcltk-8.4.1`, `skycat-3.1.4` and `cfitsio` is
  commented out while the build is being reworked.
- Color codes and the check/cross/warning symbols were removed from its
  output.

## Working-tree restorations (no commit needed)

The first `install.sh` run after the rollback still extracted
`tarfiles/tcltk-8.4.1-1.tar.gz`, which overwrote Mike's committed fixes with
the original 2006 sources. These were restored with `git restore`:

- 81 files under `tcltk-8.4.1/` (Itcl, TclX, Tcl, Tk, BLT and tkimg sources
  and configure scripts), e.g. Mike's casts in
  `itcl3.3/itcl/generic/itcl_class.c` and the removal of `-arch ppc`.
- `include/blt.h`.

The current `install.sh` does not extract tarballs.

## Repository housekeeping (`918e574`)

- Untracked 353 files that configure or make regenerate: `config.status`,
  `config.log`, `.Plo` files, Makefiles and other files written from `.in`
  templates, compiled programs, and generated sources.
- `.gitignore` ignores them by pattern where the name is unambiguous, and by
  exact path where hand-written files share the name (e.g. `src/Makefile`).
- Header (`.h`) files are deliberately left tracked and never ignored.

## Test results

| Platform | Compiler | zlib dev files | Tcl/Tk and skycat | cfitsio 4.6.3 and GMMPS link |
| --- | --- | --- | --- | --- |
| macOS 14 (arm64) | Apple clang | System | Build | Link needs `-lz -lcurl` |
| Rocky Linux 9.2 | GCC 11.3.1 | Installed | Build | Link needs `-lz` |
| Rocky Linux 8.8 | GCC 8.5.0 | Installed | Build | Link needs `-lz` |
| Ubuntu 22.04.2 | GCC 11.4.0 | Missing | Build | cfitsio configure stops (no zlib) |
| CentOS 7 | GCC 4.8.5 | Missing | Build | cfitsio configure stops (no zlib) |

cfitsio 4.6.3 turns curl support on when it finds `curl-config` (the Mac)
and off when it doesn't (all four Linux VMs).

## Still open

- **cfitsio version.** Go back to 3.41 (zlib built in) or keep 4.6.3 with a
  bundled zlib and `--disable-curl`. The comparison is in the team doc
  "cfitsio for GMMPS: 3.41 vs 4.6.3". The `src/` link is fixed once this is
  decided.
- **Uncommitted headers.** The 4.6.3 versions of `fitsio.h`, `fitsio2.h`,
  `longnam.h` (in `include/` and `cfitsio/include/`) and `jconfig.h` wait on
  that decision.
- **GCC 14/15** (Fedora 40+, Ubuntu 24.04+) not tested yet.
- **tkimg's libtiff configure** still prints "Cannot locate a working ANSI C
  compiler". It does no harm: tkimg builds libtiff through `libtiff/tcl/`.
- **New tarballs.** `tarfiles/tcltk-8.4.1-1.tar.gz` no longer matches the
  checked-in `tcltk-8.4.1/`; build the new tarballs from the repository.
- **Re-enable** the final `rm -rf` lines in `install.sh` once the new
  tarballs are in place.
