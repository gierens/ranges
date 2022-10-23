setup() {
    load 'helper/setup'
    _common_setup
}


@test "empty input causes empty output" {
    run bash -c "echo '' | ranges -I"
    assert_success
    assert_output ''

    run bash -c "echo '' | ranges --ipv6"
    assert_success
    assert_output ''
}
 
@test "empty input lines cause empty output" {
    run bash -c "printf '\n\n\n' | ranges -I"
    assert_success
    assert_output ''

    run bash -c "printf '\n\n\n' | ranges --ipv6"
    assert_success
    assert_output ''
}

@test "single line input ::1 works" {
    run bash -c "printf '::1\n' | ranges -I"
    assert_success
    assert_output '::1 ::1'

    run bash -c "printf '::1\n' | ranges --ipv6"
    assert_success
    assert_output '::1 ::1'
}

@test "full ipv6 format single line input 0000:0000:0000:0000:0000:0000:0000:0001 works" {
    run bash -c "printf '0000:0000:0000:0000:0000:0000:0000:0001\n' | ranges -I"
    assert_success
    assert_output '::1 ::1'

    run bash -c "printf '0000:0000:0000:0000:0000:0000:0000:0001\n' | ranges --ipv6"
    assert_success
    assert_output '::1 ::1'
}

@test "trivial sequence ::1 ::2 ::3 works" {
    run bash -c "printf '::1\n::2\n::3\n' | ranges -I"
    assert_success
    assert_output '::1 ::3'

    run bash -c "printf '::1\n::2\n::3\n' | ranges --ipv6"
    assert_success
    assert_output '::1 ::3'
}

@test "simple sequence ::1 ::2 ::3 ::7 ::8 ::9 works" {
    run bash -c "printf '\n::1\n::2\n::3\n::7\n::8\n::9\n' | ranges -I"
    assert_success
    assert_output "::1 ::3
::7 ::9"

    run bash -c "printf '\n::1\n::2\n::3\n::7\n::8\n::9\n' | ranges --ipv6"
    assert_success
    assert_output "::1 ::3
::7 ::9"
}

@test "duplicate ip sequence ::1 ::2 ::2 ::2 ::3 works" {
    run bash -c "printf '::1\n::2\n::2\n::2\n::3\n' | ranges -I"
    assert_success
    assert_output '::1 ::3'

    run bash -c "printf '::1\n::2\n::2\n::2\n::3\n' | ranges --ipv6"
    assert_success
    assert_output '::1 ::3'
}

@test "dumplicate ip sequence :: :: :: :: ::1 ::3 ::4 ::5 ::5 ::5 works" {
    run bash -c "printf -- '::\n::\n::\n::\n::1\n::3\n::4\n::5\n::5\n::5\n' | ranges -I"
    assert_success
    assert_output ":: ::1
::3 ::5"

    run bash -c "printf -- '::\n::\n::\n::\n::1\n::3\n::4\n::5\n::5\n::5\n' | ranges --ipv6"
    assert_success
    assert_output ":: ::1
::3 ::5"
}

@test "wrong format sequence ::1 1.0.0.2 ::3 causes format error" {
    run bash -c "printf '::1\n1.0.2\n::3\n' | ranges -I"
    assert_failure
    assert_output --partial "Error: Wrong input format on line '1.0.2'."

    run bash -c "printf '::1\n1.0.2\n::3\n' | ranges --ipv6"
    assert_failure
    assert_output --partial "Error: Wrong input format on line '1.0.2'."
}

@test "wrong format sequence ::1 '::2 ' ::3 causes format error" {
    run bash -c "printf '::1\n::2 \n::3\n' | ranges -I"
    assert_failure
    assert_output --partial "Error: Wrong input format on line '::2 '."

    run bash -c "printf '::1\n::2 \n::3\n' | ranges --ipv6"
    assert_failure
    assert_output --partial "Error: Wrong input format on line '::2 '."
}

@test "wrong format sequence ::1 '::1 ::2' ::3 causes format error" {
    run bash -c "printf '::1\n::1 ::2\n::3\n' | ranges -I"
    assert_failure
    assert_output --partial "Error: Wrong input format on line '::1 ::2'."

    run bash -c "printf '::1\n::1 ::2\n::3\n' | ranges --ipv6"
    assert_failure
    assert_output --partial "Error: Wrong input format on line '::1 ::2'."
}

@test "unsorted sequence ::1 ::2 ::3 ::2 ::7 ::8 ::9 causes unsorted error" {
    run bash -c "printf '::1\n::2\n::3\n::2\n::7\n::8\n::9\n' | ranges -I"
    assert_failure
    assert_output --partial "Error: Input is not sorted on line '::2'."

    run bash -c "printf '::1\n::2\n::3\n::2\n::7\n::8\n::9\n' | ranges --ipv6"
    assert_failure
    assert_output --partial "Error: Input is not sorted on line '::2'."
}
