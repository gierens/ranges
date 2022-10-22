setup() {
    load 'helper/setup'
    _common_setup
}


@test "-d leads to 'not implemented error'" {
    run ranges -d
    assert_failure
    assert_output --partial "Not implemented yet"
}

@test "--date leads to 'not implemented error'" {
    run ranges --date
    assert_failure
    assert_output --partial "Not implemented yet"
}
