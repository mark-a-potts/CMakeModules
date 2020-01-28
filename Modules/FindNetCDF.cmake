  
# - Find NetCDF
# Find the native NetCDF includes and library
#
#  NETCDF_INCLUDES    - where to find netcdf.h, etc
#  NETCDF_LIBRARIES   - Link these libraries when using NetCDF
#  NETCDF_FOUND       - True if NetCDF found including required interfaces (see below)
#
# Your package can require certain interfaces to be FOUND by setting these
#
#  NETCDF_CXX         - require the C++ interface and link the C++ library
#  NETCDF_F77         - require the F77 interface and link the fortran library
#  NETCDF_F90         - require the F90 interface and link the fortran library
#
# The following are not for general use and are included in
# NETCDF_LIBRARIES if the corresponding option above is set.
#
#  NETCDF_LIBRARIES_C    - Just the C interface
#  NETCDF_LIBRARIES_CXX  - C++ interface, if available
#  NETCDF_LIBRARIES_F77  - Fortran 77 interface, if available
#  NETCDF_LIBRARIES_F90  - Fortran 90 interface, if available
#
# Normal usage would be:
#  set (NETCDF_F90 "YES")
#  find_package (NetCDF REQUIRED)
#  target_link_libraries (uses_f90_interface ${NETCDF_LIBRARIES})
#  target_link_libraries (only_uses_c_interface ${NETCDF_LIBRARIES_C})


if (NETCDF_INCLUDES AND NETCDF_LIBRARIES)
  # Already in cache, be silent
  set (NETCDF_FIND_QUIETLY TRUE)
endif (NETCDF_INCLUDES AND NETCDF_LIBRARIES)

find_path (NETCDF_INCLUDES netcdf.h
  HINTS ${NETCDF}/include ${NETCDF_DIR}/include $ENV{NETCDF}/include $ENV{NETCDF_DIR} )

if(DEFINED ENV{NETCDF_FORTRAN})
  set(NETCDF_FORTRAN $ENV{NETCDF_FORTRAN})
elseif(DEFINED ENV{NETCDF_F90})
  set(NETCDF_FORTRAN $ENV{NETCDF_F90})
elseif(DEFINED ${NETCDF_F90})
  set(NETCDF_FORTRAN ${NETCDF_F90})
elseif(DEFINED ${NETCDF_FORTRAN})
  set(NETCDF_FORTRAN ${NETCDF_FORTRAN})
elseif(DEFINED ${NETCDF})
  set(NETCDF_FORTRAN ${NETCDF})
elseif(DEFINED ENV{NETCDF})
  set(NETCDF_FORTRAN $ENV{NETCDF})
endif()
find_path (NETCDF_INCLUDES_FORTRAN netcdf.inc
  HINTS 
   ${NETCDF_FORTRAN}/include 
   ${EXTERNAL_LIBS_DIR}/include
   ${EXTERNAL_LIBS_DIR}/mod
   ${NETCDF_FORTRAN}/mod )
message("fortran incs are ${NETCDF_INCLUDES_FORTRAN}")
message("netcdf_fortran is ${NETCDF_FORTRAN}")


find_library (NETCDF_LIBRARIES_C NAMES libnetcdf.so libnetcdf.a libnetcdf.dylib 
   HINTS 
     ${EXTERNAL_LIBS_DIR}/lib 
     ${EXTERNAL_LIBS_DIR}/lib64
     ${NETCDF}/lib 
     ${NETCDF_DIR}/lib
     ${NETCDF}/lib64 
     ${NETCDF_DIR}/lib64
     $ENV{NETCDF}/lib
     $ENV{NETCDF_DIR}/lib 
     $ENV{NETCDF}/lib64
     $ENV{NETCDF_DIR}/lib64 )
message("NETCDFLIBS_C are ${NETCDF_LIBRARIES_C}")
mark_as_advanced(NETCDF_LIBRARIES_C)

set (NetCDF_has_interfaces "YES") # will be set to NO if we're missing any interfaces
set (NetCDF_libs "${NETCDF_LIBRARIES_C}")

get_filename_component (NetCDF_lib_dirs "${NETCDF_LIBRARIES_C}" PATH)
message("lib dirs is ${NetCDF_lib_dirs}")


macro (NetCDF_check_interface lang header libs)
  if (NETCDF_${lang})
    message("looking for ${lang} with name ${libs} in ${NetCDF_lib_dirs} ; ${NETCDF_FORTRAN}/lib ; ${NETCDF_FORTRAN}/lib64")
    find_path (NETCDF_INCLUDES_${lang} NAMES ${header}
      HINTS ${NETCDF_INCLUDES} ${NETCDF_INCLUDES_FORTRAN} NO_DEFAULT_PATH)
    find_library (NETCDF_LIBRARIES_${lang} NAMES ${libs}
      HINTS ${NetCDF_lib_dirs} ${NETCDF_FORTRAN}/lib ${NETCDF_FORTRAN}/lib64 NO_DEFAULT_PATH)
    message("${NETCDF_INCLUDES_F90} and ${NETCDF_LIBRARIES_F90}")
    mark_as_advanced (NETCDF_INCLUDES_${lang} NETCDF_LIBRARIES_${lang})
    if (NETCDF_INCLUDES_${lang} AND NETCDF_LIBRARIES_${lang})
      list (INSERT NetCDF_libs 0 ${NETCDF_LIBRARIES_${lang}}) # prepend so that -lnetcdf is last
    else (NETCDF_INCLUDES_${lang} AND NETCDF_LIBRARIES_${lang})
      set (NetCDF_has_interfaces "NO")
      message (STATUS "Failed to find NetCDF interface for ${lang}")
    endif (NETCDF_INCLUDES_${lang} AND NETCDF_LIBRARIES_${lang})
  endif (NETCDF_${lang})
endmacro (NetCDF_check_interface)

NetCDF_check_interface (CXX netcdfcpp.h netcdf_c++)
NetCDF_check_interface (F77 netcdf.inc  netcdff)
NetCDF_check_interface (F90 netcdf.mod  netcdff)

set (NETCDF_LIBRARIES "${NetCDF_libs}" CACHE STRING "All NetCDF libraries required for interface level")
if(NOT (${NETCDF_INCLUDES_FORTRAN} STREQUAL "netcdf.inc-NOTFOUND"))
  set (NETCDF_INCLUDES "${NETCDF_INCLUDES};${NETCDF_INCLUDES_FORTRAN}")
endif()
# handle the QUIETLY and REQUIRED arguments and set NETCDF_FOUND to TRUE if
# all listed variables are TRUE
include (FindPackageHandleStandardArgs)
find_package_handle_standard_args (NetCDF DEFAULT_MSG NETCDF_LIBRARIES NETCDF_INCLUDES NetCDF_has_interfaces)

mark_as_advanced (NETCDF_LIBRARIES NETCDF_INCLUDES)
