setup() {
    load 'helper/setup'
    _common_setup
}


@test "empty input causes empty output" {
    run bash -c "echo '' | ranges -o"
    assert_success
    assert_output ''

    run_pipe_with_memcheck "echo ''" "ranges -o"
    assert_success
    assert_memcheck_ok

    run bash -c "echo '' | ranges --octal"
    assert_success
    assert_output ''

    run_pipe_with_memcheck "echo ''" "ranges --octal"
    assert_success
    assert_memcheck_ok
}

@test "empty input lines cause empty output" {
    run bash -c "printf '\n\n\n' | ranges -o"
    assert_success
    assert_output ''

    run_pipe_with_memcheck "printf '\n\n\n'" "ranges -o"
    assert_success
    assert_memcheck_ok

    run bash -c "printf '\n\n\n' | ranges --octal"
    assert_success
    assert_output ''

    run_pipe_with_memcheck "printf '\n\n\n'" "ranges --octal"
    assert_success
    assert_memcheck_ok
}

@test "single line input 0o1 works" {
    run bash -c "printf '0o1\n' | ranges -o"
    assert_success
    assert_output '0o1 0o1'

    run_pipe_with_memcheck "printf '0o1\n'" "ranges -o"
    assert_success
    assert_output --partial '0o1 0o1'
    assert_memcheck_ok

    run bash -c "printf '0o1\n' | ranges --octal"
    assert_success
    assert_output '0o1 0o1'

    run_pipe_with_memcheck "printf '0o1\n'" "ranges --octal"
    assert_success
    assert_output --partial '0o1 0o1'
    assert_memcheck_ok
}

@test "trivial sequence 0o1 0o2 0o3 works" {
    run bash -c "printf '0o1\n0o2\n0o3\n' | ranges -o"
    assert_success
    assert_output '0o1 0o3'

    run_pipe_with_memcheck "printf '0o1\n0o2\n0o3\n'" "ranges -o"
    assert_success
    assert_output --partial '0o1 0o3'
    assert_memcheck_ok

    run bash -c "printf '0o1\n0o2\n0o3\n' | ranges --octal"
    assert_success
    assert_output '0o1 0o3'

    run_pipe_with_memcheck "printf '0o1\n0o2\n0o3\n'" "ranges --octal"
    assert_success
    assert_output --partial '0o1 0o3'
    assert_memcheck_ok
}

@test "simple sequence 0o1 0o2 0o3 0o7 0o10 0o11 works" {
    run bash -c "printf '0o1\n0o2\n0o3\n0o7\n0o10\n0o11\n' | ranges -o"
    assert_success
    assert_output "0o1 0o3
0o7 0o11"

    run_pipe_with_memcheck "printf '0o1\n0o2\n0o3\n0o7\n0o10\n0o11\n'" "ranges -o"
    assert_success
    assert_output --partial "0o1 0o3
0o7 0o11"
    assert_memcheck_ok

    run bash -c "printf '0o1\n0o2\n0o3\n0o7\n0o10\n0o11\n' | ranges --octal"
    assert_success
    assert_output "0o1 0o3
0o7 0o11"

    run_pipe_with_memcheck "printf '0o1\n0o2\n0o3\n0o7\n0o10\n0o11\n'" "ranges --octal"
    assert_success
    assert_output --partial "0o1 0o3
0o7 0o11"
    assert_memcheck_ok
}

@test "duplicate number sequence 0o1 0o2 0o2 0o2 0o3 works" {
    run bash -c "printf '0o1\n0o2\n0o2\n0o2\n0o3\n' | ranges -o"
    assert_success
    assert_output '0o1 0o3'

    run_pipe_with_memcheck "printf '0o1\n0o2\n0o2\n0o2\n0o3\n'" "ranges -o"
    assert_success
    assert_output --partial '0o1 0o3'
    assert_memcheck_ok

    run bash -c "printf '0o1\n0o2\n0o2\n0o2\n0o3\n' | ranges --octal"
    assert_success
    assert_output '0o1 0o3'

    run_pipe_with_memcheck "printf '0o1\n0o2\n0o2\n0o2\n0o3\n'" "ranges --octal"
    assert_success
    assert_output --partial '0o1 0o3'
    assert_memcheck_ok
}

@test "dumplicate number sequence 0o0 0o0 0o0 0o0 0o1 0o3 0o4 0o5 0o5 0o5 works" {
    run bash -c "printf -- '0o0\n0o0\n0o0\n0o0\n0o1\n0o3\n0o4\n0o5\n0o5\n0o5\n' | ranges -o"
    assert_success
    assert_output "0o0 0o1
0o3 0o5"

    run_pipe_with_memcheck "printf -- '0o0\n0o0\n0o0\n0o0\n0o1\n0o3\n0o4\n0o5\n0o5\n0o5\n'" "ranges -o"
    assert_success
    assert_output --partial "0o0 0o1
0o3 0o5"
    assert_memcheck_ok

    run bash -c "printf -- '0o0\n0o0\n0o0\n0o0\n0o1\n0o3\n0o4\n0o5\n0o5\n0o5\n' | ranges --octal"
    assert_success
    assert_output "0o0 0o1
0o3 0o5"

    run_pipe_with_memcheck "printf -- '0o0\n0o0\n0o0\n0o0\n0o1\n0o3\n0o4\n0o5\n0o5\n0o5\n'" "ranges --octal"
    assert_success
    assert_output --partial "0o0 0o1
0o3 0o5"
    assert_memcheck_ok
}

@test "wrong format sequence 0o1 2 0o3 causes format error" {
    run bash -c "printf '0o1\n2\n0o3\n' | ranges -o"
    assert_failure
    assert_output --partial "Error: Wrong input format on line '2'."

    run_pipe_with_memcheck "printf '0o1\n2\n0o3\n'" "ranges -o"
    assert_failure
    assert_output --partial "Error: Wrong input format on line '2'."
    assert_memcheck_ok

    run bash -c "printf '0o1\n2\n0o3\n' | ranges --octal"
    assert_failure
    assert_output --partial "Error: Wrong input format on line '2'."

    run_pipe_with_memcheck "printf '0o1\n2\n0o3\n'" "ranges --octal"
    assert_failure
    assert_output --partial "Error: Wrong input format on line '2'."
    assert_memcheck_ok
}

@test "wrong format sequence 0o1 '0o2 ' 0o3 causes format error" {
    run bash -c "printf '0o1\n0o2 \n0o3\n' | ranges -o"
    assert_failure
    assert_output --partial "Error: Wrong input format on line '0o2 '."

    run_pipe_with_memcheck "printf '0o1\n0o2 \n0o3\n'" "ranges -o"
    assert_failure
    assert_output --partial "Error: Wrong input format on line '0o2 '."
    assert_memcheck_ok

    run bash -c "printf '0o1\n0o2 \n0o3\n' | ranges --octal"
    assert_failure
    assert_output --partial "Error: Wrong input format on line '0o2 '."

    run_pipe_with_memcheck "printf '0o1\n0o2 \n0o3\n'" "ranges --octal"
    assert_failure
    assert_output --partial "Error: Wrong input format on line '0o2 '."
    assert_memcheck_ok
}

@test "wrong format sequence 0o1 '0o1 0o2' 0o3 causes format error" {
    run bash -c "printf '0o1\n0o1 0o2\n0o3\n' | ranges -o"
    assert_failure
    assert_output --partial "Error: Wrong input format on line '0o1 0o2'."

    run_pipe_with_memcheck "printf '0o1\n0o1 0o2\n0o3\n'" "ranges -o"
    assert_failure
    assert_output --partial "Error: Wrong input format on line '0o1 0o2'."
    assert_memcheck_ok

    run bash -c "printf '0o1\n0o1 0o2\n0o3\n' | ranges --octal"
    assert_failure
    assert_output --partial "Error: Wrong input format on line '0o1 0o2'."

    run_pipe_with_memcheck "printf '0o1\n0o1 0o2\n0o3\n'" "ranges --octal"
    assert_failure
    assert_output --partial "Error: Wrong input format on line '0o1 0o2'."
    assert_memcheck_ok
}

@test "overflow sequence 0o777777777777777777777 causes overflow error" {
    run bash -c "printf '0o777777777777777777777\n' | ranges -o"
    assert_failure
    assert_output --partial "Error: Overflow on input line '0o777777777777777777777'."

    run_pipe_with_memcheck "printf '0o777777777777777777777\n'" "ranges -o"
    assert_failure
    assert_output --partial "Error: Overflow on input line '0o777777777777777777777'."
    assert_memcheck_ok

    run bash -c "printf '0o777777777777777777777\n' | ranges --octal"
    assert_failure
    assert_output --partial "Error: Overflow on input line '0o777777777777777777777'."

    run_pipe_with_memcheck "printf '0o777777777777777777777\n'" "ranges --octal"
    assert_failure
    assert_output --partial "Error: Overflow on input line '0o777777777777777777777'."
    assert_memcheck_ok
}

@test "unsorted sequence 0o1 0o2 0o3 0o2 0o7 0o10 0o11 causes unsorted error" {
    run bash -c "printf '0o1\n0o2\n0o3\n0o2\n0o7\n0o10\n0o11\n' | ranges -o"
    assert_failure
    assert_output --partial "Error: Input is not sorted on line '0o2'."

    run_pipe_with_memcheck "printf '0o1\n0o2\n0o3\n0o2\n0o7\n0o10\n0o11\n'" "ranges -o"
    assert_failure
    assert_output --partial "Error: Input is not sorted on line '0o2'."
    assert_memcheck_ok

    run bash -c "printf '0o1\n0o2\n0o3\n0o2\n0o7\n0o10\n0o11\n' | ranges --octal"
    assert_failure
    assert_output --partial "Error: Input is not sorted on line '0o2'."

    run_pipe_with_memcheck "printf '0o1\n0o2\n0o3\n0o2\n0o7\n0o10\n0o11\n'" "ranges --octal"
    assert_failure
    assert_output --partial "Error: Input is not sorted on line '0o2'."
    assert_memcheck_ok
}
