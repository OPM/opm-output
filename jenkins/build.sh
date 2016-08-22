#!/bin/bash

source `dirname $0`/build-opm-output.sh

declare -a upstreams
upstreams=(ert
           opm-parser)

declare -A upstreamRev
upstreamRev[ert]=master
upstreamRev[opm-parser]=master

OPM_COMMON_REVISION=master

build_opm_output
test $? -eq 0 || exit 1

cp serial/build-opm-output/testoutput.xml .
