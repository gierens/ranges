#!/use/bin/env bash

_valgrind_setup() {
    MEMCHECK="valgrind --tool=memcheck --leak-check=full --show-leak-kinds=all"
    MEMCHECK_OK_MSG1="All heap blocks were freed -- no leaks are possible"
    MEMCHECK_OK_MSG2="ERROR SUMMARY: 0 errors from 0 contexts"
}

run_with_memcheck() {
    run ${MEMCHECK} $@
}

run_pipe_with_memcheck() {
    run bash -c "$1 | ${MEMCHECK} $2"
}

assert_memcheck_ok() {
    assert_line --partial "$MEMCHECK_OK_MSG1"
    assert_line --partial "$MEMCHECK_OK_MSG2"
}
