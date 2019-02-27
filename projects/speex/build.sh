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

./autogen.sh
export CFLAGS="$CFLAGS -DDISABLE_NOTIFICATIONS -DDISABLE_WARNINGS"
./configure --prefix="$WORK" --enable-static --disable-shared
make -j$(nproc)
make install
$CXX $CXXFLAGS contrib/oss-fuzz/speex_decode_fuzzer.cc -o $OUT/speex_decode_fuzzer -L"$WORK/lib" -I"$WORK/include" -lFuzzingEngine -lspeex

# build samples and prepare corpus
cd src/
./generate-samples.sh
zip -j0r ${OUT}/speex_decode_fuzzer_seed_corpus.zip ./samples/
cd ..
