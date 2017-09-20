cmake_minimum_required(VERSION 3.0)
project(libssh2)
set(lib_name ${PROJECT_NAME})
include(flags OPTIONAL)
########################################
set_property(GLOBAL PROPERTY USE_FOLDERS ON) # enables MSVC Solution Folders
include(configure.cmake)
include_directories(include)
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
set(ver _${LIBSSH2_VER})
set(verDir /${PROJECT_NAME}${ver})
########################################
# library
add_library(${lib_name} STATIC ${${lib_name}_libsrcs})
if(LIBSSH2_LIBS)
  target_link_libraries(${lib_name} ${LIBSSH2_LIBS})
endif()
# strip off the "lib" prefix, since it's already libssh2
set_target_properties(${lib_name} PROPERTIES OUTPUT_NAME ${lib_name}${ver} PREFIX "")
########################################
# install
set(targetsFile ${PROJECT_NAME}${ver}-targets)
install(TARGETS ${lib_name} EXPORT ${targetsFile}
  RUNTIME DESTINATION bin
  ARCHIVE DESTINATION lib
  LIBRARY DESTINATION lib
  )
install(EXPORT ${targetsFile} DESTINATION lib/cmake)
install(FILES ${hdrs} DESTINATION include${verDir}/${PROJECT_NAME})
