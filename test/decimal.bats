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

@test "single line input" {
    run bash -c "printf '1\n' | ranges"
    assert_success
    assert_output '1 1'
}

@test "test sequence 1 2 3" {
    run bash -c "printf '1\n2\n3\n' | ranges"
    assert_success
    assert_output '1 3'
}

@test "test sequence 1 2 3 7 8 9" {
    run bash -c "printf '1\n2\n3\n7\n8\n9\n' | ranges"
    assert_success
    assert_output "1 3
7 9"
}

@test "test sequence -9 -8 -7 -3 -2 -1" {
    run bash -c "printf -- '-9\n-8\n-7\n-3\n-2\n-1\n' | ranges"
    assert_success
    assert_output "-9 -7
-3 -1"
}

@test "test sequence -5 -4 -3 -1 0 +1 +3 +4 +5" {
    run bash -c "printf -- '-5\n-4\n-3\n-1\n0\n+1\n+3\n+4\n+5\n' | ranges"
    assert_success
    assert_output "-5 -3
-1 1
3 5"
}

# TODO test duplicate numbers
# TODO test wrong input format with different number type or something
# TODO test wrong input format with trailing space
# TODO test underflow
# TODO test overflow
# TODO test unsorted input
