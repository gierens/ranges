setup() {
    load 'helper/setup'
    _common_setup
}


@test "-m leads to 'not implemented error'" {
    run ranges -m
    assert_failure
    assert_output --partial "Not implemented yet"
}

@test "--mac leads to 'not implemented error'" {
    run ranges --mac
    assert_failure
    assert_output --partial "Not implemented yet"
}
