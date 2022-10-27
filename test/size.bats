setup() {
    load 'helper/setup'
    _common_setup
}


# binary number ranges
@test "simple sequence 0b1 0b10 0b11 0b111 0b1000 0b1001 works with size" {
    run bash -c "printf '0b1\n0b10\n0b11\n0b111\n0b1000\n0b1001\n' | ranges --binary -s"
    assert_success
    assert_output "0b1 0b11 3
0b111 0b1001 3"

    run_pipe_with_memcheck "printf '0b1\n0b10\n0b11\n0b111\n0b1000\n0b1001\n'" "ranges --binary -s"
    assert_success
    assert_output --partial "0b1 0b11 3
0b111 0b1001 3"
    assert_memcheck_ok

    run bash -c "printf '0b1\n0b10\n0b11\n0b111\n0b1000\n0b1001\n' | ranges --binary --size"
    assert_success
    assert_output "0b1 0b11 3
0b111 0b1001 3"

    run_pipe_with_memcheck "printf '0b1\n0b10\n0b11\n0b111\n0b1000\n0b1001\n'" "ranges --binary --size"
    assert_success
    assert_output --partial "0b1 0b11 3
0b111 0b1001 3"
    assert_memcheck_ok
}

@test "duplicate number sequence 0b0 0b0 0b0 0b0 0b1 0b11 0b100 0b101 0b101 0b101 works with size" {
    run bash -c "printf -- '0b0\n0b0\n0b0\n0b0\n0b1\n0b11\n0b100\n0b101\n0b101\n0b101\n' | ranges --binary -s"
    assert_success
    assert_output "0b0 0b1 2
0b11 0b101 3"

    run_pipe_with_memcheck "printf -- '0b0\n0b0\n0b0\n0b0\n0b1\n0b11\n0b100\n0b101\n0b101\n0b101\n'" "ranges --binary -s"
    assert_success
    assert_output --partial "0b0 0b1 2
0b11 0b101 3"
    assert_memcheck_ok

    run bash -c "printf -- '0b0\n0b0\n0b0\n0b0\n0b1\n0b11\n0b100\n0b101\n0b101\n0b101\n' | ranges --binary --size"
    assert_success
    assert_output "0b0 0b1 2
0b11 0b101 3"

    run_pipe_with_memcheck "printf -- '0b0\n0b0\n0b0\n0b0\n0b1\n0b11\n0b100\n0b101\n0b101\n0b101\n'" "ranges --binary --size"
    assert_success
    assert_output --partial "0b0 0b1 2
0b11 0b101 3"
    assert_memcheck_ok
}

# octal number ranges
@test "simple sequence 0o1 0o2 0o3 0o7 0o10 0o11 works with size" {
    run bash -c "printf '0o1\n0o2\n0o3\n0o7\n0o10\n0o11\n' | ranges --octal -s"
    assert_success
    assert_output "0o1 0o3 3
0o7 0o11 3"

    run_pipe_with_memcheck "printf '0o1\n0o2\n0o3\n0o7\n0o10\n0o11\n'" "ranges --octal -s"
    assert_success
    assert_output --partial "0o1 0o3 3
0o7 0o11 3"
    assert_memcheck_ok

    run bash -c "printf '0o1\n0o2\n0o3\n0o7\n0o10\n0o11\n' | ranges --octal --size"
    assert_success
    assert_output "0o1 0o3 3
0o7 0o11 3"

    run_pipe_with_memcheck "printf '0o1\n0o2\n0o3\n0o7\n0o10\n0o11\n'" "ranges --octal --size"
    assert_success
    assert_output --partial "0o1 0o3 3
0o7 0o11 3"
    assert_memcheck_ok
}

@test "dumplicate number sequence 0o0 0o0 0o0 0o0 0o1 0o3 0o4 0o5 0o5 0o5 works with size" {
    run bash -c "printf -- '0o0\n0o0\n0o0\n0o0\n0o1\n0o3\n0o4\n0o5\n0o5\n0o5\n' | ranges --octal -s"
    assert_success
    assert_output "0o0 0o1 2
0o3 0o5 3"

    run_pipe_with_memcheck "printf -- '0o0\n0o0\n0o0\n0o0\n0o1\n0o3\n0o4\n0o5\n0o5\n0o5\n'" "ranges --octal -s"
    assert_success
    assert_output --partial "0o0 0o1 2
0o3 0o5 3"
    assert_memcheck_ok

    run bash -c "printf -- '0o0\n0o0\n0o0\n0o0\n0o1\n0o3\n0o4\n0o5\n0o5\n0o5\n' | ranges --octal --size"
    assert_success
    assert_output "0o0 0o1 2
0o3 0o5 3"

    run_pipe_with_memcheck "printf -- '0o0\n0o0\n0o0\n0o0\n0o1\n0o3\n0o4\n0o5\n0o5\n0o5\n'" "ranges --octal --size"
    assert_success
    assert_output --partial "0o0 0o1 2
0o3 0o5 3"
    assert_memcheck_ok
}

# decimal number ranges
@test "simple sequence 1 2 3 7 8 9 works with size" {
    run bash -c "printf '1\n2\n3\n7\n8\n9\n' | ranges -s"
    assert_success
    assert_output "1 3 3
7 9 3"

    run_pipe_with_memcheck "printf '1\n2\n3\n7\n8\n9\n'" "ranges -s"
    assert_success
    assert_output --partial "1 3 3
7 9 3"
    assert_memcheck_ok

    run bash -c "printf '1\n2\n3\n7\n8\n9\n' | ranges --size"
    assert_success
    assert_output "1 3 3
7 9 3"

    run_pipe_with_memcheck "printf '1\n2\n3\n7\n8\n9\n'" "ranges --size"
    assert_success
    assert_output --partial "1 3 3
7 9 3"
    assert_memcheck_ok
}

@test "partially negative dumplicate number sequence -5 -4 -4 -3 -1 0 0 0 0 +1 +3 +4 +5 +5 +5 works with size" {
    run bash -c "printf -- '-5\n-4\n-4\n-3\n-1\n0\n0\n0\n0\n+1\n+3\n+4\n+5\n+5\n+5\n' | ranges -s"
    assert_success
    assert_output "-5 -3 3
-1 1 3
3 5 3"

    run_pipe_with_memcheck "printf -- '-5\n-4\n-4\n-3\n-1\n0\n0\n0\n0\n+1\n+3\n+4\n+5\n+5\n+5\n'" "ranges -s"
    assert_success
    assert_output --partial "-5 -3 3
-1 1 3
3 5 3"
    assert_memcheck_ok

    run bash -c "printf -- '-5\n-4\n-4\n-3\n-1\n0\n0\n0\n0\n+1\n+3\n+4\n+5\n+5\n+5\n' | ranges --size"
    assert_success
    assert_output "-5 -3 3
-1 1 3
3 5 3"

    run_pipe_with_memcheck "printf -- '-5\n-4\n-4\n-3\n-1\n0\n0\n0\n0\n+1\n+3\n+4\n+5\n+5\n+5\n'" "ranges --size"
    assert_success
    assert_output --partial "-5 -3 3
-1 1 3
3 5 3"
    assert_memcheck_ok
}

# hexadecimal number ranges
@test "simple sequence 0x1 0x2 0x3 0x7 0x8 0x9 works with size" {
    run bash -c "printf '0x1\n0x2\n0x3\n0x7\n0x8\n0x9\n' | ranges --hex -s"
    assert_success
    assert_output "0x1 0x3 3
0x7 0x9 3"

    run_pipe_with_memcheck "printf '0x1\n0x2\n0x3\n0x7\n0x8\n0x9\n'" "ranges --hex -s"
    assert_success
    assert_output --partial "0x1 0x3 3
0x7 0x9 3"
    assert_memcheck_ok

    run bash -c "printf '0x1\n0x2\n0x3\n0x7\n0x8\n0x9\n' | ranges --hex --size"
    assert_success
    assert_output "0x1 0x3 3
0x7 0x9 3"

    run_pipe_with_memcheck "printf '0x1\n0x2\n0x3\n0x7\n0x8\n0x9\n'" "ranges --hex --size"
    assert_success
    assert_output --partial "0x1 0x3 3
0x7 0x9 3"
    assert_memcheck_ok
}

@test "dumplicate number sequence 0x0 0x0 0x0 0x0 0x1 0x3 0x4 0x5 0x5 0x5 works with size" {
    run bash -c "printf -- '0x0\n0x0\n0x0\n0x0\n0x1\n0x3\n0x4\n0x5\n0x5\n0x5\n' | ranges --hex -s"
    assert_success
    assert_output "0x0 0x1 2
0x3 0x5 3"

    run_pipe_with_memcheck "printf -- '0x0\n0x0\n0x0\n0x0\n0x1\n0x3\n0x4\n0x5\n0x5\n0x5\n'" "ranges --hex -s"
    assert_success
    assert_output --partial "0x0 0x1 2
0x3 0x5 3"
    assert_memcheck_ok

    run bash -c "printf -- '0x0\n0x0\n0x0\n0x0\n0x1\n0x3\n0x4\n0x5\n0x5\n0x5\n' | ranges --hex --size"
    assert_success
    assert_output "0x0 0x1 2
0x3 0x5 3"

    run_pipe_with_memcheck "printf -- '0x0\n0x0\n0x0\n0x0\n0x1\n0x3\n0x4\n0x5\n0x5\n0x5\n'" "ranges --hex --size"
    assert_success
    assert_output --partial "0x0 0x1 2
0x3 0x5 3"
    assert_memcheck_ok
}

# date number ranges
@test "simple sequence 2022-01-01 2022-01-02 2022-01-03 2022-01-07 2022-01-08 2022-01-09 works with size" {
    run bash -c "printf '2022-01-01\n2022-01-02\n2022-01-03\n2022-01-07\n2022-01-08\n2022-01-09\n' | ranges --date -s"
    assert_success
    assert_output "2022-01-01 2022-01-03 3
2022-01-07 2022-01-09 3"

    run_pipe_with_memcheck "printf '2022-01-01\n2022-01-02\n2022-01-03\n2022-01-07\n2022-01-08\n2022-01-09\n'" "ranges --date -s"
    assert_success
    assert_output --partial "2022-01-01 2022-01-03 3
2022-01-07 2022-01-09 3"
    assert_memcheck_ok

    run bash -c "printf '2022-01-01\n2022-01-02\n2022-01-03\n2022-01-07\n2022-01-08\n2022-01-09\n' | ranges --date --size"
    assert_success
    assert_output "2022-01-01 2022-01-03 3
2022-01-07 2022-01-09 3"

    run_pipe_with_memcheck "printf '2022-01-01\n2022-01-02\n2022-01-03\n2022-01-07\n2022-01-08\n2022-01-09\n'" "ranges --date --size"
    assert_success
    assert_output --partial "2022-01-01 2022-01-03 3
2022-01-07 2022-01-09 3"
    assert_memcheck_ok
}

@test "dumplicate date sequence 2022-01-01 2022-01-01 2022-01-01 2022-01-01 2022-01-01 2022-01-03 2022-01-04 2022-01-05 2022-01-05 2022-01-05 works with size" {
    run bash -c "printf -- '2022-01-01\n2022-01-01\n2022-01-01\n2022-01-01\n2022-01-01\n2022-01-03\n2022-01-04\n2022-01-05\n2022-01-05\n2022-01-05\n' | ranges --date -s"
    assert_success
    assert_output "2022-01-01 2022-01-01 1
2022-01-03 2022-01-05 3"

    run_pipe_with_memcheck "printf -- '2022-01-01\n2022-01-01\n2022-01-01\n2022-01-01\n2022-01-01\n2022-01-03\n2022-01-04\n2022-01-05\n2022-01-05\n2022-01-05\n'" "ranges --date -s"
    assert_success
    assert_output --partial "2022-01-01 2022-01-01 1
2022-01-03 2022-01-05 3"
    assert_memcheck_ok

    run bash -c "printf -- '2022-01-01\n2022-01-01\n2022-01-01\n2022-01-01\n2022-01-01\n2022-01-03\n2022-01-04\n2022-01-05\n2022-01-05\n2022-01-05\n' | ranges --date --size"
    assert_success
    assert_output "2022-01-01 2022-01-01 1
2022-01-03 2022-01-05 3"

    run_pipe_with_memcheck "printf -- '2022-01-01\n2022-01-01\n2022-01-01\n2022-01-01\n2022-01-01\n2022-01-03\n2022-01-04\n2022-01-05\n2022-01-05\n2022-01-05\n'" "ranges --date --size"
    assert_success
    assert_output --partial "2022-01-01 2022-01-01 1
2022-01-03 2022-01-05 3"
    assert_memcheck_ok
}

# ipv4 number ranges
@test "simple sequence 1.0.0.1 1.0.0.2 1.0.0.3 1.0.0.7 1.0.0.8 1.0.0.9 works with size" {
    run bash -c "printf '\n1.0.0.1\n1.0.0.2\n1.0.0.3\n1.0.0.7\n1.0.0.8\n1.0.0.9\n' | ranges --ipv4 -s"
    assert_success
    assert_output "1.0.0.1 1.0.0.3 3
1.0.0.7 1.0.0.9 3"

    run_pipe_with_memcheck "printf '\n1.0.0.1\n1.0.0.2\n1.0.0.3\n1.0.0.7\n1.0.0.8\n1.0.0.9\n'" " ranges --ipv4 -s"
    assert_success
    assert_output --partial "1.0.0.1 1.0.0.3 3
1.0.0.7 1.0.0.9 3"
    assert_memcheck_ok

    run bash -c "printf '\n1.0.0.1\n1.0.0.2\n1.0.0.3\n1.0.0.7\n1.0.0.8\n1.0.0.9\n' | ranges --ipv4 --size"
    assert_success
    assert_output "1.0.0.1 1.0.0.3 3
1.0.0.7 1.0.0.9 3"

    run_pipe_with_memcheck "printf '\n1.0.0.1\n1.0.0.2\n1.0.0.3\n1.0.0.7\n1.0.0.8\n1.0.0.9\n'" "ranges --ipv4 --size"
    assert_success
    assert_output --partial "1.0.0.1 1.0.0.3 3
1.0.0.7 1.0.0.9 3"
    assert_memcheck_ok
}

@test "dumplicate ip sequence 1.0.0.0 1.0.0.0 1.0.0.0 1.0.0.0 1.0.0.1 1.0.0.3 1.0.0.4 1.0.0.5 1.0.0.5 1.0.0.5 works with size" {
    run bash -c "printf -- '1.0.0.0\n1.0.0.0\n1.0.0.0\n1.0.0.0\n1.0.0.1\n1.0.0.3\n1.0.0.4\n1.0.0.5\n1.0.0.5\n1.0.0.5\n' | ranges --ipv4 -s"
    assert_success
    assert_output "1.0.0.0 1.0.0.1 2
1.0.0.3 1.0.0.5 3"

    run_pipe_with_memcheck "printf -- '1.0.0.0\n1.0.0.0\n1.0.0.0\n1.0.0.0\n1.0.0.1\n1.0.0.3\n1.0.0.4\n1.0.0.5\n1.0.0.5\n1.0.0.5\n'" "ranges --ipv4 -s"
    assert_success
    assert_output --partial "1.0.0.0 1.0.0.1 2
1.0.0.3 1.0.0.5 3"
    assert_memcheck_ok

    run bash -c "printf -- '1.0.0.0\n1.0.0.0\n1.0.0.0\n1.0.0.0\n1.0.0.1\n1.0.0.3\n1.0.0.4\n1.0.0.5\n1.0.0.5\n1.0.0.5\n' | ranges --ipv4 --size"
    assert_success
    assert_output "1.0.0.0 1.0.0.1 2
1.0.0.3 1.0.0.5 3"

    run_pipe_with_memcheck "printf -- '1.0.0.0\n1.0.0.0\n1.0.0.0\n1.0.0.0\n1.0.0.1\n1.0.0.3\n1.0.0.4\n1.0.0.5\n1.0.0.5\n1.0.0.5\n'" "ranges --ipv4 --size"
    assert_success
    assert_output --partial "1.0.0.0 1.0.0.1 2
1.0.0.3 1.0.0.5 3"
    assert_memcheck_ok
}

# ipv6 number ranges
@test "simple sequence ::1 ::2 ::3 ::7 ::8 ::9 works with size" {
    run bash -c "printf '\n::1\n::2\n::3\n::7\n::8\n::9\n' | ranges --ipv6 -s"
    assert_success
    assert_output "::1 ::3 3
::7 ::9 3"

    run_pipe_with_memcheck "printf '\n::1\n::2\n::3\n::7\n::8\n::9\n'" "ranges --ipv6 -s"
    assert_success
    assert_output --partial "::1 ::3 3
::7 ::9 3"
    assert_memcheck_ok

    run bash -c "printf '\n::1\n::2\n::3\n::7\n::8\n::9\n' | ranges --ipv6 --size"
    assert_success
    assert_output "::1 ::3 3
::7 ::9 3"

    run_pipe_with_memcheck "printf '\n::1\n::2\n::3\n::7\n::8\n::9\n'" "ranges --ipv6 --size"
    assert_success
    assert_output --partial "::1 ::3 3
::7 ::9 3"
    assert_memcheck_ok
}

@test "dumplicate ip sequence :: :: :: :: ::1 ::3 ::4 ::5 ::5 ::5 works with size" {
    run bash -c "printf -- '::\n::\n::\n::\n::1\n::3\n::4\n::5\n::5\n::5\n' | ranges --ipv6 -s"
    assert_success
    assert_output ":: ::1 2
::3 ::5 3"

    run_pipe_with_memcheck "printf -- '::\n::\n::\n::\n::1\n::3\n::4\n::5\n::5\n::5\n'" "ranges --ipv6 -s"
    assert_success
    assert_output --partial ":: ::1 2
::3 ::5 3"
    assert_memcheck_ok

    run bash -c "printf -- '::\n::\n::\n::\n::1\n::3\n::4\n::5\n::5\n::5\n' | ranges --ipv6 --size"
    assert_success
    assert_output ":: ::1 2
::3 ::5 3"

    run_pipe_with_memcheck "printf -- '::\n::\n::\n::\n::1\n::3\n::4\n::5\n::5\n::5\n'" "ranges --ipv6 --size"
    assert_success
    assert_output --partial ":: ::1 2
::3 ::5 3"
    assert_memcheck_ok
}

# mac number ranges
@test "simple sequence 00:00:00:00:00:01 00:00:00:00:00:02 00:00:00:00:00:03 00:00:00:00:00:07 00:00:00:00:00:08 00:00:00:00:00:09 works with size" {
    run bash -c "printf '\n00:00:00:00:00:01\n00:00:00:00:00:02\n00:00:00:00:00:03\n00:00:00:00:00:07\n00:00:00:00:00:08\n00:00:00:00:00:09\n' | ranges --mac -s"
    assert_success
    assert_output "00:00:00:00:00:01 00:00:00:00:00:03 3
00:00:00:00:00:07 00:00:00:00:00:09 3"

    run_pipe_with_memcheck "printf '\n00:00:00:00:00:01\n00:00:00:00:00:02\n00:00:00:00:00:03\n00:00:00:00:00:07\n00:00:00:00:00:08\n00:00:00:00:00:09\n'" "ranges --mac -s"
    assert_success
    assert_output --partial "00:00:00:00:00:01 00:00:00:00:00:03 3
00:00:00:00:00:07 00:00:00:00:00:09 3"
    assert_memcheck_ok

    run bash -c "printf '\n00:00:00:00:00:01\n00:00:00:00:00:02\n00:00:00:00:00:03\n00:00:00:00:00:07\n00:00:00:00:00:08\n00:00:00:00:00:09\n' | ranges --mac --size"
    assert_success
    assert_output "00:00:00:00:00:01 00:00:00:00:00:03 3
00:00:00:00:00:07 00:00:00:00:00:09 3"

    run_pipe_with_memcheck "printf '\n00:00:00:00:00:01\n00:00:00:00:00:02\n00:00:00:00:00:03\n00:00:00:00:00:07\n00:00:00:00:00:08\n00:00:00:00:00:09\n'" "ranges --mac --size"
    assert_success
    assert_output --partial "00:00:00:00:00:01 00:00:00:00:00:03 3
00:00:00:00:00:07 00:00:00:00:00:09 3"
    assert_memcheck_ok
}

@test "duplicate mac sequence 00:00:00:00:00:00 00:00:00:00:00:00 00:00:00:00:00:00 00:00:00:00:00:00 00:00:00:00:00:01 00:00:00:00:00:03 00:00:00:00:00:04 00:00:00:00:00:05 00:00:00:00:00:05 00:00:00:00:00:05 works with size" {
    run bash -c "printf -- '00:00:00:00:00:00\n00:00:00:00:00:00\n00:00:00:00:00:00\n00:00:00:00:00:00\n00:00:00:00:00:01\n00:00:00:00:00:03\n00:00:00:00:00:04\n00:00:00:00:00:05\n00:00:00:00:00:05\n00:00:00:00:00:05\n' | ranges --mac -s"
    assert_success
    assert_output "00:00:00:00:00:00 00:00:00:00:00:01 2
00:00:00:00:00:03 00:00:00:00:00:05 3"

    run_pipe_with_memcheck "printf -- '00:00:00:00:00:00\n00:00:00:00:00:00\n00:00:00:00:00:00\n00:00:00:00:00:00\n00:00:00:00:00:01\n00:00:00:00:00:03\n00:00:00:00:00:04\n00:00:00:00:00:05\n00:00:00:00:00:05\n00:00:00:00:00:05\n'" "ranges --mac -s"
    assert_success
    assert_output --partial "00:00:00:00:00:00 00:00:00:00:00:01 2
00:00:00:00:00:03 00:00:00:00:00:05 3"
    assert_memcheck_ok

    run bash -c "printf -- '00:00:00:00:00:00\n00:00:00:00:00:00\n00:00:00:00:00:00\n00:00:00:00:00:00\n00:00:00:00:00:01\n00:00:00:00:00:03\n00:00:00:00:00:04\n00:00:00:00:00:05\n00:00:00:00:00:05\n00:00:00:00:00:05\n' | ranges --mac --size"
    assert_success
    assert_output "00:00:00:00:00:00 00:00:00:00:00:01 2
00:00:00:00:00:03 00:00:00:00:00:05 3"

    run_pipe_with_memcheck "printf -- '00:00:00:00:00:00\n00:00:00:00:00:00\n00:00:00:00:00:00\n00:00:00:00:00:00\n00:00:00:00:00:01\n00:00:00:00:00:03\n00:00:00:00:00:04\n00:00:00:00:00:05\n00:00:00:00:00:05\n00:00:00:00:00:05\n'" "ranges --mac --size"
    assert_success
    assert_output --partial "00:00:00:00:00:00 00:00:00:00:00:01 2
00:00:00:00:00:03 00:00:00:00:00:05 3"
    assert_memcheck_ok
}
