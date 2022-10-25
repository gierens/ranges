setup() {
    load 'helper/setup'
    _common_setup
}


@test "-h returns help text" {
    run ranges -h
    assert_success
    assert_output --partial 'Usage: ranges ['
    assert_output --partial 'issues see the GitHub page: <https://github.com/gierens/ranges>'

    run_with_memcheck ranges -h
    assert_success
    assert_output --partial 'Usage: ranges ['
    assert_output --partial 'issues see the GitHub page: <https://github.com/gierens/ranges>'
    assert_memcheck_ok
}

@test "--help returns help text" {
    run ranges --help
    assert_success
    assert_output --partial 'Usage: ranges ['
    assert_output --partial 'issues see the GitHub page: <https://github.com/gierens/ranges>'

    run_with_memcheck ranges --help
    assert_success
    assert_output --partial 'Usage: ranges ['
    assert_output --partial 'issues see the GitHub page: <https://github.com/gierens/ranges>'
    assert_memcheck_ok
}

@test "-h overwrites other options" {
    run ranges -hH
    assert_success
    assert_output --partial 'Usage: ranges ['
    assert_output --partial 'issues see the GitHub page: <https://github.com/gierens/ranges>'

    run_with_memcheck ranges -hH
    assert_success
    assert_output --partial 'Usage: ranges ['
    assert_output --partial 'issues see the GitHub page: <https://github.com/gierens/ranges>'
    assert_memcheck_ok
}

@test "--help overwrites other options" {
    run ranges --help -H
    assert_success
    assert_output --partial 'Usage: ranges ['
    assert_output --partial 'issues see the GitHub page: <https://github.com/gierens/ranges>'

    run_with_memcheck ranges --help -H
    assert_success
    assert_output --partial 'Usage: ranges ['
    assert_output --partial 'issues see the GitHub page: <https://github.com/gierens/ranges>'
    assert_memcheck_ok
}
