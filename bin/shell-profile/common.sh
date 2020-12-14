#!/bin/bash

function second() {
    local executable=$1; shift
    local next_executable=$(which -a "$executable" | head -n2 | tail -n1)

    "$next_executable" "$@"
}
