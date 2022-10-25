setup() {
    load 'helper/setup'
    _common_setup
}


@test "empty input causes empty output" {
    run bash -c "echo '' | ranges -i"
    assert_success
    assert_output ''

    run_pipe_with_memcheck "echo ''" "ranges -i"
    assert_success
    assert_memcheck_ok

    run bash -c "echo '' | ranges --ipv4"
    assert_success
    assert_output ''
    
    run_pipe_with_memcheck "echo ''" "ranges --ipv4"
    assert_success
    assert_memcheck_ok
}
 
@test "empty input lines cause empty output" {
    run bash -c "printf '\n\n\n' | ranges -i"
    assert_success
    assert_output ''

    run_pipe_with_memcheck "printf '\n\n\n'" "ranges -i"
    assert_success
    assert_memcheck_ok

    run bash -c "printf '\n\n\n' | ranges --ipv4"
    assert_success
    assert_output ''

    run_pipe_with_memcheck "printf '\n\n\n'" "ranges --ipv4"
    assert_success
    assert_memcheck_ok
}

@test "single line input 127.0.0.1 works" {
    run bash -c "printf '127.0.0.1\n' | ranges -i"
    assert_success
    assert_output '127.0.0.1 127.0.0.1'

    run_pipe_with_memcheck "printf '127.0.0.1\n'" "ranges -i"
    assert_success
    assert_output --partial '127.0.0.1 127.0.0.1'
    assert_memcheck_ok

    run bash -c "printf '127.0.0.1\n' | ranges --ipv4"
    assert_success
    assert_output '127.0.0.1 127.0.0.1'

    run_pipe_with_memcheck "printf '127.0.0.1\n'" "ranges --ipv4"
    assert_success
    assert_output --partial '127.0.0.1 127.0.0.1'
    assert_memcheck_ok
}

@test "trivial sequence 1.0.0.1 1.0.0.2 1.0.0.3 works" {
    run bash -c "printf '1.0.0.1\n1.0.0.2\n1.0.0.3\n' | ranges -i"
    assert_success
    assert_output '1.0.0.1 1.0.0.3'

    run_pipe_with_memcheck "printf '1.0.0.1\n1.0.0.2\n1.0.0.3\n'" "ranges -i"
    assert_success
    assert_output --partial '1.0.0.1 1.0.0.3'
    assert_memcheck_ok

    run bash -c "printf '1.0.0.1\n1.0.0.2\n1.0.0.3\n' | ranges --ipv4"
    assert_success
    assert_output '1.0.0.1 1.0.0.3'

    run_pipe_with_memcheck "printf '1.0.0.1\n1.0.0.2\n1.0.0.3\n'" "ranges --ipv4"
    assert_success
    assert_output --partial '1.0.0.1 1.0.0.3'
    assert_memcheck_ok
}

@test "simple sequence 1.0.0.1 1.0.0.2 1.0.0.3 1.0.0.7 1.0.0.8 1.0.0.9 works" {
    run bash -c "printf '\n1.0.0.1\n1.0.0.2\n1.0.0.3\n1.0.0.7\n1.0.0.8\n1.0.0.9\n' | ranges -i"
    assert_success
    assert_output "1.0.0.1 1.0.0.3
1.0.0.7 1.0.0.9"

    run_pipe_with_memcheck "printf '\n1.0.0.1\n1.0.0.2\n1.0.0.3\n1.0.0.7\n1.0.0.8\n1.0.0.9\n'" " ranges -i"
    assert_success
    assert_output --partial "1.0.0.1 1.0.0.3
1.0.0.7 1.0.0.9"
    assert_memcheck_ok

    run bash -c "printf '\n1.0.0.1\n1.0.0.2\n1.0.0.3\n1.0.0.7\n1.0.0.8\n1.0.0.9\n' | ranges --ipv4"
    assert_success
    assert_output "1.0.0.1 1.0.0.3
1.0.0.7 1.0.0.9"

    run_pipe_with_memcheck "printf '\n1.0.0.1\n1.0.0.2\n1.0.0.3\n1.0.0.7\n1.0.0.8\n1.0.0.9\n'" "ranges --ipv4"
    assert_success
    assert_output --partial "1.0.0.1 1.0.0.3
1.0.0.7 1.0.0.9"
    assert_memcheck_ok
}

@test "duplicate ip sequence 1.0.0.1 1.0.0.2 1.0.0.2 1.0.0.2 1.0.0.3 works" {
    run bash -c "printf '1.0.0.1\n1.0.0.2\n1.0.0.2\n1.0.0.2\n1.0.0.3\n' | ranges -i"
    assert_success
    assert_output '1.0.0.1 1.0.0.3'

    run_pipe_with_memcheck "printf '1.0.0.1\n1.0.0.2\n1.0.0.2\n1.0.0.2\n1.0.0.3\n'" "ranges -i"
    assert_success
    assert_output --partial '1.0.0.1 1.0.0.3'
    assert_memcheck_ok

    run bash -c "printf '1.0.0.1\n1.0.0.2\n1.0.0.2\n1.0.0.2\n1.0.0.3\n' | ranges --ipv4"
    assert_success
    assert_output '1.0.0.1 1.0.0.3'

    run_pipe_with_memcheck "printf '1.0.0.1\n1.0.0.2\n1.0.0.2\n1.0.0.2\n1.0.0.3\n'" "ranges --ipv4"
    assert_success
    assert_output --partial '1.0.0.1 1.0.0.3'
    assert_memcheck_ok
}

@test "dumplicate ip sequence 1.0.0.0 1.0.0.0 1.0.0.0 1.0.0.0 1.0.0.1 1.0.0.3 1.0.0.4 1.0.0.5 1.0.0.5 1.0.0.5 works" {
    run bash -c "printf -- '1.0.0.0\n1.0.0.0\n1.0.0.0\n1.0.0.0\n1.0.0.1\n1.0.0.3\n1.0.0.4\n1.0.0.5\n1.0.0.5\n1.0.0.5\n' | ranges -i"
    assert_success
    assert_output "1.0.0.0 1.0.0.1
1.0.0.3 1.0.0.5"

    run_pipe_with_memcheck "printf -- '1.0.0.0\n1.0.0.0\n1.0.0.0\n1.0.0.0\n1.0.0.1\n1.0.0.3\n1.0.0.4\n1.0.0.5\n1.0.0.5\n1.0.0.5\n'" "ranges -i"
    assert_success
    assert_output --partial "1.0.0.0 1.0.0.1
1.0.0.3 1.0.0.5"
    assert_memcheck_ok

    run bash -c "printf -- '1.0.0.0\n1.0.0.0\n1.0.0.0\n1.0.0.0\n1.0.0.1\n1.0.0.3\n1.0.0.4\n1.0.0.5\n1.0.0.5\n1.0.0.5\n' | ranges --ipv4"
    assert_success
    assert_output "1.0.0.0 1.0.0.1
1.0.0.3 1.0.0.5"

    run_pipe_with_memcheck "printf -- '1.0.0.0\n1.0.0.0\n1.0.0.0\n1.0.0.0\n1.0.0.1\n1.0.0.3\n1.0.0.4\n1.0.0.5\n1.0.0.5\n1.0.0.5\n'" "ranges --ipv4"
    assert_success
    assert_output --partial "1.0.0.0 1.0.0.1
1.0.0.3 1.0.0.5"
    assert_memcheck_ok
}

@test "wrong format sequence 1.0.0.1 1.0.2 1.0.0.3 causes format error" {
    run bash -c "printf '1.0.0.1\n1.0.2\n1.0.0.3\n' | ranges -i"
    assert_failure
    assert_output --partial "Error: Wrong input format on line '1.0.2'."

    run_pipe_with_memcheck "printf '1.0.0.1\n1.0.2\n1.0.0.3\n'" "ranges -i"
    assert_failure
    assert_output --partial "Error: Wrong input format on line '1.0.2'."
    assert_memcheck_ok

    run bash -c "printf '1.0.0.1\n1.0.2\n1.0.0.3\n' | ranges --ipv4"
    assert_failure
    assert_output --partial "Error: Wrong input format on line '1.0.2'."

    run_pipe_with_memcheck "printf '1.0.0.1\n1.0.2\n1.0.0.3\n'" "ranges --ipv4"
    assert_failure
    assert_output --partial "Error: Wrong input format on line '1.0.2'."
    assert_memcheck_ok
}

@test "wrong format sequence 1.0.0.1 '1.0.0.2 ' 1.0.0.3 causes format error" {
    run bash -c "printf '1.0.0.1\n1.0.0.2 \n1.0.0.3\n' | ranges -i"
    assert_failure
    assert_output --partial "Error: Wrong input format on line '1.0.0.2 '."

    run_pipe_with_memcheck "printf '1.0.0.1\n1.0.0.2 \n1.0.0.3\n'" "ranges -i"
    assert_failure
    assert_output --partial "Error: Wrong input format on line '1.0.0.2 '."
    assert_memcheck_ok

    run bash -c "printf '1.0.0.1\n1.0.0.2 \n1.0.0.3\n' | ranges --ipv4"
    assert_failure
    assert_output --partial "Error: Wrong input format on line '1.0.0.2 '."

    run_pipe_with_memcheck "printf '1.0.0.1\n1.0.0.2 \n1.0.0.3\n'" "ranges --ipv4"
    assert_failure
    assert_output --partial "Error: Wrong input format on line '1.0.0.2 '."
    assert_memcheck_ok
}

@test "wrong format sequence 1.0.0.1 '1.0.0.1 1.0.0.2' 1.0.0.3 causes format error" {
    run bash -c "printf '1.0.0.1\n1.0.0.1 1.0.0.2\n1.0.0.3\n' | ranges -i"
    assert_failure
    assert_output --partial "Error: Wrong input format on line '1.0.0.1 1.0.0.2'."

    run_pipe_with_memcheck "printf '1.0.0.1\n1.0.0.1 1.0.0.2\n1.0.0.3\n'" "ranges -i"
    assert_failure
    assert_output --partial "Error: Wrong input format on line '1.0.0.1 1.0.0.2'."
    assert_memcheck_ok

    run bash -c "printf '1.0.0.1\n1.0.0.1 1.0.0.2\n1.0.0.3\n' | ranges --ipv4"
    assert_failure
    assert_output --partial "Error: Wrong input format on line '1.0.0.1 1.0.0.2'."

    run_pipe_with_memcheck "printf '1.0.0.1\n1.0.0.1 1.0.0.2\n1.0.0.3\n'" "ranges --ipv4"
    assert_failure
    assert_output --partial "Error: Wrong input format on line '1.0.0.1 1.0.0.2'."
    assert_memcheck_ok
}

@test "unsorted sequence 1.0.0.1 1.0.0.2 1.0.0.3 1.0.0.2 1.0.0.7 1.0.0.8 1.0.0.9 causes unsorted error" {
    run bash -c "printf '1.0.0.1\n1.0.0.2\n1.0.0.3\n1.0.0.2\n1.0.0.7\n1.0.0.8\n1.0.0.9\n' | ranges -i"
    assert_failure
    assert_output --partial "Error: Input is not sorted on line '1.0.0.2'."

    run_pipe_with_memcheck "printf '1.0.0.1\n1.0.0.2\n1.0.0.3\n1.0.0.2\n1.0.0.7\n1.0.0.8\n1.0.0.9\n'" "ranges -i"
    assert_failure
    assert_output --partial "Error: Input is not sorted on line '1.0.0.2'."
    assert_memcheck_ok

    run bash -c "printf '1.0.0.1\n1.0.0.2\n1.0.0.3\n1.0.0.2\n1.0.0.7\n1.0.0.8\n1.0.0.9\n' | ranges --ipv4"
    assert_failure
    assert_output --partial "Error: Input is not sorted on line '1.0.0.2'."

    run_pipe_with_memcheck "printf '1.0.0.1\n1.0.0.2\n1.0.0.3\n1.0.0.2\n1.0.0.7\n1.0.0.8\n1.0.0.9\n'" "ranges --ipv4"
    assert_failure
    assert_output --partial "Error: Input is not sorted on line '1.0.0.2'."
    assert_memcheck_ok
}
