setup() {
    load 'helper/setup'
    _common_setup
}


@test "empty input causes empty output" {
    run bash -c "echo '' | ranges -I"
    assert_success
    assert_output ''

    run_pipe_with_memcheck "echo ''" "ranges -I"
    assert_success
    assert_memcheck_ok

    run bash -c "echo '' | ranges --ipv6"
    assert_success
    assert_output ''

    run_pipe_with_memcheck "echo ''" "ranges --ipv6"
    assert_success
    assert_memcheck_ok
}

@test "empty input lines cause empty output" {
    run bash -c "printf '\n\n\n' | ranges -I"
    assert_success
    assert_output ''

    run_pipe_with_memcheck "printf '\n\n\n'" "ranges -I"
    assert_success
    assert_memcheck_ok

    run bash -c "printf '\n\n\n' | ranges --ipv6"
    assert_success
    assert_output ''

    run_pipe_with_memcheck "printf '\n\n\n'" "ranges --ipv6"
    assert_success
    assert_memcheck_ok
}

@test "single line input ::1 works" {
    run bash -c "printf '::1\n' | ranges -I"
    assert_success
    assert_output '::1 ::1'

    run_pipe_with_memcheck "printf '::1\n'" "ranges -I"
    assert_success
    assert_output --partial '::1 ::1'
    assert_memcheck_ok

    run bash -c "printf '::1\n' | ranges --ipv6"
    assert_success
    assert_output '::1 ::1'

    run_pipe_with_memcheck "printf '::1\n'" "ranges --ipv6"
    assert_success
    assert_output --partial '::1 ::1'
    assert_memcheck_ok
}

@test "full ipv6 format single line input 0000:0000:0000:0000:0000:0000:0000:0001 works" {
    run bash -c "printf '0000:0000:0000:0000:0000:0000:0000:0001\n' | ranges -I"
    assert_success
    assert_output '::1 ::1'

    run_pipe_with_memcheck "printf '0000:0000:0000:0000:0000:0000:0000:0001\n'" "ranges -I"
    assert_success
    assert_output --partial '::1 ::1'
    assert_memcheck_ok

    run bash -c "printf '0000:0000:0000:0000:0000:0000:0000:0001\n' | ranges --ipv6"
    assert_success
    assert_output '::1 ::1'

    run_pipe_with_memcheck "printf '0000:0000:0000:0000:0000:0000:0000:0001\n'" "ranges --ipv6"
    assert_success
    assert_output --partial '::1 ::1'
    assert_memcheck_ok
}

@test "trivial sequence ::1 ::2 ::3 works" {
    run bash -c "printf '::1\n::2\n::3\n' | ranges -I"
    assert_success
    assert_output '::1 ::3'

    run_pipe_with_memcheck "printf '::1\n::2\n::3\n'" "ranges -I"
    assert_success
    assert_output --partial '::1 ::3'
    assert_memcheck_ok

    run bash -c "printf '::1\n::2\n::3\n' | ranges --ipv6"
    assert_success
    assert_output '::1 ::3'

    run_pipe_with_memcheck "printf '::1\n::2\n::3\n'" "ranges --ipv6"
    assert_success
    assert_output --partial '::1 ::3'
    assert_memcheck_ok
}

@test "simple sequence ::1 ::2 ::3 ::7 ::8 ::9 works" {
    run bash -c "printf '\n::1\n::2\n::3\n::7\n::8\n::9\n' | ranges -I"
    assert_success
    assert_output "::1 ::3
::7 ::9"

    run_pipe_with_memcheck "printf '\n::1\n::2\n::3\n::7\n::8\n::9\n'" "ranges -I"
    assert_success
    assert_output --partial "::1 ::3
::7 ::9"
    assert_memcheck_ok

    run bash -c "printf '\n::1\n::2\n::3\n::7\n::8\n::9\n' | ranges --ipv6"
    assert_success
    assert_output "::1 ::3
::7 ::9"

    run_pipe_with_memcheck "printf '\n::1\n::2\n::3\n::7\n::8\n::9\n'" "ranges --ipv6"
    assert_success
    assert_output --partial "::1 ::3
::7 ::9"
    assert_memcheck_ok
}

@test "duplicate ip sequence ::1 ::2 ::2 ::2 ::3 works" {
    run bash -c "printf '::1\n::2\n::2\n::2\n::3\n' | ranges -I"
    assert_success
    assert_output '::1 ::3'

    run_pipe_with_memcheck "printf '::1\n::2\n::2\n::2\n::3\n'" "ranges -I"
    assert_success
    assert_output --partial '::1 ::3'
    assert_memcheck_ok

    run bash -c "printf '::1\n::2\n::2\n::2\n::3\n' | ranges --ipv6"
    assert_success
    assert_output '::1 ::3'

    run_pipe_with_memcheck "printf '::1\n::2\n::2\n::2\n::3\n'" "ranges --ipv6"
    assert_success
    assert_output --partial '::1 ::3'
    assert_memcheck_ok
}

@test "dumplicate ip sequence :: :: :: :: ::1 ::3 ::4 ::5 ::5 ::5 works" {
    run bash -c "printf -- '::\n::\n::\n::\n::1\n::3\n::4\n::5\n::5\n::5\n' | ranges -I"
    assert_success
    assert_output ":: ::1
::3 ::5"

    run_pipe_with_memcheck "printf -- '::\n::\n::\n::\n::1\n::3\n::4\n::5\n::5\n::5\n'" "ranges -I"
    assert_success
    assert_output --partial ":: ::1
::3 ::5"
    assert_memcheck_ok

    run bash -c "printf -- '::\n::\n::\n::\n::1\n::3\n::4\n::5\n::5\n::5\n' | ranges --ipv6"
    assert_success
    assert_output ":: ::1
::3 ::5"

    run_pipe_with_memcheck "printf -- '::\n::\n::\n::\n::1\n::3\n::4\n::5\n::5\n::5\n'" "ranges --ipv6"
    assert_success
    assert_output --partial ":: ::1
::3 ::5"
    assert_memcheck_ok
}

@test "wrong format sequence ::1 1.0.0.2 ::3 causes format error" {
    run bash -c "printf '::1\n1.0.2\n::3\n' | ranges -I"
    assert_failure
    assert_output --partial "Error: Wrong input format on line '1.0.2'."

    run_pipe_with_memcheck "printf '::1\n1.0.2\n::3\n'" "ranges -I"
    assert_failure
    assert_output --partial "Error: Wrong input format on line '1.0.2'."
    assert_memcheck_ok

    run bash -c "printf '::1\n1.0.2\n::3\n' | ranges --ipv6"
    assert_failure
    assert_output --partial "Error: Wrong input format on line '1.0.2'."

    run_pipe_with_memcheck "printf '::1\n1.0.2\n::3\n'" "ranges --ipv6"
    assert_failure
    assert_output --partial "Error: Wrong input format on line '1.0.2'."
    assert_memcheck_ok
}

@test "wrong format sequence ::1 '::2 ' ::3 causes format error" {
    run bash -c "printf '::1\n::2 \n::3\n' | ranges -I"
    assert_failure
    assert_output --partial "Error: Wrong input format on line '::2 '."

    run_pipe_with_memcheck "printf '::1\n::2 \n::3\n'" "ranges -I"
    assert_failure
    assert_output --partial "Error: Wrong input format on line '::2 '."
    assert_memcheck_ok

    run bash -c "printf '::1\n::2 \n::3\n' | ranges --ipv6"
    assert_failure
    assert_output --partial "Error: Wrong input format on line '::2 '."

    run_pipe_with_memcheck "printf '::1\n::2 \n::3\n'" "ranges --ipv6"
    assert_failure
    assert_output --partial "Error: Wrong input format on line '::2 '."
    assert_memcheck_ok
}

@test "wrong format sequence ::1 '::1 ::2' ::3 causes format error" {
    run bash -c "printf '::1\n::1 ::2\n::3\n' | ranges -I"
    assert_failure
    assert_output --partial "Error: Wrong input format on line '::1 ::2'."

    run_pipe_with_memcheck "printf '::1\n::1 ::2\n::3\n'" "ranges -I"
    assert_failure
    assert_output --partial "Error: Wrong input format on line '::1 ::2'."
    assert_memcheck_ok

    run bash -c "printf '::1\n::1 ::2\n::3\n' | ranges --ipv6"
    assert_failure
    assert_output --partial "Error: Wrong input format on line '::1 ::2'."

    run_pipe_with_memcheck "printf '::1\n::1 ::2\n::3\n'" "ranges --ipv6"
    assert_failure
    assert_output --partial "Error: Wrong input format on line '::1 ::2'."
    assert_memcheck_ok
}

@test "unsorted sequence ::1 ::2 ::3 ::2 ::7 ::8 ::9 causes unsorted error" {
    run bash -c "printf '::1\n::2\n::3\n::2\n::7\n::8\n::9\n' | ranges -I"
    assert_failure
    assert_output --partial "Error: Input is not sorted on line '::2'."

    run_pipe_with_memcheck "printf '::1\n::2\n::3\n::2\n::7\n::8\n::9\n'" "ranges -I"
    assert_failure
    assert_output --partial "Error: Input is not sorted on line '::2'."
    assert_memcheck_ok

    run bash -c "printf '::1\n::2\n::3\n::2\n::7\n::8\n::9\n' | ranges --ipv6"
    assert_failure
    assert_output --partial "Error: Input is not sorted on line '::2'."

    run_pipe_with_memcheck "printf '::1\n::2\n::3\n::2\n::7\n::8\n::9\n'" "ranges --ipv6"
    assert_failure
    assert_output --partial "Error: Input is not sorted on line '::2'."
    assert_memcheck_ok
}
