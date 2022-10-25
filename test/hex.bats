setup() {
    load 'helper/setup'
    _common_setup
}


@test "empty input causes empty output" {
    run bash -c "echo '' | ranges -H"
    assert_success
    assert_output ''

    run_pipe_with_memcheck "echo ''" "ranges -H"
    assert_success
    assert_memcheck_ok

    run bash -c "echo '' | ranges --hex"
    assert_success
    assert_output ''

    run_pipe_with_memcheck "echo ''" "ranges --hex"
    assert_success
    assert_memcheck_ok
}

@test "empty input lines cause empty output" {
    run bash -c "printf '\n\n\n' | ranges -H"
    assert_success
    assert_output ''

    run_pipe_with_memcheck "printf '\n\n\n'" "ranges -H"
    assert_success
    assert_memcheck_ok

    run bash -c "printf '\n\n\n' | ranges --hex"
    assert_success
    assert_output ''

    run_pipe_with_memcheck "printf '\n\n\n'" "ranges --hex"
    assert_success
    assert_memcheck_ok
}

@test "single line input 0x1 works" {
    run bash -c "printf '0x1\n' | ranges -H"
    assert_success
    assert_output '0x1 0x1'

    run_pipe_with_memcheck "printf '0x1\n'" "ranges -H"
    assert_success
    assert_output --partial '0x1 0x1'
    assert_memcheck_ok

    run bash -c "printf '0x1\n' | ranges --hex"
    assert_success
    assert_output '0x1 0x1'

    run_pipe_with_memcheck "printf '0x1\n'" "ranges --hex"
    assert_success
    assert_output --partial '0x1 0x1'
    assert_memcheck_ok
}

@test "trivial sequence 0x1 0x2 0x3 works" {
    run bash -c "printf '0x1\n0x2\n0x3\n' | ranges -H"
    assert_success
    assert_output '0x1 0x3'

    run_pipe_with_memcheck "printf '0x1\n0x2\n0x3\n'" "ranges -H"
    assert_success
    assert_output --partial '0x1 0x3'
    assert_memcheck_ok

    run bash -c "printf '0x1\n0x2\n0x3\n' | ranges --hex"
    assert_success
    assert_output '0x1 0x3'

    run_pipe_with_memcheck "printf '0x1\n0x2\n0x3\n'" "ranges --hex"
    assert_success
    assert_output --partial '0x1 0x3'
    assert_memcheck_ok
}

@test "simple sequence 0x1 0x2 0x3 0x7 0x8 0x9 works" {
    run bash -c "printf '0x1\n0x2\n0x3\n0x7\n0x8\n0x9\n' | ranges -H"
    assert_success
    assert_output "0x1 0x3
0x7 0x9"

    run_pipe_with_memcheck "printf '0x1\n0x2\n0x3\n0x7\n0x8\n0x9\n'" "ranges -H"
    assert_success
    assert_output --partial "0x1 0x3
0x7 0x9"
    assert_memcheck_ok

    run bash -c "printf '0x1\n0x2\n0x3\n0x7\n0x8\n0x9\n' | ranges --hex"
    assert_success
    assert_output "0x1 0x3
0x7 0x9"

    run_pipe_with_memcheck "printf '0x1\n0x2\n0x3\n0x7\n0x8\n0x9\n'" "ranges --hex"
    assert_success
    assert_output --partial "0x1 0x3
0x7 0x9"
    assert_memcheck_ok
}

@test "duplicate number sequence 0x1 0x2 0x2 0x2 0x3 works" {
    run bash -c "printf '0x1\n0x2\n0x2\n0x2\n0x3\n' | ranges -H"
    assert_success
    assert_output '0x1 0x3'

    run_pipe_with_memcheck "printf '0x1\n0x2\n0x2\n0x2\n0x3\n'" "ranges -H"
    assert_success
    assert_output --partial '0x1 0x3'
    assert_memcheck_ok

    run bash -c "printf '0x1\n0x2\n0x2\n0x2\n0x3\n' | ranges --hex"
    assert_success
    assert_output '0x1 0x3'

    run_pipe_with_memcheck "printf '0x1\n0x2\n0x2\n0x2\n0x3\n'" "ranges --hex"
    assert_success
    assert_output --partial '0x1 0x3'
    assert_memcheck_ok
}

@test "dumplicate number sequence 0x0 0x0 0x0 0x0 0x1 0x3 0x4 0x5 0x5 0x5 works" {
    run bash -c "printf -- '0x0\n0x0\n0x0\n0x0\n0x1\n0x3\n0x4\n0x5\n0x5\n0x5\n' | ranges -H"
    assert_success
    assert_output "0x0 0x1
0x3 0x5"

    run_pipe_with_memcheck "printf -- '0x0\n0x0\n0x0\n0x0\n0x1\n0x3\n0x4\n0x5\n0x5\n0x5\n'" "ranges -H"
    assert_success
    assert_output --partial "0x0 0x1
0x3 0x5"
    assert_memcheck_ok

    run bash -c "printf -- '0x0\n0x0\n0x0\n0x0\n0x1\n0x3\n0x4\n0x5\n0x5\n0x5\n' | ranges --hex"
    assert_success
    assert_output "0x0 0x1
0x3 0x5"

    run_pipe_with_memcheck "printf -- '0x0\n0x0\n0x0\n0x0\n0x1\n0x3\n0x4\n0x5\n0x5\n0x5\n'" "ranges --hex"
    assert_success
    assert_output --partial "0x0 0x1
0x3 0x5"
    assert_memcheck_ok
}

@test "wrong format sequence 0x1 2 0x3 causes format error" {
    run bash -c "printf '0x1\n2\n0x3\n' | ranges -H"
    assert_failure
    assert_output --partial "Error: Wrong input format on line '2'."

    run_pipe_with_memcheck "printf '0x1\n2\n0x3\n'" "ranges -H"
    assert_failure
    assert_output --partial "Error: Wrong input format on line '2'."
    assert_memcheck_ok

    run bash -c "printf '0x1\n2\n0x3\n' | ranges --hex"
    assert_failure
    assert_output --partial "Error: Wrong input format on line '2'."

    run_pipe_with_memcheck "printf '0x1\n2\n0x3\n'" "ranges --hex"
    assert_failure
    assert_output --partial "Error: Wrong input format on line '2'."
    assert_memcheck_ok
}

@test "wrong format sequence 0x1 '0x2 ' 0x3 causes format error" {
    run bash -c "printf '0x1\n0x2 \n0x3\n' | ranges -H"
    assert_failure
    assert_output --partial "Error: Wrong input format on line '0x2 '."

    run_pipe_with_memcheck "printf '0x1\n0x2 \n0x3\n'" "ranges -H"
    assert_failure
    assert_output --partial "Error: Wrong input format on line '0x2 '."
    assert_memcheck_ok

    run bash -c "printf '0x1\n0x2 \n0x3\n' | ranges --hex"
    assert_failure
    assert_output --partial "Error: Wrong input format on line '0x2 '."

    run_pipe_with_memcheck "printf '0x1\n0x2 \n0x3\n'" "ranges --hex"
    assert_failure
    assert_output --partial "Error: Wrong input format on line '0x2 '."
    assert_memcheck_ok
}

@test "wrong format sequence 0x1 '0x1 0x2' 0x3 causes format error" {
    run bash -c "printf '0x1\n0x1 0x2\n0x3\n' | ranges -H"
    assert_failure
    assert_output --partial "Error: Wrong input format on line '0x1 0x2'."

    run_pipe_with_memcheck "printf '0x1\n0x1 0x2\n0x3\n'" "ranges -H"
    assert_failure
    assert_output --partial "Error: Wrong input format on line '0x1 0x2'."
    assert_memcheck_ok

    run bash -c "printf '0x1\n0x1 0x2\n0x3\n' | ranges --hex"
    assert_failure
    assert_output --partial "Error: Wrong input format on line '0x1 0x2'."

    run_pipe_with_memcheck "printf '0x1\n0x1 0x2\n0x3\n'" "ranges --hex"
    assert_failure
    assert_output --partial "Error: Wrong input format on line '0x1 0x2'."
    assert_memcheck_ok
}

@test "overflow sequence 0x7fffffffffffffff causes overflow error" {
    run bash -c "printf '0x7fffffffffffffff\n' | ranges -H"
    assert_failure
    assert_output --partial "Error: Overflow on input line '0x7fffffffffffffff'."

    run_pipe_with_memcheck "printf '0x7fffffffffffffff\n'" "ranges -H"
    assert_failure
    assert_output --partial "Error: Overflow on input line '0x7fffffffffffffff'."
    assert_memcheck_ok

    run bash -c "printf '0x7fffffffffffffff\n' | ranges --hex"
    assert_failure
    assert_output --partial "Error: Overflow on input line '0x7fffffffffffffff'."

    run_pipe_with_memcheck "printf '0x7fffffffffffffff\n'" "ranges --hex"
    assert_failure
    assert_output --partial "Error: Overflow on input line '0x7fffffffffffffff'."
    assert_memcheck_ok
}

@test "unsorted sequence 0x1 0x2 0x3 0x2 0x7 0x8 0x9 causes unsorted error" {
    run bash -c "printf '0x1\n0x2\n0x3\n0x2\n0x7\n0x8\n0x9\n' | ranges -H"
    assert_failure
    assert_output --partial "Error: Input is not sorted on line '0x2'."

    run_pipe_with_memcheck "printf '0x1\n0x2\n0x3\n0x2\n0x7\n0x8\n0x9\n'" "ranges -H"
    assert_failure
    assert_output --partial "Error: Input is not sorted on line '0x2'."
    assert_memcheck_ok

    run bash -c "printf '0x1\n0x2\n0x3\n0x2\n0x7\n0x8\n0x9\n' | ranges --hex"
    assert_failure
    assert_output --partial "Error: Input is not sorted on line '0x2'."

    run_pipe_with_memcheck "printf '0x1\n0x2\n0x3\n0x2\n0x7\n0x8\n0x9\n'" "ranges --hex"
    assert_failure
    assert_output --partial "Error: Input is not sorted on line '0x2'."
    assert_memcheck_ok
}
