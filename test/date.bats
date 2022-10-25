setup() {
    load 'helper/setup'
    _common_setup
}


@test "empty input causes empty output" {
    run bash -c "echo '' | ranges -d"
    assert_success
    assert_output ''

    run_pipe_with_memcheck "echo ''" "ranges -d"
    assert_success
    assert_memcheck_ok

    run bash -c "echo '' | ranges --date"
    assert_success
    assert_output ''

    run_pipe_with_memcheck "echo ''" "ranges --date"
    assert_success
    assert_memcheck_ok
}

@test "empty input lines cause empty output" {
    run bash -c "printf '\n\n\n' | ranges -d"
    assert_success
    assert_output ''

    run_pipe_with_memcheck "printf '\n\n\n'" "ranges -d"
    assert_success
    assert_memcheck_ok

    run bash -c "printf '\n\n\n' | ranges --date"
    assert_success
    assert_output ''

    run_pipe_with_memcheck "printf '\n\n\n'" "ranges --date"
    assert_success
    assert_memcheck_ok
}

@test "single line input 2022-01-01 works" {
    run bash -c "printf '2022-01-01\n' | ranges -d"
    assert_success
    assert_output '2022-01-01 2022-01-01'

    run_pipe_with_memcheck "printf '2022-01-01\n'" "ranges -d"
    assert_success
    assert_output --partial '2022-01-01 2022-01-01'
    assert_memcheck_ok

    run bash -c "printf '2022-01-01\n' | ranges --date"
    assert_success
    assert_output '2022-01-01 2022-01-01'

    run_pipe_with_memcheck "printf '2022-01-01\n'" "ranges --date"
    assert_success
    assert_output --partial '2022-01-01 2022-01-01'
    assert_memcheck_ok
}

@test "trivial sequence 2022-01-01 2022-01-02 2022-01-03 works" {
    run bash -c "printf '2022-01-01\n2022-01-02\n2022-01-03\n' | ranges -d"
    assert_success
    assert_output '2022-01-01 2022-01-03'

    run_pipe_with_memcheck "printf '2022-01-01\n2022-01-02\n2022-01-03\n'" "ranges -d"
    assert_success
    assert_output --partial '2022-01-01 2022-01-03'
    assert_memcheck_ok

    run bash -c "printf '2022-01-01\n2022-01-02\n2022-01-03\n' | ranges --date"
    assert_success
    assert_output '2022-01-01 2022-01-03'

    run_pipe_with_memcheck "printf '2022-01-01\n2022-01-02\n2022-01-03\n'" "ranges --date"
    assert_success
    assert_output --partial '2022-01-01 2022-01-03'
    assert_memcheck_ok
}

@test "simple sequence 2022-01-01 2022-01-02 2022-01-03 2022-01-07 2022-01-08 2022-01-09 works" {
    run bash -c "printf '2022-01-01\n2022-01-02\n2022-01-03\n2022-01-07\n2022-01-08\n2022-01-09\n' | ranges -d"
    assert_success
    assert_output "2022-01-01 2022-01-03
2022-01-07 2022-01-09"

    run_pipe_with_memcheck "printf '2022-01-01\n2022-01-02\n2022-01-03\n2022-01-07\n2022-01-08\n2022-01-09\n'" "ranges -d"
    assert_success
    assert_output --partial "2022-01-01 2022-01-03
2022-01-07 2022-01-09"
    assert_memcheck_ok

    run bash -c "printf '2022-01-01\n2022-01-02\n2022-01-03\n2022-01-07\n2022-01-08\n2022-01-09\n' | ranges --date"
    assert_success
    assert_output "2022-01-01 2022-01-03
2022-01-07 2022-01-09"

    run_pipe_with_memcheck "printf '2022-01-01\n2022-01-02\n2022-01-03\n2022-01-07\n2022-01-08\n2022-01-09\n'" "ranges --date"
    assert_success
    assert_output --partial "2022-01-01 2022-01-03
2022-01-07 2022-01-09"
    assert_memcheck_ok
}

@test "duplicate date sequence 2022-01-01 2022-01-02 2022-01-02 2022-01-02 2022-01-03 works" {
    run bash -c "printf '2022-01-01\n2022-01-02\n2022-01-02\n2022-01-02\n2022-01-03\n' | ranges -d"
    assert_success
    assert_output '2022-01-01 2022-01-03'

    run_pipe_with_memcheck "printf '2022-01-01\n2022-01-02\n2022-01-02\n2022-01-02\n2022-01-03\n'" "ranges -d"
    assert_success
    assert_output --partial '2022-01-01 2022-01-03'
    assert_memcheck_ok

    run bash -c "printf '2022-01-01\n2022-01-02\n2022-01-02\n2022-01-02\n2022-01-03\n' | ranges --date"
    assert_success
    assert_output '2022-01-01 2022-01-03'

    run_pipe_with_memcheck "printf '2022-01-01\n2022-01-02\n2022-01-02\n2022-01-02\n2022-01-03\n'" "ranges --date"
    assert_success
    assert_output --partial '2022-01-01 2022-01-03'
    assert_memcheck_ok
}

@test "dumplicate date sequence 2022-01-01 2022-01-01 2022-01-01 2022-01-01 2022-01-01 2022-01-03 2022-01-04 2022-01-05 2022-01-05 2022-01-05 works" {
    run bash -c "printf -- '2022-01-01\n2022-01-01\n2022-01-01\n2022-01-01\n2022-01-01\n2022-01-03\n2022-01-04\n2022-01-05\n2022-01-05\n2022-01-05\n' | ranges -d"
    assert_success
    assert_output "2022-01-01 2022-01-01
2022-01-03 2022-01-05"

    run_pipe_with_memcheck "printf -- '2022-01-01\n2022-01-01\n2022-01-01\n2022-01-01\n2022-01-01\n2022-01-03\n2022-01-04\n2022-01-05\n2022-01-05\n2022-01-05\n'" "ranges -d"
    assert_success
    assert_output --partial "2022-01-01 2022-01-01
2022-01-03 2022-01-05"
    assert_memcheck_ok

    run bash -c "printf -- '2022-01-01\n2022-01-01\n2022-01-01\n2022-01-01\n2022-01-01\n2022-01-03\n2022-01-04\n2022-01-05\n2022-01-05\n2022-01-05\n' | ranges --date"
    assert_success
    assert_output "2022-01-01 2022-01-01
2022-01-03 2022-01-05"

    run_pipe_with_memcheck "printf -- '2022-01-01\n2022-01-01\n2022-01-01\n2022-01-01\n2022-01-01\n2022-01-03\n2022-01-04\n2022-01-05\n2022-01-05\n2022-01-05\n'" "ranges --date"
    assert_success
    assert_output --partial "2022-01-01 2022-01-01
2022-01-03 2022-01-05"
    assert_memcheck_ok
}

@test "wrong format sequence 2022-01-01 01/01/2022 2022-01-03 causes format error" {
    run bash -c "printf '2022-01-01\n01/01/2022\n2022-01-03\n' | ranges -d"
    assert_failure
    assert_output --partial "Error: Wrong input format on line '01/01/2022'."

    run_pipe_with_memcheck "printf '2022-01-01\n01/01/2022\n2022-01-03\n'" "ranges -d"
    assert_failure
    assert_output --partial "Error: Wrong input format on line '01/01/2022'."
    assert_memcheck_ok

    run bash -c "printf '2022-01-01\n01/01/2022\n2022-01-03\n' | ranges --date"
    assert_failure
    assert_output --partial "Error: Wrong input format on line '01/01/2022'."

    run_pipe_with_memcheck "printf '2022-01-01\n01/01/2022\n2022-01-03\n'" "ranges --date"
    assert_failure
    assert_output --partial "Error: Wrong input format on line '01/01/2022'."
    assert_memcheck_ok
}

@test "wrong format sequence 2022-01-01 '2022-01-02 ' 2022-01-03 causes format error" {
    run bash -c "printf '2022-01-01\n2022-01-02 \n2022-01-03\n' | ranges -d"
    assert_failure
    assert_output --partial "Error: Wrong input format on line '2022-01-02 '."

    run_pipe_with_memcheck "printf '2022-01-01\n2022-01-02 \n2022-01-03\n'" "ranges -d"
    assert_failure
    assert_output --partial "Error: Wrong input format on line '2022-01-02 '."
    assert_memcheck_ok

    run bash -c "printf '2022-01-01\n2022-01-02 \n2022-01-03\n' | ranges --date"
    assert_failure
    assert_output --partial "Error: Wrong input format on line '2022-01-02 '."

    run_pipe_with_memcheck "printf '2022-01-01\n2022-01-02 \n2022-01-03\n'" "ranges --date"
    assert_failure
    assert_output --partial "Error: Wrong input format on line '2022-01-02 '."
    assert_memcheck_ok
}

@test "wrong format sequence 2022-01-01 '2022-01-01 2022-01-02' 2022-01-03 causes format error" {
    run bash -c "printf '2022-01-01\n2022-01-01 2022-01-02\n2022-01-03\n' | ranges -d"
    assert_failure
    assert_output --partial "Error: Wrong input format on line '2022-01-01 2022-01-02'."

    run_pipe_with_memcheck "printf '2022-01-01\n2022-01-01 2022-01-02\n2022-01-03\n'" "ranges -d"
    assert_failure
    assert_output --partial "Error: Wrong input format on line '2022-01-01 2022-01-02'."
    assert_memcheck_ok

    run bash -c "printf '2022-01-01\n2022-01-01 2022-01-02\n2022-01-03\n' | ranges --date"
    assert_failure
    assert_output --partial "Error: Wrong input format on line '2022-01-01 2022-01-02'."

    run_pipe_with_memcheck "printf '2022-01-01\n2022-01-01 2022-01-02\n2022-01-03\n'" "ranges --date"
    assert_failure
    assert_output --partial "Error: Wrong input format on line '2022-01-01 2022-01-02'."
    assert_memcheck_ok
}

@test "unsorted sequence 2022-01-01 2022-01-02 2022-01-03 2022-01-02 2022-01-07 2022-01-08 2022-01-09 causes unsorted error" {
    run bash -c "printf '2022-01-01\n2022-01-02\n2022-01-03\n2022-01-02\n2022-01-07\n2022-01-08\n2022-01-09\n' | ranges -d"
    assert_failure
    assert_output --partial "Error: Input is not sorted on line '2022-01-02'."

    run_pipe_with_memcheck "printf '2022-01-01\n2022-01-02\n2022-01-03\n2022-01-02\n2022-01-07\n2022-01-08\n2022-01-09\n'" "ranges -d"
    assert_failure
    assert_output --partial "Error: Input is not sorted on line '2022-01-02'."
    assert_memcheck_ok

    run bash -c "printf '2022-01-01\n2022-01-02\n2022-01-03\n2022-01-02\n2022-01-07\n2022-01-08\n2022-01-09\n' | ranges --date"
    assert_failure
    assert_output --partial "Error: Input is not sorted on line '2022-01-02'."

    run_pipe_with_memcheck "printf '2022-01-01\n2022-01-02\n2022-01-03\n2022-01-02\n2022-01-07\n2022-01-08\n2022-01-09\n'" "ranges --date"
    assert_failure
    assert_output --partial "Error: Input is not sorted on line '2022-01-02'."
    assert_memcheck_ok
}

@test "year change sequence 2022-12-01 2023-01-01 works" {
    run bash -c "printf '2022-12-31\n2023-01-01\n' | ranges -d"
    assert_success
    assert_output "2022-12-31 2023-01-01"

    run_pipe_with_memcheck "printf '2022-12-31\n2023-01-01\n'" "ranges -d"
    assert_success
    assert_output --partial "2022-12-31 2023-01-01"
    assert_memcheck_ok

    run bash -c "printf '2022-12-31\n2023-01-01\n' | ranges --date"
    assert_success
    assert_output "2022-12-31 2023-01-01"

    run_pipe_with_memcheck "printf '2022-12-31\n2023-01-01\n'" "ranges --date"
    assert_success
    assert_output --partial "2022-12-31 2023-01-01"
    assert_memcheck_ok
}

@test "leap year sequence 2024-02-28 2024-02-29 2024-03-01 works" {
    run bash -c "printf '2024-02-28\n2024-02-29\n2024-03-01\n' | ranges -d"
    assert_success
    assert_output "2024-02-28 2024-03-01"

    run_pipe_with_memcheck "printf '2024-02-28\n2024-02-29\n2024-03-01\n'" "ranges -d"
    assert_success
    assert_output --partial "2024-02-28 2024-03-01"
    assert_memcheck_ok

    run bash -c "printf '2024-02-28\n2024-02-29\n2024-03-01\n' | ranges --date"
    assert_success
    assert_output "2024-02-28 2024-03-01"

    run_pipe_with_memcheck "printf '2024-02-28\n2024-02-29\n2024-03-01\n'" "ranges --date"
    assert_success
    assert_output --partial "2024-02-28 2024-03-01"
    assert_memcheck_ok
}

@test "extra day in non-leap year sequence 2023-02-28 2023-02-29 2023-03-01 fails" {
    run bash -c "printf '2023-02-28\n2023-02-29\n2023-03-01\n' | ranges -d"
    assert_failure
    assert_output --partial "Error: Invalid date on line '2023-02-29'."

    run_pipe_with_memcheck "printf '2023-02-28\n2023-02-29\n2023-03-01\n'" "ranges -d"
    assert_failure
    assert_output --partial "Error: Invalid date on line '2023-02-29'."
    assert_memcheck_ok

    run bash -c "printf '2023-02-28\n2023-02-29\n2023-03-01\n' | ranges --date"
    assert_failure
    assert_output --partial "Error: Invalid date on line '2023-02-29'."

    run_pipe_with_memcheck "printf '2023-02-28\n2023-02-29\n2023-03-01\n'" "ranges --date"
    assert_failure
    assert_output --partial "Error: Invalid date on line '2023-02-29'."
    assert_memcheck_ok
}
