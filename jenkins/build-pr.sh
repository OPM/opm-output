#!/bin/bash

source `dirname $0`/build-opm-output.sh

declare -a upstreams
upstreams=(ert
           opm-parser)

declare -A upstreamRev
upstreamRev[ert]=master
upstreamRev[opm-parser]=master

OPM_COMMON_REVISION=master

if grep -q "opm-common=" <<< $ghprbCommentBody
then
  OPM_COMMON_REVISION=pull/`echo $ghprbCommentBody | sed -r 's/.*opm-common=([0-9]+).*/\1/g'`/merge
fi

for upstream in $upstreams
do
  if grep -q "$upstream=" <<< $ghprbCommentBody
  then
    upstreamRev[$upstream]=pull/`echo $ghprbCommentBody | sed -r "s/.*$upstream=([0-9]+).*/\1/g"`/merge
  fi
done

echo "Building with opm-common=$OPM_COMMON_REVISION ert=${upstreamRev[ert]} opm-parser=${upstreamRev[opm-parser]} opm-output=$sha1"

build_opm_output
test $? -eq 0 || exit 1

# If no downstream builds we are done
if ! grep -q "with downstreams" <<< $ghprbCommentBody
then
  cp serial/build-opm-output/testoutput.xml .
  exit 0
fi

# Downstream revisions
declare -a downstreams
downstreams=(opm-material
             opm-core
             opm-grid
             opm-simulators
             opm-upscaling)

declare -A downstreamRev
downstreamRev[opm-material]=master
downstreamRev[opm-core]=master
downstreamRev[opm-grid]=master
downstreamRev[opm-simulators]=master
downstreamRev[opm-upscaling]=master

source $WORKSPACE/deps/opm-common/jenkins/setup-opm-data.sh
source $WORKSPACE/deps/opm-common/jenkins/build-opm-module.sh

build_downstreams opm-output

test $? -eq 0 || exit 1
