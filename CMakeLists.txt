cmake_minimum_required(VERSION 2.6)
project(OPMOutput CXX)
enable_language(C)
enable_testing()
include(CTest)
include(TestCXXAcceptsFlag)

set(OPM_COMMON_ROOT "" CACHE PATH "Root directory containing OPM related cmake modules")
option(SIBLING_SEARCH "Search for other modules in sibling directories?" ON)
option(BUILD_TESTING "Build test applications by default?" ON)

if(NOT OPM_COMMON_ROOT)
  find_package(opm-common QUIET)
endif()

if(NOT opm-common_FOUND)
   unset(opm-common_FOUND)

   if (NOT OPM_COMMON_ROOT AND SIBLING_SEARCH)
     set(OPM_COMMON_ROOT ${PROJECT_SOURCE_DIR}/../opm-common)
   endif()
   if (OPM_COMMON_ROOT)
      list (APPEND CMAKE_MODULE_PATH "${OPM_COMMON_ROOT}/cmake/Modules")
      include (OpmInit OPTIONAL RESULT_VARIABLE OPM_INIT)
      set( OPM_MACROS_ROOT ${OPM_COMMON_ROOT} )
   endif()

   if (NOT OPM_INIT)
      message( "" )       
      message( " /---------------------------------------------------------------------------------\\")
      message( " |  Could not locate the opm build macros. The opm build macros                    |")
      message( " |  are in a separate repository - instructions to proceed:                        |")
      message( " |                                                                                 |")
      message( " |    1. Clone the repository: git clone git@github.com:OPM/opm-common.git         |")
      message( " |                                                                                 |")
      message( " |    2. Run cmake in the current project with -DOPM_COMMON_ROOT=<path>/opm-common |")
      message( " |                                                                                 |") 
      message( " \\---------------------------------------------------------------------------------/")
      message( "" )       
      message( FATAL_ERROR "Could not find OPM Macros")
   endif()

else()
   include(OpmInit)
endif()

include(UseMultiArch)
include(OpmSatellites)
include(UseWarnings)

#-----------------------------------------------------------------
# This is modified copy & paste from the OpmDefaults.cmake module.
option (USE_RUNPATH "Embed original dependency paths in installed library" ON)
if (USE_RUNPATH)
   check_cxx_accepts_flag("-Wl,--enable-new-dtags" HAVE_RUNPATH)
   if (HAVE_RUNPATH)
       SET( CMAKE_SHARED_LINKER_FLAGS "${CMAKE_SHARED_LINKER_FLAGS} -Wl,--enable-new-dtags")
       set (CMAKE_INSTALL_RPATH "${CMAKE_INSTALL_PREFIX}/${CMAKE_INSTALL_LIBDIR}") 
       set (CMAKE_INSTALL_RPATH_USE_LINK_PATH TRUE)
   endif()
endif (USE_RUNPATH)


if (NOT DEFINED CMAKE_CXX_FLAGS)
  SET( CMAKE_CXX_FLAGS "-pipe -std=c++0x -pedantic -Wall -Wextra -Wformat-nonliteral -Wcast-align -Wpointer-arith -Wmissing-declarations -Wcast-qual -Wshadow -Wwrite-strings -Wchar-subscripts -Wredundant-decls")
endif()

SET( CMAKE_CXX_FLAGS_DEBUG   "${CMAKE_CXX_FLAGS_DEBUG}   -O0 -DDEBUG  -ggdb3")
SET( CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE} -O3 -DNDEBUG -mtune=native")

if (BOOST_ROOT AND NOT DEFINED Boost_NO_SYSTEM_PATHS)
   set (Boost_NO_SYSTEM_PATHS TRUE)
endif (BOOST_ROOT AND NOT DEFINED Boost_NO_SYSTEM_PATHS)

# if we are building shared libraries ourselves, then don't include Boost in them
if (BUILD_SHARED_LIBS)
   set(Boost_USE_STATIC_LIBS    OFF)
elseif (DEFINED BUILD_SHARED_LIBS)
   set(Boost_USE_STATIC_LIBS    ON)
endif ()
set(Boost_USE_MULTITHREADED      ON)
set(Boost_USE_STATIC_RUNTIME    OFF)


# Requires BOOST filesystem version 3, thus 1.44 is necessary.
add_definitions(-DBOOST_FILESYSTEM_VERSION=3)
find_package(Boost 1.44.0 COMPONENTS unit_test_framework REQUIRED)
include_directories(${Boost_INCLUDE_DIRS})

include_directories(BEFORE ${PROJECT_SOURCE_DIR})

# if we are using dynamic boost, the header file must generate a main() function
if (NOT Boost_USE_STATIC_LIBS)
   add_definitions(-DBOOST_TEST_DYN_LINK)
endif ()

set(EXECUTABLE_OUTPUT_PATH ${CMAKE_BINARY_DIR})

include( cmake/Modules/CheckCaseSensitiveFileSystem.cmake )
add_definitions("-DHAVE_CASE_SENSITIVE_FILESYSTEM=${HAVE_CASE_SENSITIVE_FILESYSTEM}")

find_package(opm-common)
include_directories( ${opm-common_INCLUDE_DIRS} )
include( Findopm-data )

find_package(ERT)
include_directories( ${ERT_INCLUDE_DIRS} )   

set(LIBRARY_OUTPUT_PATH ${CMAKE_CURRENT_BINARY_DIR}/${CMAKE_INSTALL_LIBDIR})
set(EXECUTABLE_OUTPUT_PATH ${CMAKE_CURRENT_BINARY_DIR}/bin)

add_subdirectory(opm/output)

add_custom_target(check ${CMAKE_CTEST_COMMAND} WORKING_DIRECTORY ${PROJECT_BINARY_DIR})
add_dependencies(check test-suite)

# use this target to check local git commits
add_custom_target(check-commits
                  COMMAND ${CMAKE_COMMAND}
                          -DPROJECT_SOURCE_DIR=${PROJECT_SOURCE_DIR}
                          -DCMAKE_BINARY_DIR=${CMAKE_BINARY_DIR}
                          -P ${OPM_MACROS_ROOT}/cmake/Scripts/CheckCommits.cmake)

install(FILES dune.module DESTINATION lib/dunecontrol/opm-output)

include(OpmProject)
include(ConfigVars)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib)
set(opm-output_NAME opm-output)
set(opm-output_LIBRARIES opmoutput opmjson)
if(NOT BUILD_SHARED_LIBS)
  list(APPEND opm-output_LIBRARIES)
endif()
opm_cmake_config(opm-output)
