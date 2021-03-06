#!/usr/bin/env bash

export LC_ALL=C.UTF-8

set -euxo pipefail

# shellcheck source=../ci-fixture.sh
source "${TOPLEVEL}/contrib/teamcity/ci-fixture.sh"

# Build, run unit tests and functional tests.
build_with_cmake --Werror

# Unit tests
run_test_bitcoin
run_test_bitcoin "with next upgrade activated" -phononactivationtime=1575158400

# Libs and tools tests
# The leveldb tests need to run alone or they will sometimes fail with
# garbage output, see:
# https://build.bitcoinabc.org/viewLog.html?buildId=29713&guest=1
ninja check-leveldb
ninja \
  check-bitcoin-qt \
  check-bitcoin-seeder \
  check-bitcoin-util \
  check-devtools \
  check-rpcauth \
  check-secp256k1 \
  check-univalue \

# Functional tests
ninja check-functional
ninja check-functional-upgrade-activated
