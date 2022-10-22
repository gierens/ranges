#include <stdio.h>
#include <stdlib.h>
#include <getopt.h>
#include <stdbool.h>
#include <errno.h>
#include <string.h>
#include <limits.h>
#include <arpa/inet.h>


void print_usage(void)
{
    printf("Usage: ranges [-H|-o|-b|-d|-i|-I|-m] [-h]\n");
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
           // TODO file argument for operation on given file instead of stdin
           // TODO -s for skipping not parsable stuff
           "  -H, --hex              Extract unsigned hexadecimal number "
           "ranges.\n"
           "  -o, --octal            Extract unsigned octal number ranges.\n"
           "  -b, --binary           Extract unsigned binary number ranges.\n"
           "  -d, --date             Extract date ranges.\n"
           "  -i, --ipv4             Extract IPv4 address ranges.\n"
           "  -I, --ipv6             Extract IPv6 address ranges.\n"
           "  -m, --mac              Extract MAC address ranges.\n"
           "  -h, --help             Print this help message.\n"
           "\n"
           "Example:\n"
           "  bash $> printf '1\\n2\\n3\\n6\\n7\\n9\\n10\\n11\\n' | ranges\n"
           "  1 3\n"
           "  6 7\n"
           "  9 11\n"
           "\n"
           "Author: Sandro-Alessio Gierens\n"
           "GitHub: https://github.com/gierens/ranges\n"
           );
}


static struct option long_options[] = {
    {"hex",    no_argument, 0, 'H'},
    {"octal",  no_argument, 0, 'o'},
    {"binary", no_argument, 0, 'b'},
    {"date",   no_argument, 0, 'd'},
    {"ipv4",   no_argument, 0, 'i'},
    {"ipv6",   no_argument, 0, 'I'},
    {"mac",    no_argument, 0, 'm'},
    {"help",   no_argument, 0, 'h'},
};

static const char* optstring = "HobdiImh";


int extract_decimal_number_ranges(void)
{
    char *line = NULL;
    size_t len = 0;
    ssize_t line_len = 0;
    bool first = true;
    long long int range_end = 0;
    long long int number = 0;
    char *invalid = NULL;
    errno = 0;

    // loop over input lines
    while ((line_len = getline(&line, &len, stdin)) != -1) {
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
            fprintf(stderr, "Error: Wrong input format on line '%s'.\n", line);
            return EXIT_FAILURE;
        }
        if (number == LLONG_MIN) {
            fprintf(stderr, "Error: Underflow on input line '%s'.\n", line);
            return EXIT_FAILURE;
        }
        if (number == LLONG_MAX) {
            fprintf(stderr, "Error: Overflow on input line '%s'.\n", line);
            return EXIT_FAILURE;
        }
        if (errno) {
            fprintf(stderr, "Error: strtoll error %d (%s) on "
                    "input line '%s'.\n",
                    errno, strerror(errno), line);
            return EXIT_FAILURE;
        }

        // identify range start and end, and output accordingly
        if (first) {
            printf("%lld ", number);
            range_end = number;
            first = false;
        } else {
            if (number < range_end) {
                fprintf(stderr, "Error: Input is not sorted on line '%s'.\n",
                        line);
                return EXIT_FAILURE;
            }
            if (number == range_end + 1) {
                range_end = number;
            } else if (number > range_end + 1) {
                printf("%lld\n", range_end);
                printf("%lld ", number);
                range_end = number;
            }
        }
    }

    // print remaining range end
    if (!first) {
        printf("%lld\n", range_end);
    }

    free(line);
    return EXIT_SUCCESS;
}


int extract_hexadecimal_number_ranges(void)
{
    char *line = NULL;
    size_t len = 0;
    ssize_t line_len = 0;
    bool first = true;
    long long int range_end = 0;
    long long int number = 0;
    char *invalid = NULL;
    errno = 0;

    // loop over input lines
    while ((line_len = getline(&line, &len, stdin)) != -1) {
        // remove line terminator
        line[line_len - 1] = '\0';
        line_len--;

        // skip empty lines
        if (line_len == 0) {
            continue;
        }

        // check that line starts with 0x
        if (line_len < 3 || line[0] != '0' || line[1] != 'x') {
            fprintf(stderr, "Error: Wrong input format on line '%s'.\n", line);
            return EXIT_FAILURE;
        }

        // parse decimal number
        number = strtoll(line+2, &invalid, 16);

        // handle parsing errors
        if (invalid - line != line_len) {
            fprintf(stderr, "Error: Wrong input format on line '%s'.\n", line);
            return EXIT_FAILURE;
        }
        if (number == LLONG_MIN) {
            fprintf(stderr, "Error: Underflow on input line '%s'.\n", line);
            return EXIT_FAILURE;
        }
        if (number == LLONG_MAX) {
            fprintf(stderr, "Error: Overflow on input line '%s'.\n", line);
            return EXIT_FAILURE;
        }
        if (errno) {
            fprintf(stderr, "Error: strtoll error %d (%s) on "
                    "input line '%s'.\n",
                    errno, strerror(errno), line);
            return EXIT_FAILURE;
        }

        // identify range start and end, and output accordingly
        if (first) {
            printf("0x%llx ", number);
            range_end = number;
            first = false;
        } else {
            if (number < range_end) {
                fprintf(stderr, "Error: Input is not sorted on line '%s'.\n",
                        line);
                return EXIT_FAILURE;
            }
            if (number == range_end + 1) {
                range_end = number;
            } else if (number > range_end + 1) {
                printf("0x%llx\n", range_end);
                printf("0x%llx ", number);
                range_end = number;
            }
        }
    }

    // print remaining range end
    if (!first) {
        printf("0x%llx\n", range_end);
    }

    free(line);
    return EXIT_SUCCESS;
}

int extract_octal_number_ranges(void)
{
    char *line = NULL;
    size_t len = 0;
    ssize_t line_len = 0;
    bool first = true;
    long long int range_end = 0;
    long long int number = 0;
    char *invalid = NULL;
    errno = 0;

    // loop over input lines
    while ((line_len = getline(&line, &len, stdin)) != -1) {
        // remove line terminator
        line[line_len - 1] = '\0';
        line_len--;

        // skip empty lines
        if (line_len == 0) {
            continue;
        }

        // check that line starts with 0x
        if (line_len < 3 || line[0] != '0' || line[1] != 'o') {
            fprintf(stderr, "Error: Wrong input format on line '%s'.\n", line);
            return EXIT_FAILURE;
        }

        // parse decimal number
        number = strtoll(line+2, &invalid, 8);

        // handle parsing errors
        if (invalid - line != line_len) {
            fprintf(stderr, "Error: Wrong input format on line '%s'.\n", line);
            return EXIT_FAILURE;
        }
        if (number == LLONG_MIN) {
            fprintf(stderr, "Error: Underflow on input line '%s'.\n", line);
            return EXIT_FAILURE;
        }
        if (number == LLONG_MAX) {
            fprintf(stderr, "Error: Overflow on input line '%s'.\n", line);
            return EXIT_FAILURE;
        }
        if (errno) {
            fprintf(stderr, "Error: strtoll error %d (%s) on "
                    "input line '%s'.\n",
                    errno, strerror(errno), line);
            return EXIT_FAILURE;
        }

        // identify range start and end, and output accordingly
        if (first) {
            printf("0o%llo ", number);
            range_end = number;
            first = false;
        } else {
            if (number < range_end) {
                fprintf(stderr, "Error: Input is not sorted on line '%s'.\n",
                        line);
                return EXIT_FAILURE;
            }
            if (number == range_end + 1) {
                range_end = number;
            } else if (number > range_end + 1) {
                printf("0o%llo\n", range_end);
                printf("0o%llo ", number);
                range_end = number;
            }
        }
    }

    // print remaining range end
    if (!first) {
        printf("0o%llo\n", range_end);
    }

    free(line);
    return EXIT_SUCCESS;
}

int extract_binary_number_ranges(void)
{
    fprintf(stderr, "Not implemented yet\n");
    return EXIT_FAILURE;
}

int extract_date_ranges(void)
{
    fprintf(stderr, "Not implemented yet\n");
    return EXIT_FAILURE;
}

int extract_ipv4_ranges(void)
{
    char *line = NULL;
    size_t len = 0;
    ssize_t line_len = 0;
    bool first = true;
    struct in_addr range_end;
    struct in_addr ip;
    char ip_str[INET_ADDRSTRLEN];

    // loop over input lines
    while ((line_len = getline(&line, &len, stdin)) != -1) {
        // remove line terminator
        line[line_len - 1] = '\0';
        line_len--;

        // skip empty lines
        if (line_len == 0) {
            continue;
        }

        // parse ip address
        if (inet_pton(AF_INET, line, &ip) == 0) {
            fprintf(stderr, "Error: Wrong input format on line '%s'.\n", line);
            return EXIT_FAILURE;
        }

        // identify range start and end, and output accordingly
        if (first) {
            inet_ntop(AF_INET, &ip, ip_str, INET_ADDRSTRLEN);
            printf("%s ", ip_str);
            range_end.s_addr = ip.s_addr;
            first = false;
        } else {
            if (htonl(ip.s_addr) < htonl(range_end.s_addr)) {
                fprintf(stderr, "Error: Input is not sorted on line '%s'.\n",
                        line);
                return EXIT_FAILURE;
            }
            if (htonl(ip.s_addr) == htonl(range_end.s_addr) + 1) {
                range_end.s_addr = ip.s_addr;
            } else if (htonl(ip.s_addr) > htonl(range_end.s_addr) + 1) {
                inet_ntop(AF_INET, &range_end, ip_str, INET_ADDRSTRLEN);
                printf("%s\n", ip_str);
                inet_ntop(AF_INET, &ip, ip_str, INET_ADDRSTRLEN);
                printf("%s ", ip_str);
                range_end.s_addr = ip.s_addr;
            }
        }
    }

    // print remaining range end
    if (!first) {
        inet_ntop(AF_INET, &range_end, ip_str, INET_ADDRSTRLEN);
        printf("%s\n", ip_str);
    }

    free(line);
    return EXIT_SUCCESS;
}

int extract_ipv6_ranges(void)
{
    fprintf(stderr, "Not implemented yet\n");
    return EXIT_FAILURE;
}

int extract_mac_ranges(void)
{
    fprintf(stderr, "Not implemented yet\n");
    return EXIT_FAILURE;
}

typedef int (*extract_range_function_t)(void);


static inline void check_range_type_unset(extract_range_function_t function)
{
    if (*function != NULL) {
        fprintf(stderr, "Error: Only one range type can be specified.\n");
        print_usage_with_help_remark();
        exit(EXIT_FAILURE);
    }
}


int main(int argc, char *argv[])
{
    extract_range_function_t extract_range_function = NULL;

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

            case 'h':
                print_help();
                return EXIT_SUCCESS;

            case '?':
                print_usage_with_help_remark();
                return EXIT_FAILURE;

            default:
                fprintf(stderr,
                    "Error: getopt returned unrecognized "
                    "character code 0%o.\n",
                    c);
                return EXIT_FAILURE;
        }
    }

    // check that no extra arguments given
    if (optind != argc) {
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
    return extract_range_function();
}
