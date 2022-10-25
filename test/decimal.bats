setup() {
    load 'helper/setup'
    _common_setup
}


@test "empty input causes empty output" {
    run bash -c "echo '' | ranges"
    assert_success
    assert_output ''

    run_pipe_with_memcheck "echo ''" "ranges"
    assert_success
    assert_memcheck_ok
}

@test "empty input lines cause empty output" {
    run bash -c "printf '\n\n\n' | ranges"
    assert_success
    assert_output ''

    run_pipe_with_memcheck "printf '\n\n\n'" "ranges"
    assert_success
    assert_memcheck_ok
}

@test "single line input 1 works" {
    run bash -c "printf '1\n' | ranges"
    assert_success
    assert_output '1 1'

    run_pipe_with_memcheck "printf '1\n'" "ranges"
    assert_success
    assert_output --partial '1 1'
    assert_memcheck_ok
}

@test "trivial sequence 1 2 3 works" {
    run bash -c "printf '1\n2\n3\n' | ranges"
    assert_success
    assert_output '1 3'

    run_pipe_with_memcheck "printf '1\n2\n3\n'" "ranges"
    assert_success
    assert_output --partial '1 3'
    assert_memcheck_ok
}

@test "simple sequence 1 2 3 7 8 9 works" {
    run bash -c "printf '1\n2\n3\n7\n8\n9\n' | ranges"
    assert_success
    assert_output "1 3
7 9"

    run_pipe_with_memcheck "printf '1\n2\n3\n7\n8\n9\n'" "ranges"
    assert_success
    assert_output --partial "1 3
7 9"
    assert_memcheck_ok
}

@test "negative number sequence -9 -8 -7 -3 -2 -1 works" {
    run bash -c "printf -- '-9\n-8\n-7\n-3\n-2\n-1\n' | ranges"
    assert_success
    assert_output "-9 -7
-3 -1"

    run_pipe_with_memcheck "printf -- '-9\n-8\n-7\n-3\n-2\n-1\n'" "ranges"
    assert_success
    assert_output --partial "-9 -7
-3 -1"
    assert_memcheck_ok
}

@test "partially negative number sequence -5 -4 -3 -1 0 +1 +3 +4 +5 works" {
    run bash -c "printf -- '-5\n-4\n-3\n-1\n0\n+1\n+3\n+4\n+5\n' | ranges"
    assert_success
    assert_output "-5 -3
-1 1
3 5"

    run_pipe_with_memcheck "printf -- '-5\n-4\n-3\n-1\n0\n+1\n+3\n+4\n+5\n'" "ranges"
    assert_success
    assert_output --partial "-5 -3
-1 1
3 5"
    assert_memcheck_ok
}

@test "duplicate number sequence 1 2 2 2 3 works" {
    run bash -c "printf '1\n2\n2\n2\n3\n' | ranges"
    assert_success
    assert_output '1 3'

    run_pipe_with_memcheck "printf '1\n2\n2\n2\n3\n'" "ranges"
    assert_success
    assert_output --partial '1 3'
    assert_memcheck_ok
}

@test "partially negative dumplicate number sequence -5 -4 -4 -3 -1 0 0 0 0 +1 +3 +4 +5 +5 +5 works" {
    run bash -c "printf -- '-5\n-4\n-4\n-3\n-1\n0\n0\n0\n0\n+1\n+3\n+4\n+5\n+5\n+5\n' | ranges"
    assert_success
    assert_output "-5 -3
-1 1
3 5"

    run_pipe_with_memcheck "printf -- '-5\n-4\n-4\n-3\n-1\n0\n0\n0\n0\n+1\n+3\n+4\n+5\n+5\n+5\n'" "ranges"
    assert_success
    assert_output --partial "-5 -3
-1 1
3 5"
    assert_memcheck_ok
}

@test "wrong format sequence 1 0x2 3 causes format error" {
    run bash -c "printf '1\n0x2\n3\n' | ranges"
    assert_failure
    assert_output --partial "Error: Wrong input format on line '0x2'."

    run_pipe_with_memcheck "printf '1\n0x2\n3\n'" "ranges"
    assert_failure
    assert_output --partial "Error: Wrong input format on line '0x2'."
    assert_memcheck_ok
}

@test "wrong format sequence 1 '2 ' 3 causes format error" {
    run bash -c "printf '1\n2 \n3\n' | ranges"
    assert_failure
    assert_output --partial "Error: Wrong input format on line '2 '."

    run_pipe_with_memcheck "printf '1\n2 \n3\n'" "ranges"
    assert_failure
    assert_output --partial "Error: Wrong input format on line '2 '."
    assert_memcheck_ok
}

@test "wrong format sequence 1 '1 2' 3 causes format error" {
    run bash -c "printf '1\n1 2\n3\n' | ranges"
    assert_failure
    assert_output --partial "Error: Wrong input format on line '1 2'."

    run_pipe_with_memcheck "printf '1\n1 2\n3\n'" "ranges"
    assert_failure
    assert_output --partial "Error: Wrong input format on line '1 2'."
    assert_memcheck_ok
}

@test "overflow sequence -9223372036854775808 causes underflow error" {
    run bash -c "printf -- '-9223372036854775808\n' | ranges"
    assert_failure
    assert_output --partial "Error: Underflow on input line '-9223372036854775808'."

    run_pipe_with_memcheck "printf -- '-9223372036854775808\n'" "ranges"
    assert_failure
    assert_output --partial "Error: Underflow on input line '-9223372036854775808'."
    assert_memcheck_ok
}

@test "overflow sequence 9223372036854775807 causes overflow error" {
    run bash -c "printf '9223372036854775807\n' | ranges"
    assert_failure
    assert_output --partial "Error: Overflow on input line '9223372036854775807'."

    run_pipe_with_memcheck "printf '9223372036854775807\n'" "ranges"
    assert_failure
    assert_output --partial "Error: Overflow on input line '9223372036854775807'."
    assert_memcheck_ok
}

@test "unsorted sequence 1 2 3 2 7 8 9 causes unsorted error" {
    run bash -c "printf '1\n2\n3\n2\n7\n8\n9\n' | ranges"
    assert_failure
    assert_output --partial "Error: Input is not sorted on line '2'."

    run_pipe_with_memcheck "printf '1\n2\n3\n2\n7\n8\n9\n'" "ranges"
    assert_failure
    assert_output --partial "Error: Input is not sorted on line '2'."
    assert_memcheck_ok
}

@test "partially negative unsorted sequence 0 -1 causes unsorted error" {
    run bash -c "printf '0\n-1\n' | ranges"
    assert_failure
    assert_output --partial "Error: Input is not sorted on line '-1'."

    run_pipe_with_memcheck "printf '0\n-1\n'" "ranges"
    assert_failure
    assert_output --partial "Error: Input is not sorted on line '-1'."
    assert_memcheck_ok
}
