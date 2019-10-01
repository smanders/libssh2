cmake_minimum_required(VERSION 3.0)
project(libssh2)
set(lib_name ${PROJECT_NAME})
include(flags OPTIONAL)
########################################
set_property(GLOBAL PROPERTY USE_FOLDERS ON) # enables MSVC Solution Folders
include(configure.cmake)
########################################
# library sources
set(cmake
  configure.cmake
  src/libssh2_config.in
  )
source_group(cmake FILES ${cmake})
list(APPEND ${lib_name}_libsrcs ${cmake})
####################
set(libsrcs
  src/agent.c
  src/channel.c
  src/comp.c
  src/crypt.c
  src/global.c
  src/hostkey.c
  src/keepalive.c
  src/kex.c
  src/knownhost.c
  src/libgcrypt.c
  src/mac.c
  src/misc.c
  src/openssl.c
  src/packet.c
  src/pem.c
  src/publickey.c
  src/scp.c
  src/session.c
  src/sftp.c
  src/transport.c
  src/userauth.c
  src/version.c
  src/wincng.c
  )
source_group(src FILES ${libsrcs})
list(APPEND ${lib_name}_libsrcs ${libsrcs})
####################
set(libhdrs
  src/channel.h
  src/comp.h
  src/crypto.h
  src/libgcrypt.h
  src/libssh2_priv.h
  src/mac.h
  src/misc.h
  src/openssl.h
  src/packet.h
  src/session.h
  src/sftp.h
  src/transport.h
  src/userauth.h
  src/wincng.h
  )
source_group(hdrs FILES ${libhdrs})
list(APPEND ${lib_name}_libsrcs ${libhdrs})
####################
set(hdrs
  include/libssh2.h
  include/libssh2_publickey.h
  include/libssh2_sftp.h
  )
source_group(include FILES ${hdrs})
list(APPEND ${lib_name}_libsrcs ${hdrs})
########################################
# version
if(NOT DEFINED LIBSSH2_VER)
  set(LIBSSH2_VER ${VERSION}) # VERSION defined in configure.cmake
elseif(NOT ${LIBSSH2_VER} STREQUAL ${VERSION})
  message(AUTHOR_WARNING "version passed in (${LIBSSH2_VER}) doesn't match version from include/libssh2.h (${VERSION})")
endif()
if(XP_INSTALL_DIRS)
  set(ver _${LIBSSH2_VER})
  set(CMAKE_INSTALL_INCLUDEDIR include/${PROJECT_NAME}${ver}/${PROJECT_NAME})
endif()
include(GNUInstallDirs)
########################################
# library
add_library(${lib_name} STATIC ${${lib_name}_libsrcs})
target_include_directories(${lib_name} PUBLIC $<BUILD_INTERFACE:${PROJECT_SOURCE_DIR}/include>
  $<INSTALL_INTERFACE:$<INSTALL_PREFIX>/${CMAKE_INSTALL_INCLUDEDIR}>   #include <libssh2.h>
  $<INSTALL_INTERFACE:$<INSTALL_PREFIX>/include/${PROJECT_NAME}${ver}> #include <libssh2/libssh2.h>
  )
if(LIBSSH2_LIBS)
  target_link_libraries(${lib_name} PRIVATE ${LIBSSH2_LIBS})
endif()
# strip off the "lib" prefix, since it's already libssh2
set_target_properties(${lib_name} PROPERTIES OUTPUT_NAME ${lib_name}${ver} PREFIX "")
########################################
# install
set(targetsFile Libssh2Config)
install(TARGETS ${lib_name} EXPORT ${targetsFile}
  RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
  ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
  LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
  )
install(EXPORT ${targetsFile} DESTINATION ${CMAKE_INSTALL_LIBDIR}/cmake/${PROJECT_NAME}${ver} NAMESPACE Libssh2::)
export(TARGETS ${lib_name} NAMESPACE Libssh2:: FILE ${targetsFile}.cmake)
export(PACKAGE Libssh2)
install(FILES ${hdrs} DESTINATION ${CMAKE_INSTALL_INCLUDEDIR})
