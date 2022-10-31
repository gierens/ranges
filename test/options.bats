setup() {
    load 'helper/setup'
    _common_setup
}


@test "-z leads to 'invalid option error'" {
    run ranges -z
    assert_failure
    assert_output --partial "invalid option -- 'z'"
    assert_output --partial 'Usage: ranges ['
    assert_output --partial "Try 'ranges -h' for more information"

    run_with_memcheck ranges -z
    assert_failure
    assert_output --partial "invalid option -- 'z'"
    assert_output --partial 'Usage: ranges ['
    assert_output --partial "Try 'ranges -h' for more information"
    assert_memcheck_ok
}

@test "-Ho causes 'multible range type error'" {
    run ranges -Ho
    assert_failure
    assert_output --partial 'Error: Only one range type can be specified.'
    assert_output --partial 'Usage: ranges ['
    assert_output --partial "Try 'ranges -h' for more information"

    run_with_memcheck ranges -Ho
    assert_failure
    assert_output --partial 'Error: Only one range type can be specified.'
    assert_output --partial 'Usage: ranges ['
    assert_output --partial "Try 'ranges -h' for more information"
    assert_memcheck_ok
}

@test "trivial sequence 1 2 3 works with stdin redirection" {
    printf '1\n2\n3\n' > ranges_test_stdin_1

    run ranges < ranges_test_stdin_1
    assert_success
    assert_output '1 3'

    run_with_memcheck ranges < ranges_test_stdin_1
    assert_success
    assert_output --partial '1 3'
    assert_memcheck_ok

    rm ranges_test_stdin_1
}

@test "ranges with tty input causes 'no input error'" {
    run ranges < /dev/tty
    assert_failure
    assert_output --partial 'Error: No input given. You must provide a file or pipe!'
    assert_output --partial 'Usage: ranges ['
    assert_output --partial "Try 'ranges -h' for more information"

    run_with_memcheck ranges < /dev/tty
    assert_failure
    assert_output --partial 'Error: No input given. You must provide a file or pipe!'
    assert_output --partial 'Usage: ranges ['
    assert_output --partial "Try 'ranges -h' for more information"
    assert_memcheck_ok
}

@test "'ranges test test' causes 'too many arguments error'" {
    run ranges test test
    assert_failure
    assert_output --partial 'Error: too many arguments'
    assert_output --partial 'Usage: ranges ['
    assert_output --partial "Try 'ranges -h' for more information"

    run_with_memcheck ranges test test
    assert_failure
    assert_output --partial 'Error: too many arguments'
    assert_output --partial 'Usage: ranges ['
    assert_output --partial "Try 'ranges -h' for more information"
    assert_memcheck_ok
}
