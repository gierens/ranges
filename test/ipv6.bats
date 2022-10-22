setup() {
    load 'helper/setup'
    _common_setup
}


@test "-I leads to 'not implemented error'" {
    run ranges -I
    assert_failure
    assert_output --partial "Not implemented yet"
}

@test "--ipv6 leads to 'not implemented error'" {
    run ranges --ipv6
    assert_failure
    assert_output --partial "Not implemented yet"
}
