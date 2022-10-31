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
