setup() {
    load 'helper/setup'
    _common_setup
}


@test "empty input causes empty output" {
    run bash -c "echo '' | ranges"
    assert_success
    assert_output ''
}

@test "empty input lines cause empty output" {
    run bash -c "printf '\n\n\n' | ranges"
    assert_success
    assert_output ''
}

@test "single line input 1 works" {
    run bash -c "printf '1\n' | ranges"
    assert_success
    assert_output '1 1'
}

@test "trivial sequence 1 2 3 works" {
    run bash -c "printf '1\n2\n3\n' | ranges"
    assert_success
    assert_output '1 3'
}

@test "simple sequence 1 2 3 7 8 9 works" {
    run bash -c "printf '1\n2\n3\n7\n8\n9\n' | ranges"
    assert_success
    assert_output "1 3
7 9"
}

@test "negative number sequence -9 -8 -7 -3 -2 -1 works" {
    run bash -c "printf -- '-9\n-8\n-7\n-3\n-2\n-1\n' | ranges"
    assert_success
    assert_output "-9 -7
-3 -1"
}

@test "partially negative number sequence -5 -4 -3 -1 0 +1 +3 +4 +5 works" {
    run bash -c "printf -- '-5\n-4\n-3\n-1\n0\n+1\n+3\n+4\n+5\n' | ranges"
    assert_success
    assert_output "-5 -3
-1 1
3 5"
}

@test "duplicate number sequence 1 2 2 2 3 works" {
    run bash -c "printf '1\n2\n2\n2\n3\n' | ranges"
    assert_success
    assert_output '1 3'
}

@test "partially negative dumplicate number sequence -5 -4 -4 -3 -1 0 0 0 0 +1 +3 +4 +5 +5 +5 works" {
    run bash -c "printf -- '-5\n-4\n-4\n-3\n-1\n0\n0\n0\n0\n+1\n+3\n+4\n+5\n+5\n+5\n' | ranges"
    assert_success
    assert_output "-5 -3
-1 1
3 5"
}

@test "wrong format sequence 1 0x2 3 causes format error" {
    run bash -c "printf '1\n0x2\n3\n' | ranges"
    assert_failure
    assert_output --partial "Error: Wrong input format on line '0x2'."
}

@test "wrong format sequence 1 '2 ' 3 causes format error" {
    run bash -c "printf '1\n2 \n3\n' | ranges"
    assert_failure
    assert_output --partial "Error: Wrong input format on line '2 '."
}

@test "wrong format sequence 1 '1 2' 3 causes format error" {
    run bash -c "printf '1\n1 2\n3\n' | ranges"
    assert_failure
    assert_output --partial "Error: Wrong input format on line '1 2'."
}

@test "overflow sequence -9223372036854775808 causes underflow error" {
    run bash -c "printf -- '-9223372036854775808\n' | ranges"
    assert_failure
    assert_output --partial "Error: Underflow on input line '-9223372036854775808'."
}

@test "overflow sequence 9223372036854775807 causes overflow error" {
    run bash -c "printf '9223372036854775807\n' | ranges"
    assert_failure
    assert_output --partial "Error: Overflow on input line '9223372036854775807'."
}

@test "unsorted sequence 1 2 3 2 7 8 9 causes unsorted error" {
    run bash -c "printf '1\n2\n3\n2\n7\n8\n9\n' | ranges"
    assert_failure
    assert_output --partial "Error: Input is not sorted on line '2'."
}

@test "partially negative unsorted sequence 0 -1 causes unsorted error" {
    run bash -c "printf '0\n-1\n' | ranges"
    assert_failure
    assert_output --partial "Error: Input is not sorted on line '-1'."
}
