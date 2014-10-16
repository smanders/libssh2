include(CheckCSourceCompiles)
include(CheckFunctionExists)
include(CheckIncludeFile)
include(CheckSymbolExists)
include(CheckTypeSize)
function(set_define var)
  if(${ARGC} GREATER 1 AND ${var})
    set(DEFINE_${var} cmakedefine01 PARENT_SCOPE)
  else()
    set(DEFINE_${var} cmakedefine PARENT_SCOPE)
  endif()
endfunction()
# Define if building universal (internal helper macro)
set(AC_APPLE_UNIVERSAL_BUILD)
set_define(AC_APPLE_UNIVERSAL_BUILD)
# Define to one of `_getb67', `GETB67', `getb67' for Cray-2 and Cray-YMP
#  systems. This function is required for `alloca.c' support on those systems.
set(CRAY_STACKSEG_END)
set_define(CRAY_STACKSEG_END)
# Define to 1 if using `alloca.c'.
set(C_ALLOCA) # TODO: determine - not seeing where it's used in code, though
set_define(C_ALLOCA 1)
# Define to 1 if you have `alloca', as a function or macro.
check_symbol_exists(alloca alloca.h HAVE_ALLOCA)
set_define(HAVE_ALLOCA 1)
# Define to 1 if you have <alloca.h> and it should be used (not on Ultrix).
check_include_file(alloca.h HAVE_ALLOCA_H)
set_define(HAVE_ALLOCA_H 1)
# Define to 1 if you have the <arpa/inet.h> header file.
check_include_file(arpa/inet.h HAVE_ARPA_INET_H)
set_define(HAVE_ARPA_INET_H 1)
# disabled non-blocking sockets
set(HAVE_DISABLED_NONBLOCKING) # define below
# Define to 1 if you have the <dlfcn.h> header file.
check_include_file(dlfcn.h HAVE_DLFCN_H)
set_define(HAVE_DLFCN_H 1)
# Define to 1 if you have the <errno.h> header file.
check_include_file(errno.h HAVE_ERRNO_H)
set_define(HAVE_ERRNO_H 1)
# Define to 1 if you have the `EVP_aes_128_ctr' function.
check_function_exists(EVP_aes_128_ctr HAVE_EVP_AES_128_CTR)
set_define(HAVE_EVP_AES_128_CTR 1)
# Define to 1 if you have the <fcntl.h> header file.
check_include_file(fcntl.h HAVE_FCNTL_H)
set_define(HAVE_FCNTL_H 1)
# use FIONBIO for non-blocking sockets
set(HAVE_FIONBIO) # test below
# Define to 1 if you have the `gettimeofday' function.
check_function_exists(gettimeofday HAVE_GETTIMEOFDAY)
set_define(HAVE_GETTIMEOFDAY 1)
# Define to 1 if you have the <inttypes.h> header file.
check_include_file(inttypes.h HAVE_INTTYPES_H)
set_define(HAVE_INTTYPES_H 1)
# use ioctlsocket() for non-blocking sockets
set(HAVE_IOCTLSOCKET) # test below
# use Ioctlsocket() for non-blocking sockets
set(HAVE_IOCTLSOCKET_CASE) # test below
# Define if you have the gcrypt library.
set(HAVE_LIBGCRYPT) # TODO: determine
set_define(HAVE_LIBGCRYPT)
# OpenSSL cmake options.
option(CMAKE_USE_OPENSSL "Use OpenSSL code." ON)
mark_as_advanced(CMAKE_USE_OPENSSL)
option(CMAKE_USE_OPENSSL_MODULE_PATH "Find OpenSSL in CMAKE_MODULE_PATH." OFF)
mark_as_advanced(CMAKE_USE_OPENSSL_MODULE_PATH)
# Define if you have the ssl library.
if(CMAKE_USE_OPENSSL)
  if(CMAKE_USE_OPENSSL_MODULE_PATH)
    find_package(usexp-OpenSSL PATHS ${CMAKE_MODULE_PATH} NO_DEFAULT_PATH)
  else()
    find_package(OpenSSL)
  endif()
  if(OPENSSL_FOUND)
    set(HAVE_LIBSSL ON)
    include_directories(${OPENSSL_INCLUDE_DIR})
    list(APPEND LIBSSH2_LIBS ${OPENSSL_LIBRARIES})
  else()
    message(FATAL_ERROR "OpenSSL not found.")
  endif()
else()
  set(HAVE_LIBSSL OFF)
endif()
set_define(HAVE_LIBSSL 1)
# zlib cmake options.
option(CMAKE_USE_ZLIB "Use zlib code." ON)
mark_as_advanced(CMAKE_USE_ZLIB)
option(CMAKE_USE_ZLIB_MODULE_PATH "Find zlib in CMAKE_MODULE_PATH." OFF)
mark_as_advanced(CMAKE_USE_ZLIB_MODULE_PATH)
# Define if you have the z library.
if(CMAKE_USE_ZLIB)
  if(CMAKE_USE_ZLIB_MODULE_PATH)
    find_package(usexp-ZLIB PATHS ${CMAKE_MODULE_PATH} NO_DEFAULT_PATH)
  else()
    find_package(ZLIB)
  endif()
  if(ZLIB_FOUND)
    set(HAVE_LIBZ ON)
    include_directories(${ZLIB_INCLUDE_DIRS})
    list(APPEND LIBSSH2_LIBS ${ZLIB_LIBRARIES})
  else()
    message(FATAL_ERROR "zlib not found.")
  endif()
else()
  set(HAVE_LIBZ OFF)
endif()
set_define(HAVE_LIBZ 1)
# Define to 1 if the compiler supports the 'long long' data type.
check_type_size("long long" SIZEOF_LONG_LONG)
if(HAVE_SIZEOF_LONG_LONG)
  set(HAVE_LONGLONG 1)
else()
  set(HAVE_LONGLONG)
endif()
set_define(HAVE_LONGLONG 1)
# Define to 1 if you have the <memory.h> header file.
check_include_file(memory.h HAVE_MEMORY_H)
set_define(HAVE_MEMORY_H 1)
# Define to 1 if you have the <netinet/in.h> header file.
check_include_file(netinet/in.h HAVE_NETINET_IN_H)
set_define(HAVE_NETINET_IN_H 1)
# use O_NONBLOCK for non-blocking sockets
set(HAVE_O_NONBLOCK) # test below
# Define to 1 if you have the `poll' function.
check_function_exists(poll HAVE_POLL)
set_define(HAVE_POLL 1)
# Define to 1 if you have the select function.
check_function_exists(select HAVE_SELECT)
set_define(HAVE_SELECT 1)
# use SO_NONBLOCK for non-blocking sockets
set(HAVE_SO_NONBLOCK) # test below
# Define to 1 if you have the <stdint.h> header file.
check_include_file(stdint.h HAVE_STDINT_H)
set_define(HAVE_STDINT_H 1)
# Define to 1 if you have the <stdio.h> header file.
check_include_file(stdio.h HAVE_STDIO_H)
set_define(HAVE_STDIO_H 1)
# Define to 1 if you have the <stdlib.h> header file.
check_include_file(stdlib.h HAVE_STDLIB_H)
set_define(HAVE_STDLIB_H 1)
# Define to 1 if you have the <strings.h> header file.
check_include_file(strings.h HAVE_STRINGS_H)
set_define(HAVE_STRINGS_H 1)
# Define to 1 if you have the <string.h> header file.
check_include_file(string.h HAVE_STRING_H)
set_define(HAVE_STRING_H 1)
# Define to 1 if you have the `strtoll' function.
check_function_exists(strtoll HAVE_STRTOLL)
set_define(HAVE_STRTOLL 1)
# Define to 1 if you have the <sys/ioctl.h> header file.
check_include_file(sys/ioctl.h HAVE_SYS_IOCTL_H)
set_define(HAVE_SYS_IOCTL_H 1)
# Define to 1 if you have the <sys/select.h> header file.
check_include_file(sys/select.h HAVE_SYS_SELECT_H)
set_define(HAVE_SYS_SELECT_H 1)
# Define to 1 if you have the <sys/socket.h> header file.
check_include_file(sys/socket.h HAVE_SYS_SOCKET_H)
set_define(HAVE_SYS_SOCKET_H 1)
# Define to 1 if you have the <sys/stat.h> header file.
check_include_file(sys/stat.h HAVE_SYS_STAT_H)
set_define(HAVE_SYS_STAT_H 1)
# Define to 1 if you have the <sys/time.h> header file.
check_include_file(sys/time.h HAVE_SYS_TIME_H)
set_define(HAVE_SYS_TIME_H 1)
# Define to 1 if you have the <sys/types.h> header file.
check_include_file(sys/types.h HAVE_SYS_TYPES_H)
set_define(HAVE_SYS_TYPES_H 1)
# Define to 1 if you have the <sys/uio.h> header file.
check_include_file(sys/uio.h HAVE_SYS_UIO_H)
set_define(HAVE_SYS_UIO_H 1)
# Define to 1 if you have the <sys/un.h> header file.
check_include_file(sys/un.h HAVE_SYS_UN_H)
set_define(HAVE_SYS_UN_H 1)
# Define to 1 if you have the <unistd.h> header file.
check_include_file(unistd.h HAVE_UNISTD_H)
set_define(HAVE_UNISTD_H 1)
# Define to 1 if you have the <windows.h> header file.
check_include_file(windows.h HAVE_WINDOWS_H)
set_define(HAVE_WINDOWS_H 1)
# Define to 1 if you have the <winsock2.h> header file.
check_include_file(winsock2.h HAVE_WINSOCK2_H)
set_define(HAVE_WINSOCK2_H 1)
# Define to 1 if you have the <ws2tcpip.h> header file.
check_include_file(ws2tcpip.h HAVE_WS2TCPIP_H)
set_define(HAVE_WS2TCPIP_H 1)
# to make a symbol visible
set(LIBSSH2_API)
set_define(LIBSSH2_API)
# Enable "none" cipher -- NOT RECOMMENDED
set(LIBSSH2_CRYPT_NONE)
set_define(LIBSSH2_CRYPT_NONE)
# Enable newer diffie-hellman-group-exchange-sha1 syntax
set(LIBSSH2_DH_GEX_NEW true)
set_define(LIBSSH2_DH_GEX_NEW 1)
# Compile in zlib support
set(LIBSSH2_HAVE_ZLIB HAVE_LIBZ)
set_define(LIBSSH2_HAVE_ZLIB 1)
# Use libgcrypt
set(LIBSSH2_LIBGCRYPT)
set_define(LIBSSH2_LIBGCRYPT)
# Enable "none" MAC -- NOT RECOMMENDED
set(LIBSSH2_MAC_NONE)
set_define(LIBSSH2_MAC_NONE)
# Define to the sub-directory in which libtool stores uninstalled libraries.
set(LT_OBJDIR)
set_define(LT_OBJDIR)
# Define to 1 if _REENTRANT preprocessor symbol must be defined.
set(NEED_REENTRANT)
set_define(NEED_REENTRANT)
# Name of package
set(PACKAGE \"libssh2\")
set_define(PACKAGE)
# Define to the address where bug reports for this package should be sent.
set(PACKAGE_BUGREPORT \"libssh2-devel@cool.haxx.se\")
set_define(PACKAGE_BUGREPORT)
# Define to the full name of this package.
set(PACKAGE_NAME \"libssh2\")
set_define(PACKAGE_NAME)
# Define to the full name and version of this package.
set(PACKAGE_STRING \"libssh2-\")
set_define(PACKAGE_STRING)
# Define to the one symbol short name of this package.
set(PACKAGE_TARNAME \"libssh2\")
set_define(PACKAGE_TARNAME)
# Define to the home page for this package.
set(PACKAGE_URL \"\")
set_define(PACKAGE_URL)
# Define to the version of this package.
set(PACKAGE_VERSION \"-\")
set_define(PACKAGE_VERSION)
# If using the C implementation of alloca, define if you know the
#  direction of stack growth for your system; otherwise it will be
#  automatically deduced at runtime.
#    STACK_DIRECTION > 0 => grows toward higher addresses
#    STACK_DIRECTION < 0 => grows toward lower addresses
#    STACK_DIRECTION = 0 => direction of growth unknown */
set(STACK_DIRECTION)
set_define(STACK_DIRECTION)
# Define to 1 if you have the ANSI C header files.
set(STDC_HEADERS true)
set_define(STDC_HEADERS 1)
# Version number of package
set(VERSION \"-\")
set_define(VERSION)
# Define WORDS_BIGENDIAN to 1 if your processor stores words with the most
# significant byte first (like Motorola and SPARC, unlike Intel). */
set(WORDS_BIGENDIAN)
set_define(WORDS_BIGENDIAN 1)
# Number of bits in a file offset, on hosts where this is settable.
set(_FILE_OFFSET_BITS)
set_define(_FILE_OFFSET_BITS)
# Define for large files, on AIX-style hosts.
set(_LARGE_FILES)
set_define(_LARGE_FILES)
# Define to empty if `const' does not conform to ANSI C.
set(const)
set_define(const)
# Define to `__inline__' or `__inline' if that's what the C compiler
# calls it, or to nothing if 'inline' is not supported under any name.  */
set(inline)
set_define(inline)
# Define to `unsigned int' if <sys/types.h> does not define.
set(size_t)
set_define(size_t)
###############################################################################
# CHECK_NONBLOCKING_SOCKET
# Check for how to set a socket to non-blocking state. There seems to exist
# four known different ways, with the one used almost everywhere being POSIX
# and XPG3, while the other different ways for different systems (old BSD,
# Windows and Amiga).
# There are two known platforms (AIX 3.x and SunOS 4.1.x) where the
# O_NONBLOCK define is found but does not work. This condition is attempted
# to get caught in this script by using an excessive number of #ifdefs...
##########
# HAVE_O_NONBLOCK (most recent unix versions)
check_c_source_compiles(" 
#include <sys/types.h>
#include <unistd.h>
#include <fcntl.h>
#if defined(sun) || defined(__sun__) || defined(__SUNPRO_C) || defined(__SUNPRO_CC)
# if defined(__SVR4) || defined(__srv4__)
#  define PLATFORM_SOLARIS
# else
#  define PLATFORM_SUNOS4
# endif
#endif
#if (defined(_AIX) || defined(__xlC__)) && !defined(_AIX41)
# define PLATFORM_AIX_V3
#endif
#if defined(PLATFORM_SUNOS4) || defined(PLATFORM_AIX_V3) || defined(__BEOS__)
#error \"O_NONBLOCK does not work on this platform\"
#endif
int main()
{
  int socket;
  int flags = fcntl(socket, F_SETFL, flags | O_NONBLOCK);
}
" HAVE_O_NONBLOCK
  )
set_define(HAVE_O_NONBLOCK 1)
##########
# HAVE_FIONBIO (old-style unix and vms)
check_c_source_compiles(" 
#include <unistd.h>
#include <stropts.h>
int main()
{
  int socket;
  int flags = ioctl(socket, FIONBIO, &flags);
}
" HAVE_FIONBIO
  )
set_define(HAVE_FIONBIO 1)
##########
# HAVE_IOCTLSOCKET (Windows)
include(CMakePushCheckState)
cmake_push_check_state()
if(HAVE_WINDOWS_H AND HAVE_WINSOCK2_H)
  set(CMAKE_REQUIRED_DEFINITIONS -DHAVE_WINDOWS_H -DHAVE_WINSOCK2_H)
  set(CMAKE_REQUIRED_LIBRARIES Ws2_32)
endif()
check_c_source_compiles(" 
#ifdef HAVE_WINDOWS_H
# ifndef WIN32_LEAN_AND_MEAN
#  define WIN32_LEAN_AND_MEAN
# endif
# include <windows.h>
# ifdef HAVE_WINSOCK2_H
#  include <winsock2.h>
# endif
#endif
int main()
{
  unsigned long flags = ioctlsocket(0, FIONBIO, &flags);
}
" HAVE_IOCTLSOCKET
  )
cmake_pop_check_state()
set_define(HAVE_IOCTLSOCKET 1)
##########
# HAVE_IOCTLSOCKET_CASE (Amiga?)
check_c_source_compiles(" 
#include <sys/ioctl.h>
int main()
{
 int socket;
 int flags = IoctlSocket(socket, FIONBIO, (long)1);
}
" HAVE_IOCTLSOCKET_CASE
  )
set_define(HAVE_IOCTLSOCKET_CASE 1)
##########
# HAVE_SO_NONBLOCK (BeOS)
check_c_source_compiles(" 
#include <socket.h>
int main()
{
  long b = 1;
  int socket;
  int flags = setsockopt(socket, SOL_SOCKET, SO_NONBLOCK, &b, sizeof(b));
}
" HAVE_SO_NONBLOCK
  )
set_define(HAVE_SO_NONBLOCK 1)
##########
# HAVE_DISABLED_NONBLOCKING
set_define(HAVE_DISABLED_NONBLOCKING 1)
###############################################################################
configure_file(${CMAKE_SOURCE_DIR}/src/libssh2_config.in ${CMAKE_BINARY_DIR}/libssh2_config.in)
configure_file(${CMAKE_BINARY_DIR}/libssh2_config.in ${CMAKE_BINARY_DIR}/libssh2_config.h)
include_directories(${CMAKE_BINARY_DIR})
