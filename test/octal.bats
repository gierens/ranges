setup() {
    load 'helper/setup'
    _common_setup
}


@test "-o leads to 'not implemented error'" {
    run ranges -o
    assert_failure
    assert_output --partial "Not implemented yet"
}

@test "--octal leads to 'not implemented error'" {
    run ranges --octal
    assert_failure
    assert_output --partial "Not implemented yet"
}
