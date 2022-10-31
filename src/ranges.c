#define _GNU_SOURCE
#define _XOPEN_SOURCE
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <getopt.h>
#include <stdbool.h>
#include <errno.h>
#include <string.h>
#include <sys/stat.h>
#include <limits.h>
#include <time.h>
#include <arpa/inet.h>


void print_usage(void)
{
    printf("Usage: ranges [-H|-o|-b|-d|-i|-I|-m] [-s] [-f] [-h] [FILE]\n");
}

void print_usage_with_help_remark(void)
{
    print_usage();
    printf("Try 'ranges -h' for more information\n");
}


void print_help(void)
{
    print_usage();
    printf("\n"
           "Ranges is a command line program to extract ranges from various\n"
           "types of lists, signed decimal integer numbers by default, but \n"
           "also dates, IP or MAC addresses.\n"
           "\n"
           "Note that the input is assumed to be sorted already. Duplicates\n"
           "don't need to be removed however.\n"
           "\n"
           "Optional arguments:\n"
           "  FILE            Path to input file. If not specified, stdin is "
           "                  used, which has to be a pipe and not a tty.\n"
           "  -H, --hex       Extract unsigned hexadecimal number "
           "ranges. (Format: 0x1)\n"
           "  -o, --octal     Extract unsigned octal number ranges. "
           "(Format: 0o1)\n"
           "  -b, --binary    Extract unsigned binary number ranges. "
           "(Format: 0b1)\n"
           "  -d, --date      Extract date ranges. "
           "(Format: 2022-01-01)\n"
           "  -i, --ipv4      Extract IPv4 address ranges. "
           "(Format: 10.0.0.1)\n"
           "  -I, --ipv6      Extract IPv6 address ranges. "
           "(Format: ::1)\n"
           "  -m, --mac       Extract MAC address ranges. "
           "(Format: 00:00:00:00:00:01)\n"
           "  -s, --size      Print the size of the ranges as third column.\n"
           "  -f, --force     Force execution and ignore parsing errors.\n"
           "  -h, --help      Print this help message.\n"
           "  -v, --version   Print version information.\n"
           "\n"
           "Example:\n"
           "  bash $> printf '1\\n2\\n3\\n6\\n7\\n9\\n10\\n11\\n' | ranges\n"
           "  1 3\n"
           "  6 7\n"
           "  9 11\n"
           "\n"
           "For more information, to contribute to the project or to file\n"
           "issues see the GitHub page: <https://github.com/gierens/ranges>\n"
           );
}


void print_version(void)
{
    printf("ranges 0.1\n"
           "Copyright (C) 2022 Sandro-Alessio Gierens\n"
           "License GPLv3+: GNU GPL version 3 or later "
           "<https://gnu.org/licenses/gpl.html>.\n"
           "This is free software, you are free to change and redistribute "
           "it.\n"
           "This program comes with ABSOLUTELY NO WARRANTY.\n"
           );
}


static struct option long_options[] = {
    {"hex",     no_argument, 0, 'H'},
    {"octal",   no_argument, 0, 'o'},
    {"binary",  no_argument, 0, 'b'},
    {"date",    no_argument, 0, 'd'},
    {"ipv4",    no_argument, 0, 'i'},
    {"ipv6",    no_argument, 0, 'I'},
    {"mac",     no_argument, 0, 'm'},
    {"size",    no_argument, 0, 's'},
    {"force",   no_argument, 0, 'f'},
    {"help",    no_argument, 0, 'h'},
    {"version", no_argument, 0, 'v'},
};

static const char* optstring = "HobdiImsfhv";


int extract_decimal_number_ranges(FILE *stream, int print_size, int force)
{
    char *line = NULL;
    size_t len = 0;
    ssize_t line_len = 0;
    bool first = true;
    long long int range_end = 0;
    long long int number = 0;
    char *invalid = NULL;
    errno = 0;
    int rc = EXIT_SUCCESS;
    size_t range_size = 0;

    // loop over input lines
    while ((line_len = getline(&line, &len, stream)) != -1) {
        // remove line terminator
        line[line_len - 1] = '\0';
        line_len--;

        // skip empty lines
        if (line_len == 0) {
            continue;
        }

        // parse decimal number
        number = strtoll(line, &invalid, 10);

        // handle parsing errors
        if (invalid - line != line_len) {
            if (force) {
                continue;
            }
            fprintf(stderr, "Error: Wrong input format on line '%s'.\n", line);
            rc = EXIT_FAILURE;
            goto out;
        }
        if (number == LLONG_MIN) {
            if (force) {
                continue;
            }
            fprintf(stderr, "Error: Underflow on input line '%s'.\n", line);
            rc = EXIT_FAILURE;
            goto out;
        }
        if (number == LLONG_MAX) {
            if (force) {
                continue;
            }
            fprintf(stderr, "Error: Overflow on input line '%s'.\n", line);
            rc = EXIT_FAILURE;
            goto out;
        }
        if (errno) {
            if (force) {
                continue;
            }
            fprintf(stderr, "Error: strtoll error %d (%s) on "
                    "input line '%s'.\n",
                    errno, strerror(errno), line);
            rc = EXIT_FAILURE;
            goto out;
        }

        // identify range start and end, and output accordingly
        if (first) {
            printf("%lld ", number);
            range_end = number;
            first = false;
            if (print_size) {
                range_size = 1;
            }
        } else {
            if (number < range_end) {
                fprintf(stderr, "Error: Input is not sorted on line '%s'.\n",
                        line);
                rc = EXIT_FAILURE;
                goto out;
            }
            if (number == range_end + 1) {
                range_end = number;
                if (print_size) {
                    range_size++;
                }
            } else if (number > range_end + 1) {
                printf("%lld", range_end);
                if (print_size) {
                    printf(" %zu", range_size);
                    range_size = 1;
                }
                printf("\n%lld ", number);
                range_end = number;
            }
        }
    }

    // print remaining range end
    if (!first) {
        printf("%lld", range_end);
        if (print_size) {
            printf(" %zu", range_size);
        }
        printf("\n");
    }

out:
    free(line);
    return rc;
}


int extract_hexadecimal_number_ranges(FILE *stream, int print_size, int force)
{
    char *line = NULL;
    size_t len = 0;
    ssize_t line_len = 0;
    bool first = true;
    long long int range_end = 0;
    long long int number = 0;
    char *invalid = NULL;
    errno = 0;
    int rc = EXIT_SUCCESS;
    size_t range_size = 0;

    // loop over input lines
    while ((line_len = getline(&line, &len, stream)) != -1) {
        // remove line terminator
        line[line_len - 1] = '\0';
        line_len--;

        // skip empty lines
        if (line_len == 0) {
            continue;
        }

        // check that line starts with 0x
        if (line_len < 3 || line[0] != '0' || line[1] != 'x') {
            if (force) {
                continue;
            }
            fprintf(stderr, "Error: Wrong input format on line '%s'.\n", line);
            rc = EXIT_FAILURE;
            goto out;
        }

        // parse decimal number
        number = strtoll(line+2, &invalid, 16);

        // handle parsing errors
        if (invalid - line != line_len) {
            if (force) {
                continue;
            }
            fprintf(stderr, "Error: Wrong input format on line '%s'.\n", line);
            rc = EXIT_FAILURE;
            goto out;
        }
        if (number == LLONG_MIN) {
            if (force) {
                continue;
            }
            fprintf(stderr, "Error: Underflow on input line '%s'.\n", line);
            rc = EXIT_FAILURE;
            goto out;
        }
        if (number == LLONG_MAX) {
            if (force) {
                continue;
            }
            fprintf(stderr, "Error: Overflow on input line '%s'.\n", line);
            rc = EXIT_FAILURE;
            goto out;
        }
        if (errno) {
            if (force) {
                continue;
            }
            fprintf(stderr, "Error: strtoll error %d (%s) on "
                    "input line '%s'.\n",
                    errno, strerror(errno), line);
            rc = EXIT_FAILURE;
            goto out;
        }

        // identify range start and end, and output accordingly
        if (first) {
            printf("0x%llx ", (long long unsigned int) number);
            range_end = number;
            first = false;
            if (print_size) {
                range_size = 1;
            }
        } else {
            if (number < range_end) {
                fprintf(stderr, "Error: Input is not sorted on line '%s'.\n",
                        line);
                rc = EXIT_FAILURE;
                goto out;
            }
            if (number == range_end + 1) {
                range_end = number;
                if (print_size) {
                    range_size++;
                }
            } else if (number > range_end + 1) {
                printf("0x%llx", (long long unsigned int) range_end);
                if (print_size) {
                    printf(" %zu", range_size);
                    range_size = 1;
                }
                printf("\n0x%llx ", (long long unsigned int) number);
                range_end = number;
            }
        }
    }

    // print remaining range end
    if (!first) {
        printf("0x%llx", (long long unsigned int) range_end);
        if (print_size) {
            printf(" %zu", range_size);
        }
        printf("\n");
    }

out:
    free(line);
    return rc;
}

int extract_octal_number_ranges(FILE *stream, int print_size, int force)
{
    char *line = NULL;
    size_t len = 0;
    ssize_t line_len = 0;
    bool first = true;
    long long int range_end = 0;
    long long int number = 0;
    char *invalid = NULL;
    errno = 0;
    int rc = EXIT_SUCCESS;
    size_t range_size = 0;

    // loop over input lines
    while ((line_len = getline(&line, &len, stream)) != -1) {
        // remove line terminator
        line[line_len - 1] = '\0';
        line_len--;

        // skip empty lines
        if (line_len == 0) {
            continue;
        }

        // check that line starts with 0x
        if (line_len < 3 || line[0] != '0' || line[1] != 'o') {
            if (force) {
                continue;
            }
            fprintf(stderr, "Error: Wrong input format on line '%s'.\n", line);
            rc = EXIT_FAILURE;
            goto out;
        }

        // parse decimal number
        number = strtoll(line+2, &invalid, 8);

        // handle parsing errors
        if (invalid - line != line_len) {
            if (force) {
                continue;
            }
            fprintf(stderr, "Error: Wrong input format on line '%s'.\n", line);
            rc = EXIT_FAILURE;
            goto out;
        }
        if (number == LLONG_MIN) {
            if (force) {
                continue;
            }
            fprintf(stderr, "Error: Underflow on input line '%s'.\n", line);
            rc = EXIT_FAILURE;
            goto out;
        }
        if (number == LLONG_MAX) {
            if (force) {
                continue;
            }
            fprintf(stderr, "Error: Overflow on input line '%s'.\n", line);
            rc = EXIT_FAILURE;
            goto out;
        }
        if (errno) {
            if (force) {
                continue;
            }
            fprintf(stderr, "Error: strtoll error %d (%s) on "
                    "input line '%s'.\n",
                    errno, strerror(errno), line);
            rc = EXIT_FAILURE;
            goto out;
        }

        // identify range start and end, and output accordingly
        if (first) {
            printf("0o%llo ", (long long unsigned int) number);
            range_end = number;
            first = false;
            if (print_size) {
                range_size = 1;
            }
        } else {
            if (number < range_end) {
                fprintf(stderr, "Error: Input is not sorted on line '%s'.\n",
                        line);
                rc = EXIT_FAILURE;
                goto out;
            }
            if (number == range_end + 1) {
                range_end = number;
                if (print_size) {
                    range_size++;
                }
            } else if (number > range_end + 1) {
                printf("0o%llo", (long long unsigned int) range_end);
                if (print_size) {
                    printf(" %zu", range_size);
                    range_size = 1;
                }
                printf("\n0o%llo ", (long long unsigned int) number);
                range_end = number;
            }
        }
    }

    // print remaining range end
    if (!first) {
        printf("0o%llo", (long long unsigned int) range_end);
        if (print_size) {
            printf(" %zu", range_size);
        }
        printf("\n");
    }

out:
    free(line);
    return rc;
}

void lltobinstr(long long int number, char * binary)
{
    int i = 0;
    int j = 0;

    binary[0] = '0';
    binary[1] = 'b';
    for (i = 0, j = 2; i < 64; i++) {
        if (number & (long long int) 0x8000000000000000) {
            binary[j++] = '1';
        } else if (j > 2) {
            binary[j++] = '0';
        }
        number <<= 1;
    }
    if (j == 2) {
        binary[j++] = '0';
    }
    binary[j] = '\0';
}

int extract_binary_number_ranges(FILE *stream, int print_size, int force)
{
    char *line = NULL;
    size_t len = 0;
    ssize_t line_len = 0;
    bool first = true;
    long long int range_end = 0;
    long long int number = 0;
    char *invalid = NULL;
    errno = 0;
    char binary[67];
    int rc = EXIT_SUCCESS;
    size_t range_size = 0;

    // loop over input lines
    while ((line_len = getline(&line, &len, stream)) != -1) {
        // remove line terminator
        line[line_len - 1] = '\0';
        line_len--;

        // skip empty lines
        if (line_len == 0) {
            continue;
        }

        // check that line starts with 0x
        if (line_len < 3 || line[0] != '0' || line[1] != 'b') {
            if (force) {
                continue;
            }
            fprintf(stderr, "Error: Wrong input format on line '%s'.\n", line);
            rc = EXIT_FAILURE;
            goto out;
        }

        // parse decimal number
        number = strtoll(line+2, &invalid, 2);

        // handle parsing errors
        if (invalid - line != line_len) {
            if (force) {
                continue;
            }
            fprintf(stderr, "Error: Wrong input format on line '%s'.\n", line);
            rc = EXIT_FAILURE;
            goto out;
        }
        if (number == LLONG_MIN) {
            if (force) {
                continue;
            }
            fprintf(stderr, "Error: Underflow on input line '%s'.\n", line);
            rc = EXIT_FAILURE;
            goto out;
        }
        if (number == LLONG_MAX) {
            if (force) {
                continue;
            }
            fprintf(stderr, "Error: Overflow on input line '%s'.\n", line);
            rc = EXIT_FAILURE;
            goto out;
        }
        if (errno) {
            if (force) {
                continue;
            }
            fprintf(stderr, "Error: strtoll error %d (%s) on "
                    "input line '%s'.\n",
                    errno, strerror(errno), line);
            rc = EXIT_FAILURE;
            goto out;
        }

        // identify range start and end, and output accordingly
        if (first) {
            lltobinstr(number, binary);
            printf("%s ", binary);
            range_end = number;
            first = false;
            if (print_size) {
                range_size = 1;
            }
        } else {
            if (number < range_end) {
                fprintf(stderr, "Error: Input is not sorted on line '%s'.\n",
                        line);
                rc = EXIT_FAILURE;
                goto out;
            }
            if (number == range_end + 1) {
                range_end = number;
                if (print_size) {
                    range_size++;
                }
            } else if (number > range_end + 1) {
                lltobinstr(range_end, binary);
                printf("%s", binary);
                if (print_size) {
                    printf(" %zu", range_size);
                    range_size = 1;
                }
                lltobinstr(number, binary);
                printf("\n%s ", binary);
                range_end = number;
            }
        }
    }

    // print remaining range end
    if (!first) {
        lltobinstr(range_end, binary);
        printf("%s", binary);
        if (print_size) {
            printf(" %zu", range_size);
        }
        printf("\n");
    }

out:
    free(line);
    return rc;
}

bool date_exists(struct tm * date)
{
    struct tm check;
    memcpy(&check, date, sizeof(struct tm));

    check.tm_sec = 0;
    check.tm_min = 0;
    check.tm_hour = 12;
    check.tm_isdst = -1;

    mktime(&check);

    if (check.tm_year != date->tm_year ||
        check.tm_mon != date->tm_mon ||
        check.tm_mday != date->tm_mday) {
        return false;
    }
    return true;
}

bool date_eq(struct tm *a, struct tm *b)
{
    return a->tm_year == b->tm_year &&
           a->tm_mon == b->tm_mon &&
           a->tm_mday == b->tm_mday;
}

bool date_lt(struct tm *a, struct tm *b)
{
    return a->tm_year < b->tm_year ||
           (a->tm_year == b->tm_year && a->tm_mon < b->tm_mon) ||
           (a->tm_year == b->tm_year && a->tm_mon == b->tm_mon &&
            a->tm_mday < b->tm_mday);
}

bool date_le(struct tm *a, struct tm *b)
{
    return date_eq(a, b) || date_lt(a, b);
}

bool date_gt(struct tm *a, struct tm *b)
{
    return !date_le(a, b);
}

bool date_ge(struct tm *a, struct tm *b)
{
    return !date_lt(a, b);
}

void date_inc(struct tm *date)
{
    date->tm_sec = 0;
    date->tm_min = 0;
    date->tm_hour = 12;
    date->tm_isdst = -1;
    date->tm_mday += 1;
    mktime(date);
}

bool date_is_inc(struct tm *a, struct tm *b)
{
    struct tm c;
    memcpy(&c, b, sizeof(struct tm));
    date_inc(&c);
    return date_eq(a, &c);
}

bool date_gt_inc(struct tm *a, struct tm *b)
{
    struct tm c;
    memcpy(&c, b, sizeof(struct tm));
    date_inc(&c);
    return date_gt(a, &c);
}

int extract_date_ranges(FILE *stream, int print_size, int force)
{
    char *line = NULL;
    size_t len = 0;
    ssize_t line_len = 0;
    bool first = true;
    struct tm range_end = {0};
    struct tm date = {0};
    char date_str[11] = {0};
    char *invalid = NULL;
    int rc = EXIT_SUCCESS;
    size_t range_size = 0;

    // loop over input lines
    while ((line_len = getline(&line, &len, stream)) != -1) {
        // remove line terminator
        line[line_len - 1] = '\0';
        line_len--;

        // skip empty lines
        if (line_len == 0) {
            continue;
        }

        // parse decimal number
        invalid = strptime(line, "%F", &date);

        // handle parsing errors
        if (invalid - line != line_len) {
            if (force) {
                continue;
            }
            fprintf(stderr, "Error: Wrong input format on line '%s'.\n", line);
            rc = EXIT_FAILURE;
            goto out;
        }
        if (!date_exists(&date)) {
            fprintf(stderr, "Error: Invalid date on line '%s'.\n", line);
            rc = EXIT_FAILURE;
            goto out;
        }

        // identify range start and end, and output accordingly
        if (first) {
            strftime(date_str, (size_t) 11, "%F", &date);
            printf("%s ", date_str);
            memcpy(&range_end, &date, sizeof(struct tm));
            first = false;
            if (print_size) {
                range_size = 1;
            }
        } else {
            if (date_lt(&date, &range_end)) {
                fprintf(stderr, "Error: Input is not sorted on line '%s'.\n",
                        line);
                rc = EXIT_FAILURE;
                goto out;
            }
            if (date_is_inc(&date, &range_end)) {
                memcpy(&range_end, &date, sizeof(struct tm));
                if (print_size) {
                    range_size++;
                }
            } else if (date_gt_inc(&date, &range_end)) {
                strftime(date_str, (size_t) 11, "%F", &range_end);
                printf("%s", date_str);
                if (print_size) {
                    printf(" %zu", range_size);
                    range_size = 1;
                }
                strftime(date_str, (size_t) 11, "%F", &date);
                printf("\n%s ", date_str);
                memcpy(&range_end, &date, sizeof(struct tm));
            }
        }
    }

    // print remaining range end
    if (!first) {
        strftime(date_str, (size_t) 11, "%F", &range_end);
        printf("%s", date_str);
        if (print_size) {
            printf(" %zu", range_size);
        }
        printf("\n");
    }

out:
    free(line);
    return rc;
}

int extract_ipv4_ranges(FILE *stream, int print_size, int force)
{
    char *line = NULL;
    size_t len = 0;
    ssize_t line_len = 0;
    bool first = true;
    struct in_addr range_end;
    struct in_addr ip;
    char ip_str[INET_ADDRSTRLEN];
    int rc = EXIT_SUCCESS;
    size_t range_size = 0;

    // loop over input lines
    while ((line_len = getline(&line, &len, stream)) != -1) {
        // remove line terminator
        line[line_len - 1] = '\0';
        line_len--;

        // skip empty lines
        if (line_len == 0) {
            continue;
        }

        // parse ip address
        if (inet_pton(AF_INET, line, &ip) == 0) {
            if (force) {
                continue;
            }
            fprintf(stderr, "Error: Wrong input format on line '%s'.\n", line);
            rc = EXIT_FAILURE;
            goto out;
        }

        // identify range start and end, and output accordingly
        if (first) {
            inet_ntop(AF_INET, &ip, ip_str, INET_ADDRSTRLEN);
            printf("%s ", ip_str);
            range_end.s_addr = ip.s_addr;
            first = false;
            if (print_size) {
                range_size = 1;
            }
        } else {
            if (htonl(ip.s_addr) < htonl(range_end.s_addr)) {
                fprintf(stderr, "Error: Input is not sorted on line '%s'.\n",
                        line);
                rc = EXIT_FAILURE;
                goto out;
            }
            if (htonl(ip.s_addr) == htonl(range_end.s_addr) + 1) {
                range_end.s_addr = ip.s_addr;
                if (print_size) {
                    range_size++;
                }
            } else if (htonl(ip.s_addr) > htonl(range_end.s_addr) + 1) {
                inet_ntop(AF_INET, &range_end, ip_str, INET_ADDRSTRLEN);
                printf("%s", ip_str);
                if (print_size) {
                    printf(" %zu", range_size);
                    range_size = 1;
                }
                inet_ntop(AF_INET, &ip, ip_str, INET_ADDRSTRLEN);
                printf("\n%s ", ip_str);
                range_end.s_addr = ip.s_addr;
            }
        }
    }

    // print remaining range end
    if (!first) {
        inet_ntop(AF_INET, &range_end, ip_str, INET_ADDRSTRLEN);
        printf("%s", ip_str);
        if (print_size) {
            printf(" %zu", range_size);
        }
        printf("\n");
    }

out:
    free(line);
    return rc;
}

bool ipv6_eq(struct in6_addr *a, struct in6_addr *b)
{
    for (int i = 0; i < 16; i++) {
        if (a->s6_addr[i] != b->s6_addr[i]) {
            return false;
        }
    }
    return true;
}

bool ipv6_le(struct in6_addr *a, struct in6_addr *b)
{
    for (int i = 0; i < 16; i++) {
        if (a->s6_addr[i] < b->s6_addr[i]) {
            return true;
        }
        if (a->s6_addr[i] > b->s6_addr[i]) {
            return false;
        }
    }
    return false;
}

bool ipv6_lt(struct in6_addr *a, struct in6_addr *b)
{
    return ipv6_le(a, b) && !ipv6_eq(a, b);
}

bool ipv6_gt(struct in6_addr *a, struct in6_addr *b)
{
    return !ipv6_le(a, b);
}

bool ipv6_ge(struct in6_addr *a, struct in6_addr *b)
{
    return !ipv6_lt(a, b);
}

void ipv6_inc(struct in6_addr *a)
{
    for (int i = 15; i >= 0; i--) {
        if (a->s6_addr[i] == 255) {
            a->s6_addr[i] = 0;
        } else {
            a->s6_addr[i]++;
            return;
        }
    }
    return;
}

bool ipv6_is_inc(struct in6_addr *a, struct in6_addr *b)
{
    struct in6_addr c;
    memcpy(&c, b, sizeof(struct in6_addr));
    ipv6_inc(&c);
    return ipv6_eq(a, &c);
}

bool ipv6_gt_inc(struct in6_addr *a, struct in6_addr *b)
{
    struct in6_addr c;
    memcpy(&c, b, sizeof(struct in6_addr));
    ipv6_inc(&c);
    return ipv6_gt(a, &c);
}

int extract_ipv6_ranges(FILE *stream, int print_size, int force)
{
    char *line = NULL;
    size_t len = 0;
    ssize_t line_len = 0;
    bool first = true;
    struct in6_addr range_end;
    struct in6_addr ip;
    char ip_str[INET6_ADDRSTRLEN];
    int rc = EXIT_SUCCESS;
    size_t range_size = 0;

    // loop over input lines
    while ((line_len = getline(&line, &len, stream)) != -1) {
        // remove line terminator
        line[line_len - 1] = '\0';
        line_len--;

        // skip empty lines
        if (line_len == 0) {
            continue;
        }

        // parse ip address
        if (inet_pton(AF_INET6, line, &ip) == 0) {
            if (force) {
                continue;
            }
            fprintf(stderr, "Error: Wrong input format on line '%s'.\n", line);
            rc = EXIT_FAILURE;
            goto out;
        }

        // identify range start and end, and output accordingly
        if (first) {
            inet_ntop(AF_INET6, &ip, ip_str, INET6_ADDRSTRLEN);
            printf("%s ", ip_str);
            memcpy(range_end.s6_addr, ip.s6_addr, sizeof(range_end.s6_addr));
            first = false;
            if (print_size) {
                range_size = 1;
            }
        } else {
            if (ipv6_lt(&ip, &range_end)) {
                fprintf(stderr, "Error: Input is not sorted on line '%s'.\n",
                        line);
                rc = EXIT_FAILURE;
                goto out;
            }
            if (ipv6_is_inc(&ip, &range_end)) {
                memcpy(range_end.s6_addr, ip.s6_addr, sizeof(range_end.s6_addr));
                if (print_size) {
                    range_size++;
                }
            } else if (ipv6_gt_inc(&ip, &range_end)) {
                inet_ntop(AF_INET6, &range_end, ip_str, INET6_ADDRSTRLEN);
                printf("%s", ip_str);
                if (print_size) {
                    printf(" %zu", range_size);
                    range_size = 1;
                }
                inet_ntop(AF_INET6, &ip, ip_str, INET6_ADDRSTRLEN);
                printf("\n%s ", ip_str);
                memcpy(range_end.s6_addr, ip.s6_addr, sizeof(range_end.s6_addr));
            }
        }
    }

    // print remaining range end
    if (!first) {
        inet_ntop(AF_INET6, &range_end, ip_str, INET_ADDRSTRLEN);
        printf("%s", ip_str);
        if (print_size) {
            printf(" %zu", range_size);
        }
        printf("\n");
    }

out:
    free(line);
    return rc;
}

int mac_pton(const char *mac_str, uint8_t *mac)
{
    if (strlen(mac_str) != 17) {
        return 0;
    }

    return 6 == sscanf(mac_str, "%hhx:%hhx:%hhx:%hhx:%hhx:%hhx",
                       mac, mac+1, mac+2, mac+3, mac+4, mac+5);
}

long long int mac_ntoll(uint8_t *mac)
{
    long long int mac_int = 0;

    for (int i = 0; i < 6; i++) {
        mac_int = (mac_int << 8) | mac[i];
    }

    return mac_int;
}

void mac_llton(long long int mac_int, uint8_t *mac)
{
    for (int i = 5; i >= 0; i--) {
        mac[i] = (uint8_t) (mac_int & 0xff);
        mac_int >>= 8;
    }
}

int mac_ntop(const uint8_t *mac, char *mac_str)
{
    return sprintf(mac_str, "%02x:%02x:%02x:%02x:%02x:%02x",
                   mac[0], mac[1], mac[2], mac[3], mac[4], mac[5]);
}

int extract_mac_ranges(FILE *stream, int print_size, int force)
{
    char *line = NULL;
    size_t len = 0;
    ssize_t line_len = 0;
    bool first = true;
    long long int range_end = 0;
    long long int mac_ll = 0;
    uint8_t mac[6];
    char mac_str[18];
    int rc = EXIT_SUCCESS;
    size_t range_size = 0;

    // loop over input lines
    while ((line_len = getline(&line, &len, stream)) != -1) {
        // remove line terminator
        line[line_len - 1] = '\0';
        line_len--;

        // skip empty lines
        if (line_len == 0) {
            continue;
        }

        // parse mac address
        if (!mac_pton(line, mac)) {
            if (force) {
                continue;
            }
            fprintf(stderr, "Error: Wrong input format on line '%s'.\n", line);
            rc = EXIT_FAILURE;
            goto out;
        }
        mac_ll = mac_ntoll(mac);

        // identify range start and end, and output accordingly
        if (first) {
            mac_llton(mac_ll, mac);
            mac_ntop(mac, mac_str);
            printf("%s ", mac_str);
            range_end = mac_ll;
            first = false;
            if (print_size) {
                range_size = 1;
            }
        } else {
            if (mac_ll < range_end) {
                fprintf(stderr, "Error: Input is not sorted on line '%s'.\n",
                        line);
                rc = EXIT_FAILURE;
                goto out;
            }
            if (mac_ll == range_end + 1) {
                range_end = mac_ll;
                if (print_size) {
                    range_size++;
                }
            } else if (mac_ll > range_end + 1) {
                mac_llton(range_end, mac);
                mac_ntop(mac, mac_str);
                printf("%s", mac_str);
                if (print_size) {
                    printf(" %zu", range_size);
                    range_size = 1;
                }
                mac_llton(mac_ll, mac);
                mac_ntop(mac, mac_str);
                printf("\n%s ", mac_str);
                range_end = mac_ll;
            }
        }
    }

    // print remaining range end
    if (!first) {
        mac_llton(range_end, mac);
        mac_ntop(mac, mac_str);
        printf("%s", mac_str);
        if (print_size) {
            printf(" %zu", range_size);
        }
        printf("\n");
    }

out:
    free(line);
    return rc;
}

typedef int (*extract_range_function_t)(FILE *, int, int);


static inline void check_range_type_unset(extract_range_function_t function)
{
    if (*function != NULL) {
        fprintf(stderr, "Error: Only one range type can be specified.\n");
        print_usage_with_help_remark();
        exit(EXIT_FAILURE);
    }
}


static inline bool isregfile(const char *path)
{
    struct stat path_stat = {0};
    stat(path, &path_stat);
    return S_ISREG(path_stat.st_mode);
}


int main(int argc, char *argv[])
{
    extract_range_function_t extract_range_function = NULL;
    int print_size = (int) false;
    int force = (int) false;
    FILE *stream = NULL;
    int rc;

    // option character
    int c;

    // parse arguments
    while (1) {
        //int this_option_optind = optind ? optind : 1;
        int option_index = 0;

        c = getopt_long(argc, argv, optstring, long_options, &option_index);
        if (c == -1) {
            break;
        }

        switch (c) {
            case 'H':
                check_range_type_unset(extract_range_function);
                extract_range_function = extract_hexadecimal_number_ranges;
                break;

            case 'o':
                check_range_type_unset(extract_range_function);
                extract_range_function = extract_octal_number_ranges;
                break;

            case 'b':
                check_range_type_unset(extract_range_function);
                extract_range_function = extract_binary_number_ranges;
                break;

            case 'd':
                check_range_type_unset(extract_range_function);
                extract_range_function = extract_date_ranges;
                break;

            case 'i':
                check_range_type_unset(extract_range_function);
                extract_range_function = extract_ipv4_ranges;
                break;

            case 'I':
                check_range_type_unset(extract_range_function);
                extract_range_function = extract_ipv6_ranges;
                break;

            case 'm':
                check_range_type_unset(extract_range_function);
                extract_range_function = extract_mac_ranges;
                break;

            case 's':
                print_size = (int) true;
                break;

            case 'f':
                force = (int) true;
                break;

            case 'h':
                print_help();
                return EXIT_SUCCESS;

            case 'v':
                print_version();
                return EXIT_SUCCESS;

            case '?':
                print_usage_with_help_remark();
                return EXIT_FAILURE;

            default:
                fprintf(stderr,
                    "Error: getopt returned unrecognized "
                    "character code 0%c.\n",
                    c);
                return EXIT_FAILURE;
        }
    }

    // open file if given, and check that not too much or too few arguments
    if (optind == argc) {
        if (isatty(STDIN_FILENO)) {
            fprintf(stderr, "Error: No input given. You must provide a "
                    "file or pipe!\n");
            print_usage_with_help_remark();
            return EXIT_FAILURE;
        }
        stream = stdin;
    } else if (optind == argc - 1) {
        if (!isregfile(argv[optind])) {
            fprintf(stderr, "Error: '%s' is not a regular file "
                    "or a symlink to one.\n",
                    argv[optind]);
            print_usage_with_help_remark();
            return EXIT_FAILURE;
        }
        stream = fopen(argv[optind], "r");
        if (stream == NULL) {
            fprintf(stderr, "Error: Could not open file '%s'.\n",
                    argv[optind]);
            print_usage_with_help_remark();
            return EXIT_FAILURE;
        }
    } else {
        print_usage_with_help_remark();
        if (optind > argc) {
            fprintf(stderr, "Error: too few arguments.\n");
        } else {
            fprintf(stderr, "Error: too many arguments.\n");
        }
        return EXIT_FAILURE;
    }

    // set default range type if unset
    if (extract_range_function == NULL) {
        extract_range_function = extract_decimal_number_ranges;
    }

    // extract ranges based on specified type
    rc = extract_range_function(stream, print_size, force);

    // close file if opened
    if (stream != stdin) {
        fclose(stream);
    }

    return rc;
}
