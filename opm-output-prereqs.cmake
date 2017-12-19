# defines that must be present in config.h for our headers
set (opm-output_CONFIG_VAR
  HAVE_ERT
  )

# dependencies
set (opm-output_DEPS
  # compile with C99 support if available
  "C99"
  # compile with C++0x/11 support if available
  "CXX11Features REQUIRED"
  # various runtime library enhancements
  "Boost 1.44.0
    COMPONENTS unit_test_framework REQUIRED"
  # Ensembles-based Reservoir Tools (ERT)
  "ecl REQUIRED"
  # Look for MPI support
  "opm-common REQUIRED"
  # Parser library for ECL-type simulation models
  "opm-parser REQUIRED"
  )

find_package_deps(opm-output)
