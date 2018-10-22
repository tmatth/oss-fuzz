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

# Build project
autoreconf
env
env CFLAGS="" ./configure --with-cflags-after="$CFLAGS" --with-ldflags-after="-g $CFLAGS"
make -j$(nproc) all

# Build fuzzers
STATIC_CRYPTO="-Wl,-Bstatic -lcrypto -Wl,-Bdynamic"

$CXX $CXXFLAGS -std=c++11 -I. -L. -Lopenbsd-compat -g \
	regress/misc/fuzz-harness/pubkey_fuzz.cc -o $OUT/pubkey_fuzz \
	-lssh -lopenbsd-compat $STATIC_CRYPTO -lFuzzingEngine
$CXX $CXXFLAGS -std=c++11 -I. -L. -Lopenbsd-compat -g \
	regress/misc/fuzz-harness/sig_fuzz.cc -o $OUT/sig_fuzz \
	-lssh -lopenbsd-compat $STATIC_CRYPTO -lFuzzingEngine

# Prepare seed corpora
CASES="$SRC/openssh-fuzz-cases"
(set -e ; cd ${CASES}/key ; zip -r $OUT/pubkey_fuzz_seed_corpus.zip .)
(set -e ; cd ${CASES}/sig ; zip -r $OUT/sig_fuzz_seed_corpus.zip .)
