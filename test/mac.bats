setup() {
    load 'helper/setup'
    _common_setup
}


@test "empty input causes empty output" {
    run bash -c "echo '' | ranges -m"
    assert_success
    assert_output ''

    run_pipe_with_memcheck "echo ''" "ranges -m"
    assert_success
    assert_memcheck_ok

    run bash -c "echo '' | ranges --mac"
    assert_success
    assert_output ''

    run_pipe_with_memcheck "echo ''" "ranges --mac"
    assert_success
    assert_memcheck_ok
}

@test "empty input lines cause empty output" {
    run bash -c "printf '\n\n\n' | ranges -m"
    assert_success
    assert_output ''

    run_pipe_with_memcheck "printf '\n\n\n'" "ranges -m"
    assert_success
    assert_memcheck_ok

    run bash -c "printf '\n\n\n' | ranges --mac"
    assert_success
    assert_output ''

    run_pipe_with_memcheck "printf '\n\n\n'" "ranges --mac"
    assert_success
    assert_memcheck_ok
}

@test "single line input 00:00:00:00:00:01 works" {
    run bash -c "printf '00:00:00:00:00:01\n' | ranges -m"
    assert_success
    assert_output '00:00:00:00:00:01 00:00:00:00:00:01'

    run_pipe_with_memcheck "printf '00:00:00:00:00:01\n'" "ranges -m"
    assert_success
    assert_output --partial '00:00:00:00:00:01 00:00:00:00:00:01'
    assert_memcheck_ok

    run bash -c "printf '00:00:00:00:00:01\n' | ranges --mac"
    assert_success
    assert_output '00:00:00:00:00:01 00:00:00:00:00:01'

    run_pipe_with_memcheck "printf '00:00:00:00:00:01\n'" "ranges --mac"
    assert_success
    assert_output --partial '00:00:00:00:00:01 00:00:00:00:00:01'
    assert_memcheck_ok
}

@test "trivial sequence 00:00:00:00:00:01 00:00:00:00:00:02 00:00:00:00:00:03 works" {
    run bash -c "printf '00:00:00:00:00:01\n00:00:00:00:00:02\n00:00:00:00:00:03\n' | ranges -m"
    assert_success
    assert_output '00:00:00:00:00:01 00:00:00:00:00:03'

    run_pipe_with_memcheck "printf '00:00:00:00:00:01\n00:00:00:00:00:02\n00:00:00:00:00:03\n'" "ranges -m"
    assert_success
    assert_output --partial '00:00:00:00:00:01 00:00:00:00:00:03'
    assert_memcheck_ok

    run bash -c "printf '00:00:00:00:00:01\n00:00:00:00:00:02\n00:00:00:00:00:03\n' | ranges --mac"
    assert_success
    assert_output '00:00:00:00:00:01 00:00:00:00:00:03'

    run_pipe_with_memcheck "printf '00:00:00:00:00:01\n00:00:00:00:00:02\n00:00:00:00:00:03\n'" "ranges --mac"
    assert_success
    assert_output --partial '00:00:00:00:00:01 00:00:00:00:00:03'
    assert_memcheck_ok
}

@test "simple sequence 00:00:00:00:00:01 00:00:00:00:00:02 00:00:00:00:00:03 00:00:00:00:00:07 00:00:00:00:00:08 00:00:00:00:00:09 works" {
    run bash -c "printf '\n00:00:00:00:00:01\n00:00:00:00:00:02\n00:00:00:00:00:03\n00:00:00:00:00:07\n00:00:00:00:00:08\n00:00:00:00:00:09\n' | ranges -m"
    assert_success
    assert_output "00:00:00:00:00:01 00:00:00:00:00:03
00:00:00:00:00:07 00:00:00:00:00:09"

    run_pipe_with_memcheck "printf '\n00:00:00:00:00:01\n00:00:00:00:00:02\n00:00:00:00:00:03\n00:00:00:00:00:07\n00:00:00:00:00:08\n00:00:00:00:00:09\n'" "ranges -m"
    assert_success
    assert_output --partial "00:00:00:00:00:01 00:00:00:00:00:03
00:00:00:00:00:07 00:00:00:00:00:09"
    assert_memcheck_ok

    run bash -c "printf '\n00:00:00:00:00:01\n00:00:00:00:00:02\n00:00:00:00:00:03\n00:00:00:00:00:07\n00:00:00:00:00:08\n00:00:00:00:00:09\n' | ranges --mac"
    assert_success
    assert_output "00:00:00:00:00:01 00:00:00:00:00:03
00:00:00:00:00:07 00:00:00:00:00:09"

    run_pipe_with_memcheck "printf '\n00:00:00:00:00:01\n00:00:00:00:00:02\n00:00:00:00:00:03\n00:00:00:00:00:07\n00:00:00:00:00:08\n00:00:00:00:00:09\n'" "ranges --mac"
    assert_success
    assert_output --partial "00:00:00:00:00:01 00:00:00:00:00:03
00:00:00:00:00:07 00:00:00:00:00:09"
    assert_memcheck_ok
}

@test "duplicate mac sequence 00:00:00:00:00:01 00:00:00:00:00:02 00:00:00:00:00:02 00:00:00:00:00:02 00:00:00:00:00:03 works" {
    run bash -c "printf '00:00:00:00:00:01\n00:00:00:00:00:02\n00:00:00:00:00:02\n00:00:00:00:00:02\n00:00:00:00:00:03\n' | ranges -m"
    assert_success
    assert_output '00:00:00:00:00:01 00:00:00:00:00:03'

    run_pipe_with_memcheck "printf '00:00:00:00:00:01\n00:00:00:00:00:02\n00:00:00:00:00:02\n00:00:00:00:00:02\n00:00:00:00:00:03\n'" "ranges -m"
    assert_success
    assert_output --partial '00:00:00:00:00:01 00:00:00:00:00:03'
    assert_memcheck_ok

    run bash -c "printf '00:00:00:00:00:01\n00:00:00:00:00:02\n00:00:00:00:00:02\n00:00:00:00:00:02\n00:00:00:00:00:03\n' | ranges --mac"
    assert_success
    assert_output '00:00:00:00:00:01 00:00:00:00:00:03'

    run_pipe_with_memcheck "printf '00:00:00:00:00:01\n00:00:00:00:00:02\n00:00:00:00:00:02\n00:00:00:00:00:02\n00:00:00:00:00:03\n'" "ranges --mac"
    assert_success
    assert_output --partial '00:00:00:00:00:01 00:00:00:00:00:03'
    assert_memcheck_ok
}

@test "duplicate mac sequence 00:00:00:00:00:00 00:00:00:00:00:00 00:00:00:00:00:00 00:00:00:00:00:00 00:00:00:00:00:01 00:00:00:00:00:03 00:00:00:00:00:04 00:00:00:00:00:05 00:00:00:00:00:05 00:00:00:00:00:05 works" {
    run bash -c "printf -- '00:00:00:00:00:00\n00:00:00:00:00:00\n00:00:00:00:00:00\n00:00:00:00:00:00\n00:00:00:00:00:01\n00:00:00:00:00:03\n00:00:00:00:00:04\n00:00:00:00:00:05\n00:00:00:00:00:05\n00:00:00:00:00:05\n' | ranges -m"
    assert_success
    assert_output "00:00:00:00:00:00 00:00:00:00:00:01
00:00:00:00:00:03 00:00:00:00:00:05"

    run_pipe_with_memcheck "printf -- '00:00:00:00:00:00\n00:00:00:00:00:00\n00:00:00:00:00:00\n00:00:00:00:00:00\n00:00:00:00:00:01\n00:00:00:00:00:03\n00:00:00:00:00:04\n00:00:00:00:00:05\n00:00:00:00:00:05\n00:00:00:00:00:05\n'" "ranges -m"
    assert_success
    assert_output --partial "00:00:00:00:00:00 00:00:00:00:00:01
00:00:00:00:00:03 00:00:00:00:00:05"
    assert_memcheck_ok

    run bash -c "printf -- '00:00:00:00:00:00\n00:00:00:00:00:00\n00:00:00:00:00:00\n00:00:00:00:00:00\n00:00:00:00:00:01\n00:00:00:00:00:03\n00:00:00:00:00:04\n00:00:00:00:00:05\n00:00:00:00:00:05\n00:00:00:00:00:05\n' | ranges --mac"
    assert_success
    assert_output "00:00:00:00:00:00 00:00:00:00:00:01
00:00:00:00:00:03 00:00:00:00:00:05"

    run_pipe_with_memcheck "printf -- '00:00:00:00:00:00\n00:00:00:00:00:00\n00:00:00:00:00:00\n00:00:00:00:00:00\n00:00:00:00:00:01\n00:00:00:00:00:03\n00:00:00:00:00:04\n00:00:00:00:00:05\n00:00:00:00:00:05\n00:00:00:00:00:05\n'" "ranges --mac"
    assert_success
    assert_output --partial "00:00:00:00:00:00 00:00:00:00:00:01
00:00:00:00:00:03 00:00:00:00:00:05"
    assert_memcheck_ok
}

@test "wrong format sequence 00:00:00:00:00:01 00-00-00-00-00-02 00:00:00:00:00:03 causes format error" {
    run bash -c "printf '00:00:00:00:00:01\n00-00-00-00-00-02\n00:00:00:00:00:03\n' | ranges -m"
    assert_failure
    assert_output --partial "Error: Wrong input format on line '00-00-00-00-00-02'."

    run_pipe_with_memcheck "printf '00:00:00:00:00:01\n00-00-00-00-00-02\n00:00:00:00:00:03\n'" "ranges -m"
    assert_failure
    assert_output --partial "Error: Wrong input format on line '00-00-00-00-00-02'."
    assert_memcheck_ok

    run bash -c "printf '00:00:00:00:00:01\n00-00-00-00-00-02\n00:00:00:00:00:03\n' | ranges --mac"
    assert_failure
    assert_output --partial "Error: Wrong input format on line '00-00-00-00-00-02'."

    run_pipe_with_memcheck "printf '00:00:00:00:00:01\n00-00-00-00-00-02\n00:00:00:00:00:03\n'" "ranges --mac"
    assert_failure
    assert_output --partial "Error: Wrong input format on line '00-00-00-00-00-02'."
    assert_memcheck_ok
}

@test "wrong format sequence 00:00:00:00:00:01 '00:00:00:00:00:02 ' 00:00:00:00:00:03 causes format error" {
    run bash -c "printf '00:00:00:00:00:01\n00:00:00:00:00:02 \n00:00:00:00:00:03\n' | ranges -m"
    assert_failure
    assert_output --partial "Error: Wrong input format on line '00:00:00:00:00:02 '."

    run_pipe_with_memcheck "printf '00:00:00:00:00:01\n00:00:00:00:00:02 \n00:00:00:00:00:03\n'" "ranges -m"
    assert_failure
    assert_output --partial "Error: Wrong input format on line '00:00:00:00:00:02 '."
    assert_memcheck_ok

    run bash -c "printf '00:00:00:00:00:01\n00:00:00:00:00:02 \n00:00:00:00:00:03\n' | ranges --mac"
    assert_failure
    assert_output --partial "Error: Wrong input format on line '00:00:00:00:00:02 '."

    run_pipe_with_memcheck "printf '00:00:00:00:00:01\n00:00:00:00:00:02 \n00:00:00:00:00:03\n'" "ranges --mac"
    assert_failure
    assert_output --partial "Error: Wrong input format on line '00:00:00:00:00:02 '."
    assert_memcheck_ok
}

@test "wrong format sequence 00:00:00:00:00:01 '00:00:00:00:00:01 00:00:00:00:00:02' 00:00:00:00:00:03 causes format error" {
    run bash -c "printf '00:00:00:00:00:01\n00:00:00:00:00:01 00:00:00:00:00:02\n00:00:00:00:00:03\n' | ranges -m"
    assert_failure
    assert_output --partial "Error: Wrong input format on line '00:00:00:00:00:01 00:00:00:00:00:02'."

    run_pipe_with_memcheck "printf '00:00:00:00:00:01\n00:00:00:00:00:01 00:00:00:00:00:02\n00:00:00:00:00:03\n'" "ranges -m"
    assert_failure
    assert_output --partial "Error: Wrong input format on line '00:00:00:00:00:01 00:00:00:00:00:02'."
    assert_memcheck_ok

    run bash -c "printf '00:00:00:00:00:01\n00:00:00:00:00:01 00:00:00:00:00:02\n00:00:00:00:00:03\n' | ranges --mac"
    assert_failure
    assert_output --partial "Error: Wrong input format on line '00:00:00:00:00:01 00:00:00:00:00:02'."

    run_pipe_with_memcheck "printf '00:00:00:00:00:01\n00:00:00:00:00:01 00:00:00:00:00:02\n00:00:00:00:00:03\n'" "ranges --mac"
    assert_failure
    assert_output --partial "Error: Wrong input format on line '00:00:00:00:00:01 00:00:00:00:00:02'."
    assert_memcheck_ok
}

@test "unsorted sequence 00:00:00:00:00:01 00:00:00:00:00:02 00:00:00:00:00:03 00:00:00:00:00:02 00:00:00:00:00:07 00:00:00:00:00:08 00:00:00:00:00:09 causes unsorted error" {
    run bash -c "printf '00:00:00:00:00:01\n00:00:00:00:00:02\n00:00:00:00:00:03\n00:00:00:00:00:02\n00:00:00:00:00:07\n00:00:00:00:00:08\n00:00:00:00:00:09\n' | ranges -m"
    assert_failure
    assert_output --partial "Error: Input is not sorted on line '00:00:00:00:00:02'."

    run_pipe_with_memcheck "printf '00:00:00:00:00:01\n00:00:00:00:00:02\n00:00:00:00:00:03\n00:00:00:00:00:02\n00:00:00:00:00:07\n00:00:00:00:00:08\n00:00:00:00:00:09\n'" "ranges -m"
    assert_failure
    assert_output --partial "Error: Input is not sorted on line '00:00:00:00:00:02'."
    assert_memcheck_ok

    run bash -c "printf '00:00:00:00:00:01\n00:00:00:00:00:02\n00:00:00:00:00:03\n00:00:00:00:00:02\n00:00:00:00:00:07\n00:00:00:00:00:08\n00:00:00:00:00:09\n' | ranges --mac"
    assert_failure
    assert_output --partial "Error: Input is not sorted on line '00:00:00:00:00:02'."

    run_pipe_with_memcheck "printf '00:00:00:00:00:01\n00:00:00:00:00:02\n00:00:00:00:00:03\n00:00:00:00:00:02\n00:00:00:00:00:07\n00:00:00:00:00:08\n00:00:00:00:00:09\n'" "ranges --mac"
    assert_failure
    assert_output --partial "Error: Input is not sorted on line '00:00:00:00:00:02'."
    assert_memcheck_ok
}
