macro (setWCOSS)
  message("Setting paths for WCOSS")
  option(FIND_HDF5 "Try to Find HDF5 libraries" OFF)
  option(FIND_HDF5_HL "Try to Find HDF5 libraries" OFF)
  set(HDF5_USE_STATIC_LIBRARIES "OFF")

  #if ibmpe module is not loaded last, CMake tries to use intel mpi. Force use of ibmhpc
  set(HOST_FLAG "${XHOST}" CACHE INTERNAL "Host Flag")
  set(GSI_Fortran_FLAGS "-DPOUND_FOR_STRINGIFY ${TRACEBACK} ${FOPT3} ${FP_MODEL_SOURCE} ${BIG_ENDIAN} ${BYTERECLEN} ${IMPLICITNONE} -D_REAL8_ ${OpenMP_Fortran_FLAGS} ${MPI_Fortran_COMPILE_FLAGS}" CACHE INTERNAL "")
  set(ENKF_Fortran_FLAGS "${FOPT3} ${FP_MODEL_SOURCE} ${BIG_ENDIAN} ${BYTERECLEN} ${IMPLICITNONE}  -DGFS -D_REAL8_ ${OpenMP_Fortran_FLAGS} ${HOST_FLAG} " CACHE INTERNAL "")

  set(MPI_Fortran_COMPILER /opt/ibmhpc/pe13010/base/bin/mpif90 CACHE FILEPATH "Forced use of ibm wrapper" FORCE )
  set(MPI_C_COMPILER /opt/ibmhpc/pe13010/base/bin/mpicc CACHE FILEPATH "Forced use of ibm wrapper" FORCE )
  set(MPI_CXX_COMPILER /opt/ibmhpc/pe13010/base/bin/mpicxx CACHE FILEPATH "Forced use of ibm wrapper" FORCE )

  if( NOT DEFINED ENV{COREPATH} )
    set(COREPATH "/nwprod/lib"  )
  else()
    set(COREPATH $ENV{COREPATH}  )
  endif()
  if( NOT DEFINED ENV{WRFPATH} )
    set(WRFPATH "/nwprod/sorc/wrf_shared.fd"  )
  else()
    set(WRFPATH $ENV{WRFPATH}  )
  endif()
  set(GSI_LDFLAGS "${OpenMP_Fortran_FLAGS}" CACHE INTERNAL "")
endmacro()
