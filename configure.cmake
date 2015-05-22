include(CheckCSourceCompiles)
include(CheckFunctionExists)
include(CheckIncludeFile)
include(CheckLibraryExists)
include(CheckSymbolExists)
include(CheckTypeSize)
include(CMakePushCheckState)
include(TestBigEndian)
########################################
function(set_define var)
  if(${ARGC} GREATER 1 AND ${var})
    set(DEFINE_${var} cmakedefine01 PARENT_SCOPE)
  else()
    set(DEFINE_${var} cmakedefine PARENT_SCOPE)
  endif()
  if(${var})
    set(LIBSSH2_TEST_DEFINES "${LIBSSH2_TEST_DEFINES} -D${var}" PARENT_SCOPE)
    set(CMAKE_REQUIRED_DEFINITIONS ${LIBSSH2_TEST_DEFINES} PARENT_SCOPE)
  endif(${var})
endfunction()
##########
macro(check_include_file_concat incfile var)
  check_include_file("${incfile}" ${var})
  set_define(${var} 1)
  if(${var})
    set(LIBSSH2_INCLUDES ${LIBSSH2_INCLUDES} ${incfile})
  endif(${var})
endmacro()
##########
macro(check_exists_define01 func var)
  if(UNIX)
    check_function_exists("${func}" ${var})
  else()
    check_symbol_exists("${func}" "${LIBSSH2_INCLUDES}" ${var})
  endif()
  set_define(${var} 1)
endmacro()
##########
macro(check_library_exists_define lib symbol var)
  check_library_exists("${lib};${LIBSSH2_LIBS}" ${symbol} "${CMAKE_LIBRARY_PATH}" ${var})
  set_define(${var} 1)
endmacro()
##########
macro(check_library_exists_concat lib var)
  if(${var})
    set(LIBSSH2_LIBS ${lib} ${LIBSSH2_LIBS})
    set(CMAKE_REQUIRED_LIBRARIES ${LIBSSH2_LIBS})
  endif(${var})
endmacro()
########################################
check_include_file_concat(windows.h HAVE_WINDOWS_H)
if(HAVE_WINDOWS_H)
  set(WIN32_LEAN_AND_MEAN TRUE)
endif()
set_define(WIN32_LEAN_AND_MEAN)
check_include_file_concat(alloca.h HAVE_ALLOCA_H)
check_include_file_concat(arpa/inet.h HAVE_ARPA_INET_H)
check_include_file_concat(dlfcn.h HAVE_DLFCN_H)
check_include_file_concat(errno.h HAVE_ERRNO_H)
check_include_file_concat(fcntl.h HAVE_FCNTL_H)
check_include_file_concat(inttypes.h HAVE_INTTYPES_H)
check_include_file_concat(memory.h HAVE_MEMORY_H)
check_include_file_concat(netinet/in.h HAVE_NETINET_IN_H)
check_include_file_concat(ntdef.h HAVE_NTDEF_H)
check_include_file_concat(ntstatus.h HAVE_NTSTATUS_H)
check_include_file_concat(stdint.h HAVE_STDINT_H)
check_include_file_concat(stdio.h HAVE_STDIO_H)
check_include_file_concat(stdlib.h HAVE_STDLIB_H)
check_include_file_concat(strings.h HAVE_STRINGS_H)
check_include_file_concat(string.h HAVE_STRING_H)
check_include_file_concat(sys/ioctl.h HAVE_SYS_IOCTL_H)
check_include_file_concat(sys/select.h HAVE_SYS_SELECT_H)
check_include_file_concat(sys/socket.h HAVE_SYS_SOCKET_H)
check_include_file_concat(sys/stat.h HAVE_SYS_STAT_H)
check_include_file_concat(sys/time.h HAVE_SYS_TIME_H)
check_include_file_concat(sys/types.h HAVE_SYS_TYPES_H)
check_include_file_concat(sys/uio.h HAVE_SYS_UIO_H)
check_include_file_concat(sys/un.h HAVE_SYS_UN_H)
check_include_file_concat(unistd.h HAVE_UNISTD_H)
check_include_file_concat(winsock2.h HAVE_WINSOCK2_H)
check_include_file_concat(ws2tcpip.h HAVE_WS2TCPIP_H)
########################################
check_library_exists_define(ws2_32 getch HAVE_LIBWS2_32)
check_library_exists_concat(ws2_32 HAVE_LIBWS2_32)
##########
if(NOT CRYPTO_BACKEND)
  set(CRYPTO_BACKEND NOTFOUND CACHE STRING
    "The backend to use for cryptography: OpenSSL, Libgcrypt, WinCNG, or NOTFOUND to try any available"
    )
else()
  set(CRYPTO_BACKEND ${CRYPTO_BACKEND} CACHE STRING
    "The backend to use for cryptography: OpenSSL, Libgcrypt, WinCNG, or NOTFOUND to try any available"
    )
  set(SPECIFIC_CRYPTO_REQ REQUIRED)
endif()
##########
if(NOT CRYPTO_BACKEND OR CRYPTO_BACKEND STREQUAL OpenSSL)
  option(FIND_OPENSSL_MODULE_PATH "Find OpenSSL in CMAKE_MODULE_PATH." OFF)
  mark_as_advanced(FIND_OPENSSL_MODULE_PATH)
  if(FIND_OPENSSL_MODULE_PATH)
    find_package(usexp-OpenSSL ${SPECIFIC_CRYPTO_REQ} PATHS ${CMAKE_MODULE_PATH} NO_DEFAULT_PATH)
  else()
    find_package(OpenSSL ${SPECIFIC_CRYPTO_REQ})
  endif()
  if(OPENSSL_FOUND)
    set(CRYPTO_BACKEND OpenSSL)
    include_directories(${OPENSSL_INCLUDE_DIR})
    list(APPEND LIBSSH2_LIBS ${OPENSSL_LIBRARIES})
    set(HAVE_LIBSSL ON)
    set(LIBSSH2_OPENSSL ON)
    cmake_push_check_state()
      set(CMAKE_EXTRA_INCLUDE_FILES "${OPENSSL_INCLUDE_DIR}/openssl/evp.h")
      set(CMAKE_REQUIRED_LIBRARIES ${OPENSSL_LIBRARIES})
      check_function_exists(EVP_aes_128_ctr HAVE_EVP_AES_128_CTR)
    cmake_pop_check_state()
  endif()
endif()
set_define(HAVE_LIBSSL 1)
set_define(LIBSSH2_OPENSSL 1)
set_define(HAVE_EVP_AES_128_CTR 1)
##########
check_library_exists_define(gcrypt gcry_sexp_build HAVE_LIBGCRYPT)
if(NOT CRYPTO_BACKEND OR CRYPTO_BACKEND STREQUAL Libgcrypt)
  if(HAVE_LIBGCRYPT)
    check_library_exists_concat(gcrypt HAVE_LIBGCRYPT)
    set(CRYPTO_BACKEND Libgrypt)
    set(LIBSSH2_LIBGCRYPT ON)
  elseif(${SPECIFIC_CRYPTO_REQ} STREQUAL "REQUIRED")
    message(FATAL_ERROR "Required Libgcrypt not found")
  endif()
endif()
set_define(LIBSSH2_LIBGCRYPT 1)
##########
check_library_exists_define(bcrypt BCryptEncrypt HAVE_LIBBCRYPT)
check_library_exists_define(crypt32 CryptMemAlloc HAVE_LIBCRYPT32)
if(NOT CRYPTO_BACKEND OR CRYPTO_BACKEND STREQUAL WinCNG)
  if(HAVE_LIBBCRYPT)
    check_library_exists_concat(bcrypt HAVE_LIBBCRYPT)
    # reading keys from files is optional and depends on wincrypt
    check_library_exists_concat(crypt32 HAVE_LIBCRYPT32)
    set(CRYPTO_BACKEND WinCNG)
    set(LIBSSH2_WINCNG ON)
  elseif(${SPECIFIC_CRYPTO_REQ} STREQUAL "REQUIRED")
    message(FATAL_ERROR "Required WinCNG not available")
  endif()
endif()
set_define(LIBSSH2_WINCNG 1)
##########
if(NOT CRYPTO_BACKEND)
  message(FATAL_ERROR "No suitable cryptography backend available")
endif()
########################################
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
# Compile in zlib support
set(LIBSSH2_HAVE_ZLIB ${HAVE_LIBZ})
set_define(LIBSSH2_HAVE_ZLIB 1)
########################################
check_symbol_exists(alloca "${LIBSSH2_INCLUDES}" HAVE_ALLOCA)
set_define(HAVE_ALLOCA 1)
##########
check_exists_define01(gettimeofday HAVE_GETTIMEOFDAY)
check_exists_define01(poll HAVE_POLL)
check_exists_define01(select HAVE_SELECT)
check_exists_define01(strtoll HAVE_STRTOLL)
########################################
set(CMAKE_EXTRA_INCLUDE_FILES ${LIBSSH2_INCLUDES})
##########
# Define to 1 if the compiler supports the 'long long' data type.
check_type_size("long long" SIZEOF_LONG_LONG)
if(HAVE_SIZEOF_LONG_LONG)
  set(HAVE_LONGLONG 1)
else()
  set(HAVE_LONGLONG)
endif()
set_define(HAVE_LONGLONG 1)
##########
# Define to `unsigned int' if <sys/types.h> does not define.
check_type_size(size_t SIZEOF_SIZE_T)
if(NOT HAVE_SIZEOF_SIZE_T)
  set(size_t "unsigned int")
endif()
##########
# Define WORDS_BIGENDIAN to 1 if your processor stores words with the most
# significant byte first (like Motorola and SPARC, unlike Intel). */
test_big_endian(WORDS_BIGENDIAN)
set_define(WORDS_BIGENDIAN 1)
##########
set(CMAKE_EXTRA_INCLUDE_FILES)
########################################
# Define to the sub-directory in which libtool stores uninstalled libraries.
execute_process(COMMAND libtool --version
  OUTPUT_QUIET ERROR_QUIET RESULT_VARIABLE hasLibtool
  )
if(hasLibtool EQUAL 0) # 0 == success
  set(LT_OBJDIR .libs/)
endif()
########################################
# Define if building universal (internal helper macro)
set(AC_APPLE_UNIVERSAL_BUILD)
set_define(AC_APPLE_UNIVERSAL_BUILD)
########################################
# Define to one of `_getb67', `GETB67', `getb67' for Cray-2 and Cray-YMP
#  systems. This function is required for `alloca.c' support on those systems.
set(CRAY_STACKSEG_END)
set_define(CRAY_STACKSEG_END)
########################################
# Define to 1 if using `alloca.c'.
set(C_ALLOCA) # TODO: determine - not seeing where it's used in code, though
set_define(C_ALLOCA 1)
########################################
# to make a symbol visible
set(LIBSSH2_API)
set_define(LIBSSH2_API)
########################################
# Enable "none" cipher -- NOT RECOMMENDED
set(LIBSSH2_CRYPT_NONE)
set_define(LIBSSH2_CRYPT_NONE)
########################################
# Enable newer diffie-hellman-group-exchange-sha1 syntax
set(LIBSSH2_DH_GEX_NEW TRUE)
set_define(LIBSSH2_DH_GEX_NEW 1)
########################################
# Enable "none" MAC -- NOT RECOMMENDED
set(LIBSSH2_MAC_NONE)
set_define(LIBSSH2_MAC_NONE)
########################################
# Define to 1 if _REENTRANT preprocessor symbol must be defined.
if(${CMAKE_SYSTEM_NAME} STREQUAL SunOS)
  set(NEED_REENTRANT ON)
else()
  set(NEED_REENTRANT) # TODO
endif()
set_define(NEED_REENTRANT 1)
########################################
# If using the C implementation of alloca, define if you know the
#  direction of stack growth for your system; otherwise it will be
#  automatically deduced at runtime.
#    STACK_DIRECTION > 0 => grows toward higher addresses
#    STACK_DIRECTION < 0 => grows toward lower addresses
#    STACK_DIRECTION = 0 => direction of growth unknown */
set(STACK_DIRECTION)
set_define(STACK_DIRECTION)
########################################
# Define to 1 if you have the ANSI C header files.
set(STDC_HEADERS TRUE) # TODO: determine if true
set_define(STDC_HEADERS 1)
########################################
# Number of bits in a file offset, on hosts where this is settable.
set(offsetCode "
#include <sys/types.h>
 /* Check that off_t can represent 2**63 - 1 correctly.
    We can't simply define LARGE_OFF_T to be 9223372036854775807,
    since some C++ compilers compilers masquerading as C compilers
    incorrectly reject 9223372036854775807.  */
#define LARGE_OFF_T ((((off_t) 1 << 31) << 31) - 1 + (((off_t) 1 << 31) << 31))
  int off_t_is_large[(LARGE_OFF_T % 2147483629 == 721
                       && LARGE_OFF_T % 2147483647 == 1)
                      ? 1 : -1];
int main()
{
  ;
  return 0;
}
" )
set(_FILE_OFFSET_BITS) # nothing, by default
check_c_source_compiles("${offsetCode}" OFFSET_NONE_COMPILES)
if(NOT OFFSET_NONE_COMPILES)
  check_c_source_compiles("#define _FILE_OFFSET_BITS 64\n${offsetCode}" OFFSET_64_COMPILES)
  if(OFFSET_64_COMPILES)
    set(_FILE_OFFSET_BITS 64)
  endif()
endif()
########################################
# Define for large files, on AIX-style hosts.
if(${CMAKE_SYSTEM_NAME} STREQUAL AIX)
  set(_LARGE_FILES TRUE) # TODO: determine as configure does
endif()
set_define(_LARGE_FILES 1)
########################################
# Define to empty if `const' does not conform to ANSI C.
set(const) # TODO
set_define(const)
########################################
# Define to `__inline__' or `__inline' if that's what the C compiler
# calls it, or to nothing if 'inline' is not supported under any name.  */
set(inline) # TODO
set_define(inline)
###############################################################################
# disabled non-blocking sockets
set(HAVE_DISABLED_NONBLOCKING)
set_define(HAVE_DISABLED_NONBLOCKING 1)
########################################
# CHECK_NONBLOCKING_SOCKET
# Check for how to set a socket to non-blocking state. There seems to exist
# four known different ways, with the one used almost everywhere being POSIX
# and XPG3, while the other different ways for different systems (old BSD,
# Windows and Amiga).
# There are two known platforms (AIX 3.x and SunOS 4.1.x) where the
# O_NONBLOCK define is found but does not work. This condition is attempted
# to get caught in this script by using an excessive number of #ifdefs...
########################################
# use O_NONBLOCK for non-blocking sockets
set(HAVE_O_NONBLOCK)
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
# use FIONBIO for non-blocking sockets
set(HAVE_FIONBIO) # test below
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
# use ioctlsocket() for non-blocking sockets
set(HAVE_IOCTLSOCKET) # test below
# HAVE_IOCTLSOCKET (Windows)
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
# use Ioctlsocket() for non-blocking sockets
set(HAVE_IOCTLSOCKET_CASE) # test below
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
# use SO_NONBLOCK for non-blocking sockets
set(HAVE_SO_NONBLOCK) # test below
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
########################################
# Name of package
set(PACKAGE "libssh2")
# Version number of package
file(STRINGS include/libssh2.h verStr REGEX "^#define[\t ]+LIBSSH2_VERSION[\t ]+\".*\".*")
string(REGEX REPLACE "^#define[\t ]+LIBSSH2_VERSION[\t ]+\"([^\"]+)\".*" "\\1" VERSION "${verStr}")
# Define to the address where bug reports for this package should be sent.
set(PACKAGE_BUGREPORT "libssh2-devel@cool.haxx.se")
# Define to the full name of this package.
set(PACKAGE_NAME ${PACKAGE})
# Define to the version of this package.
set(PACKAGE_VERSION ${VERSION})
# Define to the full name and version of this package.
set(PACKAGE_STRING "${PACKAGE} ${PACKAGE_VERSION}")
# Define to the one symbol short name of this package.
set(PACKAGE_TARNAME ${PACKAGE})
# Define to the home page for this package.
set(PACKAGE_URL)
###############################################################################
configure_file(${CMAKE_SOURCE_DIR}/src/libssh2_config.in ${CMAKE_BINARY_DIR}/libssh2_config.in)
configure_file(${CMAKE_BINARY_DIR}/libssh2_config.in ${CMAKE_BINARY_DIR}/libssh2_config.h)
set(CMAKE_REQUIRED_LIBRARIES)
set(CMAKE_REQUIRED_DEFINITIONS)
include_directories(${CMAKE_BINARY_DIR})
