setup() {
    load 'helper/setup'
    _common_setup
}


@test "-b leads to 'not implemented error'" {
    run ranges -b
    assert_failure
    assert_output --partial "Not implemented yet"
}

@test "--binary leads to 'not implemented error'" {
    run ranges --binary
    assert_failure
    assert_output --partial "Not implemented yet"
}
