#!/bin/bash -eu
# Copyright 2017 Google Inc.
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

# Required for some reason... I don't ask questions
export SHELL=/bin/bash

autoconf2.13

mkdir build_DBG.OBJ
cd build_DBG.OBJ

../configure \
    --enable-debug \
    --enable-optimize \
    --disable-shared-js \
    --disable-jemalloc \
    --enable-address-sanitizer

make

cp dist/bin/js $OUT
