setup() {
    load 'helper/setup'
    _common_setup
}


@test "empty input causes empty output" {
    run bash -c "echo '' | ranges -d"
    assert_success
    assert_output ''

    run bash -c "echo '' | ranges --date"
    assert_success
    assert_output ''
}

@test "empty input lines cause empty output" {
    run bash -c "printf '\n\n\n' | ranges -d"
    assert_success
    assert_output ''

    run bash -c "printf '\n\n\n' | ranges --date"
    assert_success
    assert_output ''
}

@test "single line input 2022-01-01 works" {
    run bash -c "printf '2022-01-01\n' | ranges -d"
    assert_success
    assert_output '2022-01-01 2022-01-01'

    run bash -c "printf '2022-01-01\n' | ranges --date"
    assert_success
    assert_output '2022-01-01 2022-01-01'
}

@test "trivial sequence 2022-01-01 2022-01-02 2022-01-03 works" {
    run bash -c "printf '2022-01-01\n2022-01-02\n2022-01-03\n' | ranges -d"
    assert_success
    assert_output '2022-01-01 2022-01-03'

    run bash -c "printf '2022-01-01\n2022-01-02\n2022-01-03\n' | ranges --date"
    assert_success
    assert_output '2022-01-01 2022-01-03'
}

@test "simple sequence 2022-01-01 2022-01-02 2022-01-03 2022-01-07 2022-01-08 2022-01-09 works" {
    run bash -c "printf '2022-01-01\n2022-01-02\n2022-01-03\n2022-01-07\n2022-01-08\n2022-01-09\n' | ranges -d"
    assert_success
    assert_output "2022-01-01 2022-01-03
2022-01-07 2022-01-09"

    run bash -c "printf '2022-01-01\n2022-01-02\n2022-01-03\n2022-01-07\n2022-01-08\n2022-01-09\n' | ranges --date"
    assert_success
    assert_output "2022-01-01 2022-01-03
2022-01-07 2022-01-09"
}

@test "duplicate date sequence 2022-01-01 2022-01-02 2022-01-02 2022-01-02 2022-01-03 works" {
    run bash -c "printf '2022-01-01\n2022-01-02\n2022-01-02\n2022-01-02\n2022-01-03\n' | ranges -d"
    assert_success
    assert_output '2022-01-01 2022-01-03'

    run bash -c "printf '2022-01-01\n2022-01-02\n2022-01-02\n2022-01-02\n2022-01-03\n' | ranges --date"
    assert_success
    assert_output '2022-01-01 2022-01-03'
}

@test "dumplicate date sequence 2022-01-01 2022-01-01 2022-01-01 2022-01-01 2022-01-01 2022-01-03 2022-01-04 2022-01-05 2022-01-05 2022-01-05 works" {
    run bash -c "printf -- '2022-01-01\n2022-01-01\n2022-01-01\n2022-01-01\n2022-01-01\n2022-01-03\n2022-01-04\n2022-01-05\n2022-01-05\n2022-01-05\n' | ranges -d"
    assert_success
    assert_output "2022-01-01 2022-01-01
2022-01-03 2022-01-05"

    run bash -c "printf -- '2022-01-01\n2022-01-01\n2022-01-01\n2022-01-01\n2022-01-01\n2022-01-03\n2022-01-04\n2022-01-05\n2022-01-05\n2022-01-05\n' | ranges --date"
    assert_success
    assert_output "2022-01-01 2022-01-01
2022-01-03 2022-01-05"
}

@test "wrong format sequence 2022-01-01 01/01/2022 2022-01-03 causes format error" {
    run bash -c "printf '2022-01-01\n01/01/2022\n2022-01-03\n' | ranges -d"
    assert_failure
    assert_output --partial "Error: Wrong input format on line '01/01/2022'."

    run bash -c "printf '2022-01-01\n01/01/2022\n2022-01-03\n' | ranges --date"
    assert_failure
    assert_output --partial "Error: Wrong input format on line '01/01/2022'."
}

@test "wrong format sequence 2022-01-01 '2022-01-02 ' 2022-01-03 causes format error" {
    run bash -c "printf '2022-01-01\n2022-01-02 \n2022-01-03\n' | ranges -d"
    assert_failure
    assert_output --partial "Error: Wrong input format on line '2022-01-02 '."

    run bash -c "printf '2022-01-01\n2022-01-02 \n2022-01-03\n' | ranges --date"
    assert_failure
    assert_output --partial "Error: Wrong input format on line '2022-01-02 '."
}

@test "wrong format sequence 2022-01-01 '2022-01-01 2022-01-02' 2022-01-03 causes format error" {
    run bash -c "printf '2022-01-01\n2022-01-01 2022-01-02\n2022-01-03\n' | ranges -d"
    assert_failure
    assert_output --partial "Error: Wrong input format on line '2022-01-01 2022-01-02'."

    run bash -c "printf '2022-01-01\n2022-01-01 2022-01-02\n2022-01-03\n' | ranges --date"
    assert_failure
    assert_output --partial "Error: Wrong input format on line '2022-01-01 2022-01-02'."
}

@test "unsorted sequence 2022-01-01 2022-01-02 2022-01-03 2022-01-02 2022-01-07 2022-01-08 2022-01-09 causes unsorted error" {
    run bash -c "printf '2022-01-01\n2022-01-02\n2022-01-03\n2022-01-02\n2022-01-07\n2022-01-08\n2022-01-09\n' | ranges -d"
    assert_failure
    assert_output --partial "Error: Input is not sorted on line '2022-01-02'."

    run bash -c "printf '2022-01-01\n2022-01-02\n2022-01-03\n2022-01-02\n2022-01-07\n2022-01-08\n2022-01-09\n' | ranges --date"
    assert_failure
    assert_output --partial "Error: Input is not sorted on line '2022-01-02'."
}

# TODO test year change
@test "year change sequence 2022-12-01 2023-01-01 works" {
    run bash -c "printf '2022-12-31\n2023-01-01\n' | ranges -d"
    assert_success
    assert_output "2022-12-31 2023-01-01"

    run bash -c "printf '2022-12-31\n2023-01-01\n' | ranges --date"
    assert_success
    assert_output "2022-12-31 2023-01-01"
}

@test "leap year sequence 2024-02-28 2024-02-29 2024-03-01 works" {
    run bash -c "printf '2024-02-28\n2024-02-29\n2024-03-01\n' | ranges -d"
    assert_success
    assert_output "2024-02-28 2024-03-01"

    run bash -c "printf '2024-02-28\n2024-02-29\n2024-03-01\n' | ranges --date"
    assert_success
    assert_output "2024-02-28 2024-03-01"
}

@test "extra day in non-leap year sequence 2023-02-28 2023-02-29 2023-03-01 fails" {
    run bash -c "printf '2023-02-28\n2023-02-29\n2023-03-01\n' | ranges -d"
    assert_failure
    assert_output --partial "Error: Invalid date on line '2023-02-29'."

    run bash -c "printf '2023-02-28\n2023-02-29\n2023-03-01\n' | ranges --date"
    assert_failure
    assert_output --partial "Error: Invalid date on line '2023-02-29'."
}
