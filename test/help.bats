setup() {
    load 'helper/setup'
    _common_setup
}


@test "-h returns help text" {
    run ranges -h
    assert_success
    assert_output --partial 'Usage: ranges ['
    assert_output --partial 'Github: https://github.com/gierens/ranges'
}

@test "--help returns help text" {
    run ranges -h
    assert_success
    assert_output --partial 'Usage: ranges ['
    assert_output --partial 'Github: https://github.com/gierens/ranges'
}

@test "-h overwrites other options" {
    run ranges -hH
    assert_success
    assert_output --partial 'Usage: ranges ['
    assert_output --partial 'Github: https://github.com/gierens/ranges'
}

@test "--help overwrites other options" {
    run ranges --help -H
    assert_success
    assert_output --partial 'Usage: ranges ['
    assert_output --partial 'Github: https://github.com/gierens/ranges'
}
