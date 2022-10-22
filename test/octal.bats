setup() {
    load 'helper/setup'
    _common_setup
}


@test "empty input causes empty output" {
    run bash -c "echo '' | ranges -o"
    assert_success
    assert_output ''

    run bash -c "echo '' | ranges --octal"
    assert_success
    assert_output ''
}

@test "empty input lines cause empty output" {
    run bash -c "printf '\n\n\n' | ranges -o"
    assert_success
    assert_output ''

    run bash -c "printf '\n\n\n' | ranges --octal"
    assert_success
    assert_output ''
}

@test "single line input 1 works" {
    run bash -c "printf '0o1\n' | ranges -o"
    assert_success
    assert_output '0o1 0o1'

    run bash -c "printf '0o1\n' | ranges --octal"
    assert_success
    assert_output '0o1 0o1'
}

@test "trivial sequence 0o1 0o2 0o3 works" {
    run bash -c "printf '0o1\n0o2\n0o3\n' | ranges -o"
    assert_success
    assert_output '0o1 0o3'

    run bash -c "printf '0o1\n0o2\n0o3\n' | ranges --octal"
    assert_success
    assert_output '0o1 0o3'
}

@test "simple sequence 0o1 0o2 0o3 0o7 0o10 0o11 works" {
    run bash -c "printf '0o1\n0o2\n0o3\n0o7\n0o10\n0o11\n' | ranges -o"
    assert_success
    assert_output "0o1 0o3
0o7 0o11"

    run bash -c "printf '0o1\n0o2\n0o3\n0o7\n0o10\n0o11\n' | ranges --octal"
    assert_success
    assert_output "0o1 0o3
0o7 0o11"
}

@test "duplicate number sequence 0o1 0o2 0o2 0o2 0o3 works" {
    run bash -c "printf '0o1\n0o2\n0o2\n0o2\n0o3\n' | ranges -o"
    assert_success
    assert_output '0o1 0o3'

    run bash -c "printf '0o1\n0o2\n0o2\n0o2\n0o3\n' | ranges --octal"
    assert_success
    assert_output '0o1 0o3'
}

@test "dumplicate number sequence 0o0 0o0 0o0 0o0 0o1 0o3 0o4 0o5 0o5 0o5 works" {
    run bash -c "printf -- '0o0\n0o0\n0o0\n0o0\n0o1\n0o3\n0o4\n0o5\n0o5\n0o5\n' | ranges -o"
    assert_success
    assert_output "0o0 0o1
0o3 0o5"

    run bash -c "printf -- '0o0\n0o0\n0o0\n0o0\n0o1\n0o3\n0o4\n0o5\n0o5\n0o5\n' | ranges --octal"
    assert_success
    assert_output "0o0 0o1
0o3 0o5"
}

@test "wrong format sequence 0o1 2 0o3 causes format error" {
    run bash -c "printf '0o1\n2\n0o3\n' | ranges -o"
    assert_failure
    assert_output --partial "Error: Wrong input format on line '2'."

    run bash -c "printf '0o1\n2\n0o3\n' | ranges --octal"
    assert_failure
    assert_output --partial "Error: Wrong input format on line '2'."
}

@test "wrong format sequence 0o1 '0o2 ' 0o3 causes format error" {
    run bash -c "printf '0o1\n0o2 \n0o3\n' | ranges -o"
    assert_failure
    assert_output --partial "Error: Wrong input format on line '0o2 '."

    run bash -c "printf '0o1\n0o2 \n0o3\n' | ranges --octal"
    assert_failure
    assert_output --partial "Error: Wrong input format on line '0o2 '."
}

@test "wrong format sequence 0o1 '0o1 0o2' 0o3 causes format error" {
    run bash -c "printf '0o1\n0o1 0o2\n0o3\n' | ranges -o"
    assert_failure
    assert_output --partial "Error: Wrong input format on line '0o1 0o2'."

    run bash -c "printf '0o1\n0o1 0o2\n0o3\n' | ranges --octal"
    assert_failure
    assert_output --partial "Error: Wrong input format on line '0o1 0o2'."
}

@test "overflow sequence 0o777777777777777777777 causes overflow error" {
    run bash -c "printf '0o777777777777777777777\n' | ranges -o"
    assert_failure
    assert_output --partial "Error: Overflow on input line '0o777777777777777777777'."

    run bash -c "printf '0o777777777777777777777\n' | ranges --octal"
    assert_failure
    assert_output --partial "Error: Overflow on input line '0o777777777777777777777'."
}

@test "unsorted sequence 0o1 0o2 0o3 0o2 0o7 0o10 0o11 causes unsorted error" {
    run bash -c "printf '0o1\n0o2\n0o3\n0o2\n0o7\n0o10\n0o11\n' | ranges -o"
    assert_failure
    assert_output --partial "Error: Input is not sorted on line '0o2'."

    run bash -c "printf '0o1\n0o2\n0o3\n0o2\n0o7\n0o10\n0o11\n' | ranges --octal"
    assert_failure
    assert_output --partial "Error: Input is not sorted on line '0o2'."
}
