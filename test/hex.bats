setup() {
    load 'helper/setup'
    _common_setup
}


@test "-H leads to 'not implemented error'" {
    run ranges -H
    assert_failure
    assert_output --partial "Not implemented yet"
}

@test "--hex leads to 'not implemented error'" {
    run ranges --hex
    assert_failure
    assert_output --partial "Not implemented yet"
}
