setup() {
    load 'helper/setup'
    _common_setup
}


@test "empty input causes empty output with file" {
    echo '' > ranges_test_input_1

    run ranges ranges_test_input_1
    assert_success
    assert_output ''

    run_with_memcheck "ranges ranges_test_input_1"
    assert_success
    assert_memcheck_ok

    rm ranges_test_input_1
}

@test "empty input lines cause empty output with file" {
    printf '\n\n\n' > ranges_test_input_2

    run ranges ranges_test_input_2
    assert_success
    assert_output ''

    run_with_memcheck "ranges ranges_test_input_2"
    assert_success
    assert_memcheck_ok

    rm ranges_test_input_2
}

@test "single line input 1 works with file" {
    printf '1\n' > ranges_test_input_3

    run ranges ranges_test_input_3
    assert_success
    assert_output '1 1'

    run_with_memcheck "ranges ranges_test_input_3"
    assert_success
    assert_output --partial '1 1'
    assert_memcheck_ok

    rm ranges_test_input_3
}

@test "trivial sequence 1 2 3 works with file" {
    printf '1\n2\n3\n' > ranges_test_input_4

    run ranges ranges_test_input_4
    assert_success
    assert_output '1 3'

    run_with_memcheck "ranges ranges_test_input_4"
    assert_success
    assert_output --partial '1 3'
    assert_memcheck_ok

    rm ranges_test_input_4
}

@test "simple sequence 1 2 3 7 8 9 works with file" {
    printf '1\n2\n3\n7\n8\n9\n' > ranges_test_input_5

    run ranges ranges_test_input_5
    assert_success
    assert_output "1 3
7 9"

    run_with_memcheck "ranges ranges_test_input_5"
    assert_success
    assert_output --partial "1 3
7 9"
    assert_memcheck_ok

    rm ranges_test_input_5
}

@test "negative number sequence -9 -8 -7 -3 -2 -1 works with file" {
    printf -- '-9\n-8\n-7\n-3\n-2\n-1\n' > ranges_test_input_6

    run ranges ranges_test_input_6
    assert_success
    assert_output "-9 -7
-3 -1"

    run_with_memcheck "ranges ranges_test_input_6"
    assert_success
    assert_output --partial "-9 -7
-3 -1"
    assert_memcheck_ok

    rm ranges_test_input_6
}

@test "partially negative number sequence -5 -4 -3 -1 0 +1 +3 +4 +5 works with file" {
    printf -- '-5\n-4\n-3\n-1\n0\n+1\n+3\n+4\n+5\n' > ranges_test_input_7

    run ranges ranges_test_input_7
    assert_success
    assert_output "-5 -3
-1 1
3 5"

    run_with_memcheck "ranges ranges_test_input_7"
    assert_success
    assert_output --partial "-5 -3
-1 1
3 5"
    assert_memcheck_ok

    rm ranges_test_input_7
}

@test "duplicate number sequence 1 2 2 2 3 works with file" {
    printf '1\n2\n2\n2\n3\n' > ranges_test_input_8

    run ranges ranges_test_input_8
    assert_success
    assert_output '1 3'

    run_with_memcheck "ranges ranges_test_input_8"
    assert_success
    assert_output --partial '1 3'
    assert_memcheck_ok

    rm ranges_test_input_8
}

@test "partially negative dumplicate number sequence -5 -4 -4 -3 -1 0 0 0 0 +1 +3 +4 +5 +5 +5 works with file" {
    printf -- '-5\n-4\n-4\n-3\n-1\n0\n0\n0\n0\n+1\n+3\n+4\n+5\n+5\n+5\n' > ranges_test_input_9

    run ranges ranges_test_input_9
    assert_success
    assert_output "-5 -3
-1 1
3 5"

    run_with_memcheck "ranges ranges_test_input_9"
    assert_success
    assert_output --partial "-5 -3
-1 1
3 5"
    assert_memcheck_ok

    rm ranges_test_input_9
}

@test "wrong format sequence 1 0x2 3 causes format error with file" {
    printf '1\n0x2\n3\n' > ranges_test_input_10

    run ranges ranges_test_input_10
    assert_failure
    assert_output --partial "Error: Wrong input format on line '0x2'."

    run_with_memcheck "ranges ranges_test_input_10"
    assert_failure
    assert_output --partial "Error: Wrong input format on line '0x2'."
    assert_memcheck_ok

    rm ranges_test_input_10
}

@test "wrong format sequence 1 '2 ' 3 causes format error with file" {
    printf '1\n2 \n3\n' > ranges_test_input_11

    run ranges ranges_test_input_11
    assert_failure
    assert_output --partial "Error: Wrong input format on line '2 '."

    run_with_memcheck "ranges ranges_test_input_11"
    assert_failure
    assert_output --partial "Error: Wrong input format on line '2 '."
    assert_memcheck_ok

    rm ranges_test_input_11
}

@test "wrong format sequence 1 '1 2' 3 causes format error with file" {
    printf '1\n1 2\n3\n' > ranges_test_input_12

    run ranges ranges_test_input_12
    assert_failure
    assert_output --partial "Error: Wrong input format on line '1 2'."

    run_with_memcheck "ranges ranges_test_input_12"
    assert_failure
    assert_output --partial "Error: Wrong input format on line '1 2'."
    assert_memcheck_ok

    rm ranges_test_input_12
}

@test "overflow sequence -9223372036854775808 causes underflow error with file" {
    printf -- '-9223372036854775808\n' > ranges_test_input_13

    run ranges ranges_test_input_13
    assert_failure
    assert_output --partial "Error: Underflow on input line '-9223372036854775808'."

    run_with_memcheck "ranges ranges_test_input_13"
    assert_failure
    assert_output --partial "Error: Underflow on input line '-9223372036854775808'."
    assert_memcheck_ok

    rm ranges_test_input_13
}

@test "overflow sequence 9223372036854775807 causes overflow error with file" {
    printf -- '9223372036854775807\n' > ranges_test_input_14

    run ranges ranges_test_input_14
    assert_failure
    assert_output --partial "Error: Overflow on input line '9223372036854775807'."

    run_with_memcheck "ranges ranges_test_input_14"
    assert_failure
    assert_output --partial "Error: Overflow on input line '9223372036854775807'."
    assert_memcheck_ok

    rm ranges_test_input_14
}

@test "unsorted sequence 1 2 3 2 7 8 9 causes unsorted error with file" {
    printf '1\n2\n3\n2\n7\n8\n9\n' > ranges_test_input_15

    run ranges ranges_test_input_15
    assert_failure
    assert_output --partial "Error: Input is not sorted on line '2'."

    run_with_memcheck "ranges ranges_test_input_15"
    assert_failure
    assert_output --partial "Error: Input is not sorted on line '2'."
    assert_memcheck_ok

    rm ranges_test_input_15
}

@test "partially negative unsorted sequence 0 -1 causes unsorted error with file" {
    printf -- '0\n-1\n' > ranges_test_input_16

    run ranges ranges_test_input_16
    assert_failure
    assert_output --partial "Error: Input is not sorted on line '-1'."

    run_with_memcheck "ranges ranges_test_input_16"
    assert_failure
    assert_output --partial "Error: Input is not sorted on line '-1'."
    assert_memcheck_ok

    rm ranges_test_input_16
}

@test "file without read permission causes 'could not open' error" {
    touch ranges_test_input_17
    chmod -r ranges_test_input_17

    run ranges ranges_test_input_17
    assert_failure
    assert_output --partial "Error: Could not open file 'ranges_test_input_17'."
    assert_output --partial 'Usage: ranges ['
    assert_output --partial "Try 'ranges -h' for more information"

    run_with_memcheck ranges ranges_test_input_17
    assert_failure
    assert_output --partial "Error: Could not open file 'ranges_test_input_17'."
    assert_output --partial 'Usage: ranges ['
    assert_output --partial "Try 'ranges -h' for more information"
    assert_memcheck_ok

    rm ranges_test_input_17
}

@test "non-existent file causes 'could not open' error" {
    run ranges ranges_test_input_18
    assert_failure
    assert_output --partial "Error: 'ranges_test_input_18' is not a regular file or a symlink to one."
    assert_output --partial 'Usage: ranges ['
    assert_output --partial "Try 'ranges -h' for more information"

    run_with_memcheck ranges ranges_test_input_18
    assert_failure
    assert_output --partial "Error: 'ranges_test_input_18' is not a regular file or a symlink to one."
    assert_output --partial 'Usage: ranges ['
    assert_output --partial "Try 'ranges -h' for more information"
    assert_memcheck_ok
}

@test "directory instead of file causes 'not a file' error" {
    mkdir -p ranges_test_input_19

    run ranges ranges_test_input_19
    assert_failure
    assert_output --partial "Error: 'ranges_test_input_19' is not a regular file or a symlink to one."
    assert_output --partial 'Usage: ranges ['
    assert_output --partial "Try 'ranges -h' for more information"

    run_with_memcheck ranges ranges_test_input_19
    assert_failure
    assert_output --partial "Error: 'ranges_test_input_19' is not a regular file or a symlink to one."
    assert_output --partial 'Usage: ranges ['
    assert_output --partial "Try 'ranges -h' for more information"
    assert_memcheck_ok

    rmdir ranges_test_input_19
}

@test "trivial sequence 1 2 3 works with symlink to file" {
    printf '1\n2\n3\n' > ranges_test_input_20
    ln -s ranges_test_input_20 ranges_test_input_20_symlink

    run ranges ranges_test_input_20_symlink
    assert_success
    assert_output '1 3'

    run_with_memcheck ranges ranges_test_input_20_symlink
    assert_success
    assert_output --partial '1 3'
    assert_memcheck_ok

    rm ranges_test_input_20 ranges_test_input_20_symlink
}

@test "symlink to directory causes 'not a file' error" {
    mkdir -p ranges_test_input_21
    ln -s ranges_test_input_21 ranges_test_input_21_symlink

    run ranges ranges_test_input_21_symlink
    assert_failure
    assert_output --partial "Error: 'ranges_test_input_21_symlink' is not a regular file or a symlink to one."
    assert_output --partial 'Usage: ranges ['
    assert_output --partial "Try 'ranges -h' for more information"

    run_with_memcheck ranges ranges_test_input_21_symlink
    assert_failure
    assert_output --partial "Error: 'ranges_test_input_21_symlink' is not a regular file or a symlink to one."
    assert_output --partial 'Usage: ranges ['
    assert_output --partial "Try 'ranges -h' for more information"
    assert_memcheck_ok

    rm ranges_test_input_21_symlink
    rmdir ranges_test_input_21
}
