setup() {
    load 'helper/setup'
    _common_setup
}


@test "empty input causes empty output" {
    run bash -c "echo '' | ranges -b"
    assert_success
    assert_output ''

    run_pipe_with_memcheck "echo ''" "ranges -b"
    assert_success
    assert_memcheck_ok

    run bash -c "echo '' | ranges --binary"
    assert_success
    assert_output ''

    run_pipe_with_memcheck "echo ''" "ranges --binary"
    assert_success
    assert_memcheck_ok
}

@test "empty input lines cause empty output" {
    run bash -c "printf '\n\n\n' | ranges -b"
    assert_success
    assert_output ''

    run_pipe_with_memcheck "printf '\n\n\n'" "ranges -b"
    assert_success
    assert_memcheck_ok

    run bash -c "printf '\n\n\n' | ranges --binary"
    assert_success
    assert_output ''

    run_pipe_with_memcheck "printf '\n\n\n'" "ranges --binary"
    assert_success
    assert_memcheck_ok
}

@test "single line input 0b1 works" {
    run bash -c "printf '0b1\n' | ranges -b"
    assert_success
    assert_output '0b1 0b1'

    run_pipe_with_memcheck "printf '0b1\n'" "ranges -b"
    assert_success
    assert_output --partial '0b1 0b1'
    assert_memcheck_ok

    run bash -c "printf '0b1\n' | ranges --binary"
    assert_success
    assert_output '0b1 0b1'

    run_pipe_with_memcheck "printf '0b1\n'" "ranges --binary"
    assert_success
    assert_output --partial '0b1 0b1'
    assert_memcheck_ok
}

@test "trivial sequence 0b1 0b10 0b11 works" {
    run bash -c "printf '0b1\n0b10\n0b11\n' | ranges -b"
    assert_success
    assert_output '0b1 0b11'

    run_pipe_with_memcheck "printf '0b1\n0b10\n0b11\n'" "ranges -b"
    assert_success
    assert_output --partial '0b1 0b11'
    assert_memcheck_ok

    run bash -c "printf '0b1\n0b10\n0b11\n' | ranges --binary"
    assert_success
    assert_output '0b1 0b11'

    run_pipe_with_memcheck "printf '0b1\n0b10\n0b11\n'" "ranges --binary"
    assert_success
    assert_output --partial '0b1 0b11'
    assert_memcheck_ok
}

@test "simple sequence 0b1 0b10 0b11 0b111 0b1000 0b1001 works" {
    run bash -c "printf '0b1\n0b10\n0b11\n0b111\n0b1000\n0b1001\n' | ranges -b"
    assert_success
    assert_output "0b1 0b11
0b111 0b1001"

    run_pipe_with_memcheck "printf '0b1\n0b10\n0b11\n0b111\n0b1000\n0b1001\n'" "ranges -b"
    assert_success
    assert_output --partial "0b1 0b11
0b111 0b1001"
    assert_memcheck_ok

    run bash -c "printf '0b1\n0b10\n0b11\n0b111\n0b1000\n0b1001\n' | ranges --binary"
    assert_success
    assert_output "0b1 0b11
0b111 0b1001"

    run_pipe_with_memcheck "printf '0b1\n0b10\n0b11\n0b111\n0b1000\n0b1001\n'" "ranges --binary"
    assert_success
    assert_output --partial "0b1 0b11
0b111 0b1001"
    assert_memcheck_ok
}

@test "duplicate number sequence 0b1 0b10 0b10 0b10 0b11 works" {
    run bash -c "printf '0b1\n0b10\n0b10\n0b10\n0b11\n' | ranges -b"
    assert_success
    assert_output '0b1 0b11'

    run_pipe_with_memcheck "printf '0b1\n0b10\n0b10\n0b10\n0b11\n'" "ranges -b"
    assert_success
    assert_output --partial '0b1 0b11'
    assert_memcheck_ok

    run bash -c "printf '0b1\n0b10\n0b10\n0b10\n0b11\n' | ranges --binary"
    assert_success
    assert_output '0b1 0b11'

    run_pipe_with_memcheck "printf '0b1\n0b10\n0b10\n0b10\n0b11\n'" "ranges --binary"
    assert_success
    assert_output --partial '0b1 0b11'
    assert_memcheck_ok
}

@test "duplicate number sequence 0b0 0b0 0b0 0b0 0b1 0b11 0b100 0b101 0b101 0b101 works" {
    run bash -c "printf -- '0b0\n0b0\n0b0\n0b0\n0b1\n0b11\n0b100\n0b101\n0b101\n0b101\n' | ranges -b"
    assert_success
    assert_output "0b0 0b1
0b11 0b101"

    run_pipe_with_memcheck "printf -- '0b0\n0b0\n0b0\n0b0\n0b1\n0b11\n0b100\n0b101\n0b101\n0b101\n'" "ranges -b"
    assert_success
    assert_output --partial "0b0 0b1
0b11 0b101"
    assert_memcheck_ok

    run bash -c "printf -- '0b0\n0b0\n0b0\n0b0\n0b1\n0b11\n0b100\n0b101\n0b101\n0b101\n' | ranges --binary"
    assert_success
    assert_output "0b0 0b1
0b11 0b101"

    run_pipe_with_memcheck "printf -- '0b0\n0b0\n0b0\n0b0\n0b1\n0b11\n0b100\n0b101\n0b101\n0b101\n'" "ranges --binary"
    assert_success
    assert_output --partial "0b0 0b1
0b11 0b101"
    assert_memcheck_ok
}

@test "wrong format sequence 0b1 2 0b11 causes format error" {
    run bash -c "printf '0b1\n2\n0b11\n' | ranges -b"
    assert_failure
    assert_output --partial "Error: Wrong input format on line '2'."

    run_pipe_with_memcheck "printf '0b1\n2\n0b11\n'" "ranges -b"
    assert_failure
    assert_output --partial "Error: Wrong input format on line '2'."
    assert_memcheck_ok

    run bash -c "printf '0b1\n2\n0b11\n' | ranges --binary"
    assert_failure
    assert_output --partial "Error: Wrong input format on line '2'."

    run_pipe_with_memcheck "printf '0b1\n2\n0b11\n'" "ranges --binary"
    assert_failure
    assert_output --partial "Error: Wrong input format on line '2'."
    assert_memcheck_ok
}

@test "wrong format sequence 0b1 '0b10 ' 0b11 causes format error" {
    run bash -c "printf '0b1\n0b10 \n0b11\n' | ranges -b"
    assert_failure
    assert_output --partial "Error: Wrong input format on line '0b10 '."

    run_pipe_with_memcheck "printf '0b1\n0b10 \n0b11\n'" "ranges -b"
    assert_failure
    assert_output --partial "Error: Wrong input format on line '0b10 '."
    assert_memcheck_ok

    run bash -c "printf '0b1\n0b10 \n0b11\n' | ranges --binary"
    assert_failure
    assert_output --partial "Error: Wrong input format on line '0b10 '."

    run_pipe_with_memcheck "printf '0b1\n0b10 \n0b11\n'" "ranges --binary"
    assert_failure
    assert_output --partial "Error: Wrong input format on line '0b10 '."
    assert_memcheck_ok
}

@test "wrong format sequence 0b1 '0b1 0b10' 0b11 causes format error" {
    run bash -c "printf '0b1\n0b1 0b10\n0b11\n' | ranges -b"
    assert_failure
    assert_output --partial "Error: Wrong input format on line '0b1 0b10'."

    run_pipe_with_memcheck "printf '0b1\n0b1 0b10\n0b11\n'" "ranges -b"
    assert_failure
    assert_output --partial "Error: Wrong input format on line '0b1 0b10'."
    assert_memcheck_ok

    run bash -c "printf '0b1\n0b1 0b10\n0b11\n' | ranges --binary"
    assert_failure
    assert_output --partial "Error: Wrong input format on line '0b1 0b10'."

    run_pipe_with_memcheck "printf '0b1\n0b1 0b10\n0b11\n'" "ranges --binary"
    assert_failure
    assert_output --partial "Error: Wrong input format on line '0b1 0b10'."
    assert_memcheck_ok
}

@test "overflow sequence 0b1000000000000000000000000000000000000000000000000000000000000000 causes overflow error" {
    run bash -c "printf '0b1000000000000000000000000000000000000000000000000000000000000000\n' | ranges -b"
    assert_failure
    assert_output --partial "Error: Overflow on input line '0b1000000000000000000000000000000000000000000000000000000000000000'."

    run_pipe_with_memcheck "printf '0b1000000000000000000000000000000000000000000000000000000000000000\n'" "ranges -b"
    assert_failure
    assert_output --partial "Error: Overflow on input line '0b1000000000000000000000000000000000000000000000000000000000000000'."
    assert_memcheck_ok

    run bash -c "printf '0b1000000000000000000000000000000000000000000000000000000000000000\n' | ranges --binary"
    assert_failure
    assert_output --partial "Error: Overflow on input line '0b1000000000000000000000000000000000000000000000000000000000000000'."

    run_pipe_with_memcheck "printf '0b1000000000000000000000000000000000000000000000000000000000000000\n'" "ranges --binary"
    assert_failure
    assert_output --partial "Error: Overflow on input line '0b1000000000000000000000000000000000000000000000000000000000000000'."
    assert_memcheck_ok
}

@test "unsorted sequence 0b1 0b10 0b11 0b10 0b111 0b1000 0b1001 causes unsorted error" {
    run bash -c "printf '0b1\n0b10\n0b11\n0b10\n0b111\n0b1000\n0b1001\n' | ranges -b"
    assert_failure
    assert_output --partial "Error: Input is not sorted on line '0b10'."

    run_pipe_with_memcheck "printf '0b1\n0b10\n0b11\n0b10\n0b111\n0b1000\n0b1001\n'" "ranges -b"
    assert_failure
    assert_output --partial "Error: Input is not sorted on line '0b10'."
    assert_memcheck_ok

    run bash -c "printf '0b1\n0b10\n0b11\n0b10\n0b111\n0b1000\n0b1001\n' | ranges --binary"
    assert_failure
    assert_output --partial "Error: Input is not sorted on line '0b10'."

    run_pipe_with_memcheck "printf '0b1\n0b10\n0b11\n0b10\n0b111\n0b1000\n0b1001\n'" "ranges --binary"
    assert_failure
    assert_output --partial "Error: Input is not sorted on line '0b10'."
    assert_memcheck_ok
}
