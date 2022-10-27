setup() {
    load 'helper/setup'
    _common_setup
}

# decimal number ranges

@test "wrong format sequence 1 0x2 3 works with force" {
    run bash -c "printf '1\n0x2\n3\n' | ranges -f"
    assert_success
    assert_output "1 1
3 3"

    run_pipe_with_memcheck "printf '1\n0x2\n3\n'" "ranges -f"
    assert_success
    assert_output --partial "1 1
3 3"

    assert_memcheck_ok
    run bash -c "printf '1\n0x2\n3\n' | ranges --force"
    assert_success
    assert_output "1 1
3 3"

    run_pipe_with_memcheck "printf '1\n0x2\n3\n'" "ranges --force"
    assert_success
    assert_output --partial "1 1
3 3"
    assert_memcheck_ok
}

@test "wrong format sequence 1 '2 ' 3 works with force" {
    run bash -c "printf '1\n2 \n3\n' | ranges -f"
    assert_success
    assert_output "1 1
3 3"

    run_pipe_with_memcheck "printf '1\n2 \n3\n'" "ranges -f"
    assert_success
    assert_output --partial "1 1
3 3"
    assert_memcheck_ok

    run bash -c "printf '1\n2 \n3\n' | ranges --force"
    assert_success
    assert_output --partial "1 1
3 3"

    run_pipe_with_memcheck "printf '1\n2 \n3\n'" "ranges --force"
    assert_success
    assert_output --partial "1 1
3 3"
    assert_memcheck_ok
}

@test "wrong format sequence 1 '1 2' 3 works with force" {
    run bash -c "printf '1\n1 2\n3\n' | ranges -f"
    assert_success
    assert_output "1 1
3 3"

    run_pipe_with_memcheck "printf '1\n1 2\n3\n'" "ranges -f"
    assert_success
    assert_output --partial "1 1
3 3"
    assert_memcheck_ok

    run bash -c "printf '1\n1 2\n3\n' | ranges --force"
    assert_success
    assert_output "1 1
3 3"

    run_pipe_with_memcheck "printf '1\n1 2\n3\n'" "ranges --force"
    assert_success
    assert_output --partial "1 1
3 3"
    assert_memcheck_ok
}

@test "overflow sequence -9223372036854775808 works with force" {
    run bash -c "printf -- '-9223372036854775808\n' | ranges -f"
    assert_success
    assert_output ''

    run_pipe_with_memcheck "printf -- '-9223372036854775808\n'" "ranges -f"
    assert_success
    assert_memcheck_ok

    run bash -c "printf -- '-9223372036854775808\n' | ranges --force"
    assert_success
    assert_output ''

    run_pipe_with_memcheck "printf -- '-9223372036854775808\n'" "ranges --force"
    assert_success
    assert_memcheck_ok
}

@test "overflow sequence 9223372036854775807 works with force" {
    run bash -c "printf '9223372036854775807\n' | ranges --force"
    assert_success
    assert_output ''

    run_pipe_with_memcheck "printf '9223372036854775807\n'" "ranges --force"
    assert_success
    assert_memcheck_ok

    run bash -c "printf '9223372036854775807\n' | ranges --force"
    assert_success
    assert_output ''

    run_pipe_with_memcheck "printf '9223372036854775807\n'" "ranges --force"
    assert_success
    assert_memcheck_ok
}

@test "unsorted sequence 1 2 3 2 7 8 9 causes unsorted error with force" {
    run bash -c "printf '1\n2\n3\n2\n7\n8\n9\n' | ranges -f"
    assert_failure
    assert_output --partial "Error: Input is not sorted on line '2'."

    run_pipe_with_memcheck "printf '1\n2\n3\n2\n7\n8\n9\n'" "ranges -f"
    assert_failure
    assert_output --partial "Error: Input is not sorted on line '2'."
    assert_memcheck_ok

    run bash -c "printf '1\n2\n3\n2\n7\n8\n9\n' | ranges --force"
    assert_failure
    assert_output --partial "Error: Input is not sorted on line '2'."

    run_pipe_with_memcheck "printf '1\n2\n3\n2\n7\n8\n9\n'" "ranges --force"
    assert_failure
    assert_output --partial "Error: Input is not sorted on line '2'."
    assert_memcheck_ok
}

@test "partially negative unsorted sequence 0 -1 causes unsorted error with force" {
    run bash -c "printf '0\n-1\n' | ranges -f"
    assert_failure
    assert_output --partial "Error: Input is not sorted on line '-1'."

    run_pipe_with_memcheck "printf '0\n-1\n'" "ranges -f"
    assert_failure
    assert_output --partial "Error: Input is not sorted on line '-1'."
    assert_memcheck_ok

    run bash -c "printf '0\n-1\n' | ranges --force"
    assert_failure
    assert_output --partial "Error: Input is not sorted on line '-1'."

    run_pipe_with_memcheck "printf '0\n-1\n'" "ranges --force"
    assert_failure
    assert_output --partial "Error: Input is not sorted on line '-1'."
    assert_memcheck_ok
}

# binary number ranges

@test "wrong format sequence 0b1 2 0b11 works with force" {
    run bash -c "printf '0b1\n2\n0b11\n' | ranges --binary -f"
    assert_success
    assert_output '0b1 0b1
0b11 0b11'

    run_pipe_with_memcheck "printf '0b1\n2\n0b11\n'" "ranges --binary -f"
    assert_success
    assert_output --partial '0b1 0b1
0b11 0b11'
    assert_memcheck_ok

    run bash -c "printf '0b1\n2\n0b11\n' | ranges --binary --force"
    assert_success
    assert_output '0b1 0b1
0b11 0b11'

    run_pipe_with_memcheck "printf '0b1\n2\n0b11\n'" "ranges --binary --force"
    assert_success
    assert_output --partial '0b1 0b1
0b11 0b11'
    assert_memcheck_ok
}

@test "wrong format sequence 0b1 '0b10 ' 0b11 works with force" {
    run bash -c "printf '0b1\n0b10 \n0b11\n' | ranges --binary -f"
    assert_success
    assert_output '0b1 0b1
0b11 0b11'

    run_pipe_with_memcheck "printf '0b1\n0b10 \n0b11\n'" "ranges --binary -f"
    assert_success
    assert_output --partial '0b1 0b1
0b11 0b11'
    assert_memcheck_ok

    run bash -c "printf '0b1\n0b10 \n0b11\n' | ranges --binary --force"
    assert_success
    assert_output '0b1 0b1
0b11 0b11'

    run_pipe_with_memcheck "printf '0b1\n0b10 \n0b11\n'" "ranges --binary --force"
    assert_success
    assert_output --partial '0b1 0b1
0b11 0b11'
    assert_memcheck_ok
}

@test "wrong format sequence 0b1 '0b1 0b10' 0b11 works with force" {
    run bash -c "printf '0b1\n0b1 0b10\n0b11\n' | ranges --binary -f"
    assert_success
    assert_output '0b1 0b1
0b11 0b11'

    run_pipe_with_memcheck "printf '0b1\n0b1 0b10\n0b11\n'" "ranges --binary -f"
    assert_success
    assert_output --partial '0b1 0b1
0b11 0b11'
    assert_memcheck_ok

    run bash -c "printf '0b1\n0b1 0b10\n0b11\n' | ranges --binary --force"
    assert_success
    assert_output '0b1 0b1
0b11 0b11'

    run_pipe_with_memcheck "printf '0b1\n0b1 0b10\n0b11\n'" "ranges --binary --force"
    assert_success
    assert_output --partial '0b1 0b1
0b11 0b11'
    assert_memcheck_ok
}

@test "overflow sequence 0b1000000000000000000000000000000000000000000000000000000000000000 works with force" {
    run bash -c "printf '0b1000000000000000000000000000000000000000000000000000000000000000\n' | ranges --binary -f"
    assert_success
    assert_output ''

    run_pipe_with_memcheck "printf '0b1000000000000000000000000000000000000000000000000000000000000000\n'" "ranges --binary -f"
    assert_success
    assert_memcheck_ok

    run bash -c "printf '0b1000000000000000000000000000000000000000000000000000000000000000\n' | ranges --binary --force"
    assert_success
    assert_output ''

    run_pipe_with_memcheck "printf '0b1000000000000000000000000000000000000000000000000000000000000000\n'" "ranges --binary --force"
    assert_success
    assert_memcheck_ok
}

@test "unsorted sequence 0b1 0b10 0b11 0b10 0b111 0b1000 0b1001 causes unsorted error with force" {
    run bash -c "printf '0b1\n0b10\n0b11\n0b10\n0b111\n0b1000\n0b1001\n' | ranges --binary -f"
    assert_failure
    assert_output --partial "Error: Input is not sorted on line '0b10'."

    run_pipe_with_memcheck "printf '0b1\n0b10\n0b11\n0b10\n0b111\n0b1000\n0b1001\n'" "ranges --binary -f"
    assert_failure
    assert_output --partial "Error: Input is not sorted on line '0b10'."
    assert_memcheck_ok

    run bash -c "printf '0b1\n0b10\n0b11\n0b10\n0b111\n0b1000\n0b1001\n' | ranges --binary --force"
    assert_failure
    assert_output --partial "Error: Input is not sorted on line '0b10'."

    run_pipe_with_memcheck "printf '0b1\n0b10\n0b11\n0b10\n0b111\n0b1000\n0b1001\n'" "ranges --binary --force"
    assert_failure
    assert_output --partial "Error: Input is not sorted on line '0b10'."
    assert_memcheck_ok
}

# octal number ranges

@test "wrong format sequence 0o1 2 0o3 works with force" {
    run bash -c "printf '0o1\n2\n0o3\n' | ranges --octal -f"
    assert_success
    assert_output '0o1 0o1
0o3 0o3'

    run_pipe_with_memcheck "printf '0o1\n2\n0o3\n'" "ranges --octal -f"
    assert_success
    assert_output --partial '0o1 0o1
0o3 0o3'
    assert_memcheck_ok

    run bash -c "printf '0o1\n2\n0o3\n' | ranges --octal --force"
    assert_success
    assert_output '0o1 0o1
0o3 0o3'

    run_pipe_with_memcheck "printf '0o1\n2\n0o3\n'" "ranges --octal --force"
    assert_success
    assert_output --partial '0o1 0o1
0o3 0o3'
    assert_memcheck_ok
}

@test "wrong format sequence 0o1 '0o2 ' 0o3 works with force" {
    run bash -c "printf '0o1\n0o2 \n0o3\n' | ranges --octal -f"
    assert_success
    assert_output '0o1 0o1
0o3 0o3'

    run_pipe_with_memcheck "printf '0o1\n0o2 \n0o3\n'" "ranges --octal -f"
    assert_success
    assert_output --partial '0o1 0o1
0o3 0o3'
    assert_memcheck_ok

    run bash -c "printf '0o1\n0o2 \n0o3\n' | ranges --octal --force"
    assert_success
    assert_output '0o1 0o1
0o3 0o3'

    run_pipe_with_memcheck "printf '0o1\n0o2 \n0o3\n'" "ranges --octal --force"
    assert_success
    assert_output --partial '0o1 0o1
0o3 0o3'
    assert_memcheck_ok
}

@test "wrong format sequence 0o1 '0o1 0o2' 0o3 works with force" {
    run bash -c "printf '0o1\n0o1 0o2\n0o3\n' | ranges --octal -f"
    assert_success
    assert_output '0o1 0o1
0o3 0o3'

    run_pipe_with_memcheck "printf '0o1\n0o1 0o2\n0o3\n'" "ranges --octal -f"
    assert_success
    assert_output --partial '0o1 0o1
0o3 0o3'
    assert_memcheck_ok

    run bash -c "printf '0o1\n0o1 0o2\n0o3\n' | ranges --octal --force"
    assert_success
    assert_output '0o1 0o1
0o3 0o3'

    run_pipe_with_memcheck "printf '0o1\n0o1 0o2\n0o3\n'" "ranges --octal --force"
    assert_success
    assert_output --partial '0o1 0o1
0o3 0o3'
    assert_memcheck_ok
}

@test "overflow sequence 0o777777777777777777777 works with force" {
    run bash -c "printf '0o777777777777777777777\n' | ranges --octal -f"
    assert_success
    assert_output ''

    run_pipe_with_memcheck "printf '0o777777777777777777777\n'" "ranges --octal -f"
    assert_success
    assert_memcheck_ok

    run bash -c "printf '0o777777777777777777777\n' | ranges --octal --force"
    assert_success
    assert_output ''

    run_pipe_with_memcheck "printf '0o777777777777777777777\n'" "ranges --octal --force"
    assert_success
    assert_memcheck_ok
}

@test "unsorted sequence 0o1 0o2 0o3 0o2 0o7 0o10 0o11 causes unsorted error with force" {
    run bash -c "printf '0o1\n0o2\n0o3\n0o2\n0o7\n0o10\n0o11\n' | ranges --octal -f"
    assert_failure
    assert_output --partial "Error: Input is not sorted on line '0o2'."

    run_pipe_with_memcheck "printf '0o1\n0o2\n0o3\n0o2\n0o7\n0o10\n0o11\n'" "ranges --octal -f"
    assert_failure
    assert_output --partial "Error: Input is not sorted on line '0o2'."
    assert_memcheck_ok

    run bash -c "printf '0o1\n0o2\n0o3\n0o2\n0o7\n0o10\n0o11\n' | ranges --octal --force"
    assert_failure
    assert_output --partial "Error: Input is not sorted on line '0o2'."

    run_pipe_with_memcheck "printf '0o1\n0o2\n0o3\n0o2\n0o7\n0o10\n0o11\n'" "ranges --octal --force"
    assert_failure
    assert_output --partial "Error: Input is not sorted on line '0o2'."
    assert_memcheck_ok
}

# hexadecimal number ranges

@test "wrong format sequence 0x1 2 0x3 works with force" {
    run bash -c "printf '0x1\n2\n0x3\n' | ranges --hex -f"
    assert_success
    assert_output '0x1 0x1
0x3 0x3'

    run_pipe_with_memcheck "printf '0x1\n2\n0x3\n'" "ranges --hex -f"
    assert_success
    assert_output --partial '0x1 0x1
0x3 0x3'
    assert_memcheck_ok

    run bash -c "printf '0x1\n2\n0x3\n' | ranges --hex --force"
    assert_success
    assert_output '0x1 0x1
0x3 0x3'

    run_pipe_with_memcheck "printf '0x1\n2\n0x3\n'" "ranges --hex --force"
    assert_success
    assert_output --partial '0x1 0x1
0x3 0x3'
    assert_memcheck_ok
}

@test "wrong format sequence 0x1 '0x2 ' 0x3 works with force" {
    run bash -c "printf '0x1\n0x2 \n0x3\n' | ranges --hex -f"
    assert_success
    assert_output '0x1 0x1
0x3 0x3'

    run_pipe_with_memcheck "printf '0x1\n0x2 \n0x3\n'" "ranges --hex -f"
    assert_success
    assert_output --partial '0x1 0x1
0x3 0x3'
    assert_memcheck_ok

    run bash -c "printf '0x1\n0x2 \n0x3\n' | ranges --hex --force"
    assert_success
    assert_output '0x1 0x1
0x3 0x3'

    run_pipe_with_memcheck "printf '0x1\n0x2 \n0x3\n'" "ranges --hex --force"
    assert_success
    assert_output --partial '0x1 0x1
0x3 0x3'
    assert_memcheck_ok
}

@test "wrong format sequence 0x1 '0x1 0x2' 0x3 works with force" {
    run bash -c "printf '0x1\n0x1 0x2\n0x3\n' | ranges --hex -f"
    assert_success
    assert_output '0x1 0x1
0x3 0x3'

    run_pipe_with_memcheck "printf '0x1\n0x1 0x2\n0x3\n'" "ranges --hex -f"
    assert_success
    assert_output --partial '0x1 0x1
0x3 0x3'
    assert_memcheck_ok

    run bash -c "printf '0x1\n0x1 0x2\n0x3\n' | ranges --hex --force"
    assert_success
    assert_output '0x1 0x1
0x3 0x3'

    run_pipe_with_memcheck "printf '0x1\n0x1 0x2\n0x3\n'" "ranges --hex --force"
    assert_success
    assert_output --partial '0x1 0x1
0x3 0x3'
    assert_memcheck_ok
}

@test "overflow sequence 0x7fffffffffffffff works with force" {
    run bash -c "printf '0x7fffffffffffffff\n' | ranges --hex -f"
    assert_success
    assert_output ''

    run_pipe_with_memcheck "printf '0x7fffffffffffffff\n'" "ranges --hex -f"
    assert_success
    assert_memcheck_ok

    run bash -c "printf '0x7fffffffffffffff\n' | ranges --hex --force"
    assert_success
    assert_output ''

    run_pipe_with_memcheck "printf '0x7fffffffffffffff\n'" "ranges --hex --force"
    assert_success
    assert_memcheck_ok
}

@test "unsorted sequence 0x1 0x2 0x3 0x2 0x7 0x8 0x9 causes unsorted error with force" {
    run bash -c "printf '0x1\n0x2\n0x3\n0x2\n0x7\n0x8\n0x9\n' | ranges --hex -f"
    assert_failure
    assert_output --partial "Error: Input is not sorted on line '0x2'."

    run_pipe_with_memcheck "printf '0x1\n0x2\n0x3\n0x2\n0x7\n0x8\n0x9\n'" "ranges --hex -f"
    assert_failure
    assert_output --partial "Error: Input is not sorted on line '0x2'."
    assert_memcheck_ok

    run bash -c "printf '0x1\n0x2\n0x3\n0x2\n0x7\n0x8\n0x9\n' | ranges --hex --force"
    assert_failure
    assert_output --partial "Error: Input is not sorted on line '0x2'."

    run_pipe_with_memcheck "printf '0x1\n0x2\n0x3\n0x2\n0x7\n0x8\n0x9\n'" "ranges --hex --force"
    assert_failure
    assert_output --partial "Error: Input is not sorted on line '0x2'."
    assert_memcheck_ok
}

# date ranges

@test "wrong format sequence 2022-01-01 01/01/2022 2022-01-03 works with force" {
    run bash -c "printf '2022-01-01\n01/01/2022\n2022-01-03\n' | ranges --date -f"
    assert_success
    assert_output '2022-01-01 2022-01-01
2022-01-03 2022-01-03'

    run_pipe_with_memcheck "printf '2022-01-01\n01/01/2022\n2022-01-03\n'" "ranges --date -f"
    assert_success
    assert_output --partial '2022-01-01 2022-01-01
2022-01-03 2022-01-03'
    assert_memcheck_ok

    run bash -c "printf '2022-01-01\n01/01/2022\n2022-01-03\n' | ranges --date --force"
    assert_success
    assert_output '2022-01-01 2022-01-01
2022-01-03 2022-01-03'

    run_pipe_with_memcheck "printf '2022-01-01\n01/01/2022\n2022-01-03\n'" "ranges --date --force"
    assert_success
    assert_output --partial '2022-01-01 2022-01-01
2022-01-03 2022-01-03'
    assert_memcheck_ok
}

@test "wrong format sequence 2022-01-01 '2022-01-02 ' 2022-01-03 works with force" {
    run bash -c "printf '2022-01-01\n2022-01-02 \n2022-01-03\n' | ranges --date -f"
    assert_success
    assert_output '2022-01-01 2022-01-01
2022-01-03 2022-01-03'

    run_pipe_with_memcheck "printf '2022-01-01\n2022-01-02 \n2022-01-03\n'" "ranges --date -f"
    assert_success
    assert_output --partial '2022-01-01 2022-01-01
2022-01-03 2022-01-03'
    assert_memcheck_ok

    run bash -c "printf '2022-01-01\n2022-01-02 \n2022-01-03\n' | ranges --date --force"
    assert_success
    assert_output '2022-01-01 2022-01-01
2022-01-03 2022-01-03'

    run_pipe_with_memcheck "printf '2022-01-01\n2022-01-02 \n2022-01-03\n'" "ranges --date --force"
    assert_success
    assert_output --partial '2022-01-01 2022-01-01
2022-01-03 2022-01-03'
    assert_memcheck_ok
}

@test "wrong format sequence 2022-01-01 '2022-01-01 2022-01-02' 2022-01-03 works with force" {
    run bash -c "printf '2022-01-01\n2022-01-01 2022-01-02\n2022-01-03\n' | ranges --date -f"
    assert_success
    assert_output '2022-01-01 2022-01-01
2022-01-03 2022-01-03'

    run_pipe_with_memcheck "printf '2022-01-01\n2022-01-01 2022-01-02\n2022-01-03\n'" "ranges --date -f"
    assert_success
    assert_output --partial '2022-01-01 2022-01-01
2022-01-03 2022-01-03'
    assert_memcheck_ok

    run bash -c "printf '2022-01-01\n2022-01-01 2022-01-02\n2022-01-03\n' | ranges --date --force"
    assert_success
    assert_output '2022-01-01 2022-01-01
2022-01-03 2022-01-03'

    run_pipe_with_memcheck "printf '2022-01-01\n2022-01-01 2022-01-02\n2022-01-03\n'" "ranges --date --force"
    assert_success
    assert_output --partial '2022-01-01 2022-01-01
2022-01-03 2022-01-03'
    assert_memcheck_ok
}

@test "unsorted sequence 2022-01-01 2022-01-02 2022-01-03 2022-01-02 2022-01-07 2022-01-08 2022-01-09 causes unsorted error with force" {
    run bash -c "printf '2022-01-01\n2022-01-02\n2022-01-03\n2022-01-02\n2022-01-07\n2022-01-08\n2022-01-09\n' | ranges --date -f"
    assert_failure
    assert_output --partial "Error: Input is not sorted on line '2022-01-02'."

    run_pipe_with_memcheck "printf '2022-01-01\n2022-01-02\n2022-01-03\n2022-01-02\n2022-01-07\n2022-01-08\n2022-01-09\n'" "ranges --date -f"
    assert_failure
    assert_output --partial "Error: Input is not sorted on line '2022-01-02'."
    assert_memcheck_ok

    run bash -c "printf '2022-01-01\n2022-01-02\n2022-01-03\n2022-01-02\n2022-01-07\n2022-01-08\n2022-01-09\n' | ranges --date --force"
    assert_failure
    assert_output --partial "Error: Input is not sorted on line '2022-01-02'."

    run_pipe_with_memcheck "printf '2022-01-01\n2022-01-02\n2022-01-03\n2022-01-02\n2022-01-07\n2022-01-08\n2022-01-09\n'" "ranges --date --force"
    assert_failure
    assert_output --partial "Error: Input is not sorted on line '2022-01-02'."
    assert_memcheck_ok
}

@test "extra day in non-leap year sequence 2023-02-28 2023-02-29 2023-03-01 fails" {
    run bash -c "printf '2023-02-28\n2023-02-29\n2023-03-01\n' | ranges --date -f"
    assert_failure
    assert_output --partial "Error: Invalid date on line '2023-02-29'."

    run_pipe_with_memcheck "printf '2023-02-28\n2023-02-29\n2023-03-01\n'" "ranges --date -f"
    assert_failure
    assert_output --partial "Error: Invalid date on line '2023-02-29'."
    assert_memcheck_ok

    run bash -c "printf '2023-02-28\n2023-02-29\n2023-03-01\n' | ranges --date --force"
    assert_failure
    assert_output --partial "Error: Invalid date on line '2023-02-29'."

    run_pipe_with_memcheck "printf '2023-02-28\n2023-02-29\n2023-03-01\n'" "ranges --date --force"
    assert_failure
    assert_output --partial "Error: Invalid date on line '2023-02-29'."
    assert_memcheck_ok
}

# ipv4 address ranges

@test "wrong format sequence 1.0.0.1 1.0.2 1.0.0.3 works with force" {
    run bash -c "printf '1.0.0.1\n1.0.2\n1.0.0.3\n' | ranges --ipv4 -f"
    assert_success
    assert_output '1.0.0.1 1.0.0.1
1.0.0.3 1.0.0.3'

    run_pipe_with_memcheck "printf '1.0.0.1\n1.0.2\n1.0.0.3\n'" "ranges --ipv4 -f"
    assert_success
    assert_output --partial '1.0.0.1 1.0.0.1
1.0.0.3 1.0.0.3'
    assert_memcheck_ok

    run bash -c "printf '1.0.0.1\n1.0.2\n1.0.0.3\n' | ranges --ipv4 --force"
    assert_success
    assert_output '1.0.0.1 1.0.0.1
1.0.0.3 1.0.0.3'

    run_pipe_with_memcheck "printf '1.0.0.1\n1.0.2\n1.0.0.3\n'" "ranges --ipv4 --force"
    assert_success
    assert_output --partial '1.0.0.1 1.0.0.1
1.0.0.3 1.0.0.3'
    assert_memcheck_ok
}

@test "wrong format sequence 1.0.0.1 '1.0.0.2 ' 1.0.0.3 works with force" {
    run bash -c "printf '1.0.0.1\n1.0.0.2 \n1.0.0.3\n' | ranges --ipv4 -f"
    assert_success
    assert_output '1.0.0.1 1.0.0.1
1.0.0.3 1.0.0.3'

    run_pipe_with_memcheck "printf '1.0.0.1\n1.0.0.2 \n1.0.0.3\n'" "ranges --ipv4 -f"
    assert_success
    assert_output --partial '1.0.0.1 1.0.0.1
1.0.0.3 1.0.0.3'
    assert_memcheck_ok

    run bash -c "printf '1.0.0.1\n1.0.0.2 \n1.0.0.3\n' | ranges --ipv4 --force"
    assert_success
    assert_output '1.0.0.1 1.0.0.1
1.0.0.3 1.0.0.3'

    run_pipe_with_memcheck "printf '1.0.0.1\n1.0.0.2 \n1.0.0.3\n'" "ranges --ipv4 --force"
    assert_success
    assert_output --partial '1.0.0.1 1.0.0.1
1.0.0.3 1.0.0.3'
    assert_memcheck_ok
}

@test "wrong format sequence 1.0.0.1 '1.0.0.1 1.0.0.2' 1.0.0.3 works with force" {
    run bash -c "printf '1.0.0.1\n1.0.0.1 1.0.0.2\n1.0.0.3\n' | ranges --ipv4 -f"
    assert_success
    assert_output '1.0.0.1 1.0.0.1
1.0.0.3 1.0.0.3'

    run_pipe_with_memcheck "printf '1.0.0.1\n1.0.0.1 1.0.0.2\n1.0.0.3\n'" "ranges --ipv4 -f"
    assert_success
    assert_output --partial '1.0.0.1 1.0.0.1
1.0.0.3 1.0.0.3'
    assert_memcheck_ok

    run bash -c "printf '1.0.0.1\n1.0.0.1 1.0.0.2\n1.0.0.3\n' | ranges --ipv4 --force"
    assert_success
    assert_output '1.0.0.1 1.0.0.1
1.0.0.3 1.0.0.3'

    run_pipe_with_memcheck "printf '1.0.0.1\n1.0.0.1 1.0.0.2\n1.0.0.3\n'" "ranges --ipv4 --force"
    assert_success
    assert_output --partial '1.0.0.1 1.0.0.1
1.0.0.3 1.0.0.3'
    assert_memcheck_ok
}

@test "unsorted sequence 1.0.0.1 1.0.0.2 1.0.0.3 1.0.0.2 1.0.0.7 1.0.0.8 1.0.0.9 causes unsorted error with force" {
    run bash -c "printf '1.0.0.1\n1.0.0.2\n1.0.0.3\n1.0.0.2\n1.0.0.7\n1.0.0.8\n1.0.0.9\n' | ranges --ipv4 -f"
    assert_failure
    assert_output --partial "Error: Input is not sorted on line '1.0.0.2'."

    run_pipe_with_memcheck "printf '1.0.0.1\n1.0.0.2\n1.0.0.3\n1.0.0.2\n1.0.0.7\n1.0.0.8\n1.0.0.9\n'" "ranges --ipv4 -f"
    assert_failure
    assert_output --partial "Error: Input is not sorted on line '1.0.0.2'."
    assert_memcheck_ok

    run bash -c "printf '1.0.0.1\n1.0.0.2\n1.0.0.3\n1.0.0.2\n1.0.0.7\n1.0.0.8\n1.0.0.9\n' | ranges --ipv4 --force"
    assert_failure
    assert_output --partial "Error: Input is not sorted on line '1.0.0.2'."

    run_pipe_with_memcheck "printf '1.0.0.1\n1.0.0.2\n1.0.0.3\n1.0.0.2\n1.0.0.7\n1.0.0.8\n1.0.0.9\n'" "ranges --ipv4 --force"
    assert_failure
    assert_output --partial "Error: Input is not sorted on line '1.0.0.2'."
    assert_memcheck_ok
}

# ipv6 address ranges

@test "wrong format sequence ::1 1.0.0.2 ::3 works with force" {
    run bash -c "printf '::1\n1.0.2\n::3\n' | ranges --ipv6 -f"
    assert_success
    assert_output '::1 ::1
::3 ::3'

    run_pipe_with_memcheck "printf '::1\n1.0.2\n::3\n'" "ranges --ipv6 -f"
    assert_success
    assert_output --partial '::1 ::1
::3 ::3'
    assert_memcheck_ok

    run bash -c "printf '::1\n1.0.2\n::3\n' | ranges --ipv6 --force"
    assert_success
    assert_output '::1 ::1
::3 ::3'

    run_pipe_with_memcheck "printf '::1\n1.0.2\n::3\n'" "ranges --ipv6 --force"
    assert_success
    assert_output --partial '::1 ::1
::3 ::3'
    assert_memcheck_ok
}

@test "wrong format sequence ::1 '::2 ' ::3 works with force" {
    run bash -c "printf '::1\n::2 \n::3\n' | ranges --ipv6 -f"
    assert_success
    assert_output '::1 ::1
::3 ::3'

    run_pipe_with_memcheck "printf '::1\n::2 \n::3\n'" "ranges --ipv6 -f"
    assert_success
    assert_output --partial '::1 ::1
::3 ::3'
    assert_memcheck_ok

    run bash -c "printf '::1\n::2 \n::3\n' | ranges --ipv6 --force"
    assert_success
    assert_output '::1 ::1
::3 ::3'

    run_pipe_with_memcheck "printf '::1\n::2 \n::3\n'" "ranges --ipv6 --force"
    assert_success
    assert_output --partial '::1 ::1
::3 ::3'
    assert_memcheck_ok
}

@test "wrong format sequence ::1 '::1 ::2' ::3 works with force" {
    run bash -c "printf '::1\n::1 ::2\n::3\n' | ranges --ipv6 -f"
    assert_success
    assert_output '::1 ::1
::3 ::3'

    run_pipe_with_memcheck "printf '::1\n::1 ::2\n::3\n'" "ranges --ipv6 -f"
    assert_success
    assert_output --partial '::1 ::1
::3 ::3'
    assert_memcheck_ok

    run bash -c "printf '::1\n::1 ::2\n::3\n' | ranges --ipv6 --force"
    assert_success
    assert_output '::1 ::1
::3 ::3'

    run_pipe_with_memcheck "printf '::1\n::1 ::2\n::3\n'" "ranges --ipv6 --force"
    assert_success
    assert_output --partial '::1 ::1
::3 ::3'
    assert_memcheck_ok
}

@test "unsorted sequence ::1 ::2 ::3 ::2 ::7 ::8 ::9 causes unsorted error with force" {
    run bash -c "printf '::1\n::2\n::3\n::2\n::7\n::8\n::9\n' | ranges --ipv6 -f"
    assert_failure
    assert_output --partial "Error: Input is not sorted on line '::2'."

    run_pipe_with_memcheck "printf '::1\n::2\n::3\n::2\n::7\n::8\n::9\n'" "ranges --ipv6 -f"
    assert_failure
    assert_output --partial "Error: Input is not sorted on line '::2'."
    assert_memcheck_ok

    run bash -c "printf '::1\n::2\n::3\n::2\n::7\n::8\n::9\n' | ranges --ipv6 --force"
    assert_failure
    assert_output --partial "Error: Input is not sorted on line '::2'."

    run_pipe_with_memcheck "printf '::1\n::2\n::3\n::2\n::7\n::8\n::9\n'" "ranges --ipv6 --force"
    assert_failure
    assert_output --partial "Error: Input is not sorted on line '::2'."
    assert_memcheck_ok
}

# mac address ranges

@test "wrong format sequence 00:00:00:00:00:01 00-00-00-00-00-02 00:00:00:00:00:03 works with force" {
    run bash -c "printf '00:00:00:00:00:01\n00-00-00-00-00-02\n00:00:00:00:00:03\n' | ranges --mac -f"
    assert_success
    assert_output '00:00:00:00:00:01 00:00:00:00:00:01
00:00:00:00:00:03 00:00:00:00:00:03'

    run_pipe_with_memcheck "printf '00:00:00:00:00:01\n00-00-00-00-00-02\n00:00:00:00:00:03\n'" "ranges --mac -f"
    assert_success
    assert_output --partial '00:00:00:00:00:01 00:00:00:00:00:01
00:00:00:00:00:03 00:00:00:00:00:03'
    assert_memcheck_ok

    run bash -c "printf '00:00:00:00:00:01\n00-00-00-00-00-02\n00:00:00:00:00:03\n' | ranges --mac --force"
    assert_success
    assert_output '00:00:00:00:00:01 00:00:00:00:00:01
00:00:00:00:00:03 00:00:00:00:00:03'

    run_pipe_with_memcheck "printf '00:00:00:00:00:01\n00-00-00-00-00-02\n00:00:00:00:00:03\n'" "ranges --mac --force"
    assert_success
    assert_output --partial '00:00:00:00:00:01 00:00:00:00:00:01
00:00:00:00:00:03 00:00:00:00:00:03'
    assert_memcheck_ok
}

@test "wrong format sequence 00:00:00:00:00:01 '00:00:00:00:00:02 ' 00:00:00:00:00:03 works with force" {
    run bash -c "printf '00:00:00:00:00:01\n00:00:00:00:00:02 \n00:00:00:00:00:03\n' | ranges --mac -f"
    assert_success
    assert_output '00:00:00:00:00:01 00:00:00:00:00:01
00:00:00:00:00:03 00:00:00:00:00:03'

    run_pipe_with_memcheck "printf '00:00:00:00:00:01\n00:00:00:00:00:02 \n00:00:00:00:00:03\n'" "ranges --mac -f"
    assert_success
    assert_output --partial '00:00:00:00:00:01 00:00:00:00:00:01
00:00:00:00:00:03 00:00:00:00:00:03'
    assert_memcheck_ok

    run bash -c "printf '00:00:00:00:00:01\n00:00:00:00:00:02 \n00:00:00:00:00:03\n' | ranges --mac --force"
    assert_success
    assert_output '00:00:00:00:00:01 00:00:00:00:00:01
00:00:00:00:00:03 00:00:00:00:00:03'

    run_pipe_with_memcheck "printf '00:00:00:00:00:01\n00:00:00:00:00:02 \n00:00:00:00:00:03\n'" "ranges --mac --force"
    assert_success
    assert_output --partial '00:00:00:00:00:01 00:00:00:00:00:01
00:00:00:00:00:03 00:00:00:00:00:03'
    assert_memcheck_ok
}

@test "wrong format sequence 00:00:00:00:00:01 '00:00:00:00:00:01 00:00:00:00:00:02' 00:00:00:00:00:03 works with force" {
    run bash -c "printf '00:00:00:00:00:01\n00:00:00:00:00:01 00:00:00:00:00:02\n00:00:00:00:00:03\n' | ranges --mac -f"
    assert_success
    assert_output '00:00:00:00:00:01 00:00:00:00:00:01
00:00:00:00:00:03 00:00:00:00:00:03'

    run_pipe_with_memcheck "printf '00:00:00:00:00:01\n00:00:00:00:00:01 00:00:00:00:00:02\n00:00:00:00:00:03\n'" "ranges --mac -f"
    assert_success
    assert_output --partial '00:00:00:00:00:01 00:00:00:00:00:01
00:00:00:00:00:03 00:00:00:00:00:03'
    assert_memcheck_ok

    run bash -c "printf '00:00:00:00:00:01\n00:00:00:00:00:01 00:00:00:00:00:02\n00:00:00:00:00:03\n' | ranges --mac --force"
    assert_success
    assert_output '00:00:00:00:00:01 00:00:00:00:00:01
00:00:00:00:00:03 00:00:00:00:00:03'

    run_pipe_with_memcheck "printf '00:00:00:00:00:01\n00:00:00:00:00:01 00:00:00:00:00:02\n00:00:00:00:00:03\n'" "ranges --mac --force"
    assert_success
    assert_output --partial '00:00:00:00:00:01 00:00:00:00:00:01
00:00:00:00:00:03 00:00:00:00:00:03'
    assert_memcheck_ok
}

@test "unsorted sequence 00:00:00:00:00:01 00:00:00:00:00:02 00:00:00:00:00:03 00:00:00:00:00:02 00:00:00:00:00:07 00:00:00:00:00:08 00:00:00:00:00:09 causes unsorted error with force" {
    run bash -c "printf '00:00:00:00:00:01\n00:00:00:00:00:02\n00:00:00:00:00:03\n00:00:00:00:00:02\n00:00:00:00:00:07\n00:00:00:00:00:08\n00:00:00:00:00:09\n' | ranges --mac -f"
    assert_failure
    assert_output --partial "Error: Input is not sorted on line '00:00:00:00:00:02'."

    run_pipe_with_memcheck "printf '00:00:00:00:00:01\n00:00:00:00:00:02\n00:00:00:00:00:03\n00:00:00:00:00:02\n00:00:00:00:00:07\n00:00:00:00:00:08\n00:00:00:00:00:09\n'" "ranges --mac -f"
    assert_failure
    assert_output --partial "Error: Input is not sorted on line '00:00:00:00:00:02'."
    assert_memcheck_ok

    run bash -c "printf '00:00:00:00:00:01\n00:00:00:00:00:02\n00:00:00:00:00:03\n00:00:00:00:00:02\n00:00:00:00:00:07\n00:00:00:00:00:08\n00:00:00:00:00:09\n' | ranges --mac --force"
    assert_failure
    assert_output --partial "Error: Input is not sorted on line '00:00:00:00:00:02'."

    run_pipe_with_memcheck "printf '00:00:00:00:00:01\n00:00:00:00:00:02\n00:00:00:00:00:03\n00:00:00:00:00:02\n00:00:00:00:00:07\n00:00:00:00:00:08\n00:00:00:00:00:09\n'" "ranges --mac --force"
    assert_failure
    assert_output --partial "Error: Input is not sorted on line '00:00:00:00:00:02'."
    assert_memcheck_ok
}
