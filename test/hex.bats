setup() {
    load 'helper/setup'
    _common_setup
}


@test "empty input causes empty output" {
    run bash -c "echo '' | ranges -H"
    assert_success
    assert_output ''

    run bash -c "echo '' | ranges --hex"
    assert_success
    assert_output ''
}

@test "empty input lines cause empty output" {
    run bash -c "printf '\n\n\n' | ranges -H"
    assert_success
    assert_output ''

    run bash -c "printf '\n\n\n' | ranges --hex"
    assert_success
    assert_output ''
}

@test "single line input 1 works" {
    run bash -c "printf '0x1\n' | ranges -H"
    assert_success
    assert_output '0x1 0x1'

    run bash -c "printf '0x1\n' | ranges --hex"
    assert_success
    assert_output '0x1 0x1'
}

@test "trivial sequence 1 2 3 works" {
    run bash -c "printf '0x1\n0x2\n0x3\n' | ranges -H"
    assert_success
    assert_output '0x1 0x3'

    run bash -c "printf '0x1\n0x2\n0x3\n' | ranges --hex"
    assert_success
    assert_output '0x1 0x3'
}

@test "simple sequence 0x1 0x2 0x3 0x7 0x8 0x9 works" {
    run bash -c "printf '0x1\n0x2\n0x3\n0x7\n0x8\n0x9\n' | ranges -H"
    assert_success
    assert_output "0x1 0x3
0x7 0x9"

    run bash -c "printf '0x1\n0x2\n0x3\n0x7\n0x8\n0x9\n' | ranges --hex"
    assert_success
    assert_output "0x1 0x3
0x7 0x9"
}

@test "duplicate number sequence 0x1 0x2 0x2 0x2 0x3 works" {
    run bash -c "printf '0x1\n0x2\n0x2\n0x2\n0x3\n' | ranges -H"
    assert_success
    assert_output '0x1 0x3'

    run bash -c "printf '0x1\n0x2\n0x2\n0x2\n0x3\n' | ranges --hex"
    assert_success
    assert_output '0x1 0x3'
}

# TODO
@test "partially negative dumplicate number sequence -5 -4 -4 -3 -1 0 0 0 0 +1 +3 +4 +5 +5 +5 works" {
    run bash -c "printf -- '-5\n-4\n-4\n-3\n-1\n0\n0\n0\n0\n+1\n+3\n+4\n+5\n+5\n+5\n' | ranges"
    assert_success
    assert_output "-5 -3
-1 1
3 5"
}
@test "dumplicate number sequence 0x0 0x0 0x0 0x0 0x1 0x3 0x4 0x5 0x5 0x5 works" {
    run bash -c "printf -- '0x0\n0x0\n0x0\n0x0\n0x1\n0x3\n0x4\n0x5\n0x5\n0x5\n' | ranges -H"
    assert_success
    assert_output "0x0 0x1
0x3 0x5"

    run bash -c "printf -- '0x0\n0x0\n0x0\n0x0\n0x1\n0x3\n0x4\n0x5\n0x5\n0x5\n' | ranges --hex"
    assert_success
    assert_output "0x0 0x1
0x3 0x5"
}

@test "wrong format sequence 0x1 2 0x3 causes format error" {
    run bash -c "printf '0x1\n2\n0x3\n' | ranges -H"
    assert_failure
    assert_output --partial "Error: Wrong input format on line '2'."

    run bash -c "printf '0x1\n2\n0x3\n' | ranges --hex"
    assert_failure
    assert_output --partial "Error: Wrong input format on line '2'."
}

@test "wrong format sequence 0x1 '0x2 ' 0x3 causes format error" {
    run bash -c "printf '0x1\n0x2 \n0x3\n' | ranges -H"
    assert_failure
    assert_output --partial "Error: Wrong input format on line '0x2 '."

    run bash -c "printf '0x1\n0x2 \n0x3\n' | ranges --hex"
    assert_failure
    assert_output --partial "Error: Wrong input format on line '0x2 '."
}

@test "wrong format sequence 0x1 '0x1 0x2' 0x3 causes format error" {
    run bash -c "printf '0x1\n0x1 0x2\n0x3\n' | ranges -H"
    assert_failure
    assert_output --partial "Error: Wrong input format on line '0x1 0x2'."

    run bash -c "printf '0x1\n0x1 0x2\n0x3\n' | ranges --hex"
    assert_failure
    assert_output --partial "Error: Wrong input format on line '0x1 0x2'."
}

@test "overflow sequence 0x7fffffffffffffff causes overflow error" {
    run bash -c "printf '0x7fffffffffffffff\n' | ranges -H"
    assert_failure
    assert_output --partial "Error: Overflow on input line '0x7fffffffffffffff'."

    run bash -c "printf '0x7fffffffffffffff\n' | ranges --hex"
    assert_failure
    assert_output --partial "Error: Overflow on input line '0x7fffffffffffffff'."
}

@test "unsorted sequence 0x1 0x2 0x3 0x2 0x7 0x8 0x9 causes unsorted error" {
    run bash -c "printf '0x1\n0x2\n0x3\n0x2\n0x7\n0x8\n0x9\n' | ranges -H"
    assert_failure
    assert_output --partial "Error: Input is not sorted on line '0x2'."

    run bash -c "printf '0x1\n0x2\n0x3\n0x2\n0x7\n0x8\n0x9\n' | ranges --hex"
    assert_failure
    assert_output --partial "Error: Input is not sorted on line '0x2'."
}
