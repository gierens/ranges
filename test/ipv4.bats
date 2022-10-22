setup() {
    load 'helper/setup'
    _common_setup
}


@test "-i leads to 'not implemented error'" {
    run ranges -i
    assert_failure
    assert_output --partial "Not implemented yet"
}

@test "--ipv4 leads to 'not implemented error'" {
    run ranges --ipv4
    assert_failure
    assert_output --partial "Not implemented yet"
}
