if (CMAKE_Fortran_COMPILER_VERSION VERSION_LESS 5.3)
  message(FATAL_ERROR "${CMAKE_Fortran_COMPILER_ID} version must be at least 5.3!")
endif()

set (FOPT0 "-O0")
set (FOPT1 "-O1")
set (FOPT2 "-O2")
set (FOPT3 "-O3")
set (FOPT4 "-O3")
set (AVX2 "-O3")
set (DEBINFO "-g")
set (DEBFULL "-ggdb")
set (WARNALL "-Wall")
set (STACKLOCAL "-fstack-arrays")
set (IMPLICITNONE "")
set (UNROLL "-funroll-loops")
set (NOTAB "-Wno-tabs")
set (MKL_FLAG "")

set (FPE0 "")
set (FPE3 "")
set (FP_MODEL_SOURCE "")
set (FP_MODEL_STRICT "")
set (FP_MODEL_CONSISTENT "")
set (CHECKALL "-fcheck=all")
set (DEBUGALL "-fbacktrace -fdump-fortran-optimized -fdump-fortran-original -fdump-parse-tree -ffpe-trap=list")
set (FP_STACK_CHECK "")
set (MC_MODEL_MEDIUM "")
set (HEAP_ARRAYS "")
set (IPOPT "")
set (NOOMPCC "")

set (OPTREPORT0 "")
set (OPTREPORT5 "")
set (fdbl8 "-fdefault-double-8")
set (frl8 "-fdefault-real-8")
set (FREAL8 ${frl8} ${fdbl8})
set (FINT8 "-fdefault-integer-8")

set (MMMED "")
set (MMSML "")
set (MMLGE "")
set (PP    "-cpp")
set (FREEFORM    "-ffree-form")
set (SHARED "")
set (COMPSHARED "")
set (COMPSTATIC "-static-libgfortran")
set (XHOST "")
set (MISMATCH "")
set (BIG_ENDIAN "-fconvert=big-endian")
#set (BIG_ENDIAN "-fconvert=swap") # This doesn't seem to work at the moment
#set (LITTLE_ENDIAN "") # Not sure
set (NOLINELEN "-ffree-line-length-none")
set (EXTENDED_SOURCE "-ffixed-line-length-132")
set (FIXED_SOURCE "-ffixed-form")
set (DISABLE_FIELD_WIDTH_WARNING "")
set (CRAY_POINTER "-fcray-pointer")
set (MCMODEL "")
set (HEAPARRAYS "")
set (BYTERECLEN "-frecord-marker=4")
set (ALIGNCOM "-falign-commons")
set (TRACEBACK "-fbacktrace")
set (NOOLD_MAXMINLOC "")
set (REALLOC_LHS "")
set (ARCH_CONSISTENCY "")
set (FTZ "")
set (ALIGN_ALL "")
set (NO_ALIAS "")

set (NO_RANGE_CHECK "-fno-range-check")

####################################################

add_definitions(-D__GFORTRAN__)

# Common Fortran Flags
# --------------------
set (common_Fortran_flags "-ffree-line-length-none ${NO_RANGE_CHECK} -Wno-missing-include-dirs ${TRACEBACK}")
set (common_Fortran_fpe_flags "-ffpe-trap=zero,overflow ${TRACEBACK}")

# GEOS Debug
# ----------
set (GEOS_Fortran_Debug_Flags "${FOPT0} ${DEBINFO} -fcheck=all,no-array-temps -finit-real=snan")
set (GEOS_Fortran_Debug_FPE_Flags "${common_Fortran_fpe_flags}")

# GEOS Release
# ------------
set (GEOS_Fortran_Release_Flags "${FOPT3} -march=westmere -mtune=generic -funroll-loops ${DEBINFO}")
set (GEOS_Fortran_Release_FPE_Flags "${common_Fortran_fpe_flags}")

# GEOS Vectorize
# --------------
# NOTE: gfortran does get a benefit from vectorization, but the resulting code
#       does not layout regress. Options kept here for testing purposes

# Options per Jerry DeLisle on GCC Fortran List
#set (GEOS_Fortran_Vect_Flags "${FOPT2} -march=native -ffast-math -ftree-vectorize -funroll-loops --param max-unroll-times=4 -mprefer-avx128 -mno-fma")

# Options per Jerry DeLisle on GCC Fortran List with SVML
#set (GEOS_Fortran_Vect_Flags "-O2 -march=native -ffast-math -ftree-vectorize -funroll-loops --param max-unroll-times=4 -mprefer-avx128 -mno-fma -mveclibabi=svml")
#set (GEOS_Fortran_Vect_FPE_Flags "${DEBINFO} ${TRACEBACK}")

# Until good options can be found, make vectorize equal common flags
set (GEOS_Fortran_Vect_Flags ${GEOS_Fortran_Release_Flags})
set (GEOS_Fortran_Vect_FPE_Flags ${GEOS_Fortran_Release_FPE_Flags})

# Common variables for every compiler
#include(GenericCompiler)
