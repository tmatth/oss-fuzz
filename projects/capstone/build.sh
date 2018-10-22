#!/bin/bash -eu
# Copyright 2018 Google Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
################################################################################

#add next branch
for branch in master
do
    cd capstone$branch
    # build project
    mkdir build
    # does not seem to work in source directory
    # + make.sh overwrites CFLAGS
    cd build
    cmake -DCAPSTONE_BUILD_SHARED=0 ..
    make

    cd ../suite/fuzz
    # TODO corpus

    # export other associated stuff
    cp *.options $OUT/

    # build fuzz target
    $CC $CFLAGS -I../../include/ -c fuzz_disasm.c -o fuzz_disasm.o

    $CXX $CXXFLAGS fuzz_disasm.o -o $OUT/fuzz_disasm$branch ../../build/libcapstone.a -lFuzzingEngine

    cd ../../../
done
