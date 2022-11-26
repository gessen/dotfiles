set(CMAKE_SYSTEM_NAME Linux)

set(CMAKE_FIND_ROOT_PATH
  $ENV{TOOLCHAIN_SYSROOT_TARGET}
  $ENV{TOOLCHAIN_SYSROOT_NATIVE}
)
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM BOTH)
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)

set(CMAKE_ADDR2LINE /usr/bin/llvm-addr2line)
set(CMAKE_AR /usr/bin/llvm-ar)
set(CMAKE_DLLTOOL /usr/bin/llvm-dlltool)
set(CMAKE_LINKER /usr/bin/ld.lld)
set(CMAKE_OBJCOPY /usr/bin/llvm-objcopy)
set(CMAKE_OBJDUMP /usr/bin/llvm-objdump)
set(CMAKE_NM /usr/bin/llvm-nm)
set(CMAKE_RANLIB /usr/bin/llvm-ranlib)
set(CMAKE_READELF /usr/bin/llvm-readelf)
set(CMAKE_STRIP /usr/bin/llvm-strip)
