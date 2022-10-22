#!/usr/bin/env bash

_common_setup() {
    load 'deps/bats-assert/load'
    load 'deps/bats-support/load'

    ROOT="$(cd "$(dirname "$BATS_TEST_FILENAME")" >/dev/null 2>&1 && pwd)/.."
    PATH="$ROOT/bin:$PATH"
}
