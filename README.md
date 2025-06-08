# nastx

`nastx` is a simple library for the pretty printing the x87 floating point
processing unit state. It's designed for IA-32 architecture, and is not x86-64
compatible.

### Install

```
# Get the source:
git clone https://github.com/fedoseevtaf/nastx.git
cd nastx
# Make the library:
make -Csrc build
```

```
# Install the library (use sudo or another preferred tool):
make -Csrc install PREFIX=/usr
```

#### Uninstall / What will be installed

`install` target installs the:
- `$PREFIX/lib/libnastx.a`
- `$PREFIX/include/nastx.inc`
- `$PREFIX/include/nastx.h`

You can use `uninstall` target to remove them:
```
# Remove the library (use sudo or another preferred tool):
make -Csrc uninstall PREFIX=/usr
```

### Usage

You can force the linker to add a library for future debugging:
```
gcc -m32 -o main my_program.o \
	-Wl,--whole-archive -lnastx -Wl,--no-whole-archive
```


