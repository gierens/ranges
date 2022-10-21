#include <stdio.h>
#include <stdlib.h>
#include <getopt.h>


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
           "types of lists, decimal integer numbers by default, but also \n"
           "dates, IP or MAC addresses.\n"
           "\n"
           "Note that the input is assumed to be sorted already. Duplicates\n"
           "don't need to be removed however.\n"
           "\n"
           "Optional arguments:\n"
           // TODO file argument for operation on given file instead of stdin
           // TODO -s for skipping not parsable stuff
           "  -H, --hex              Extract hexadecimal number ranges.\n"
           "  -o, --octal            Extract octal number ranges.\n"
           "  -b, --binary           Extract binary number ranges.\n"
           "  -d, --date             Extract date ranges.\n"
           "  -i, --ipv4             Extract IPv4 address ranges.\n"
           "  -I, --ipv6             Extract IPv6 address ranges.\n"
           "  -m, --mac              Extract MAC address ranges.\n"
           "  -h, --help             Print this help message.\n"
           // TODO usage example
           // TODO author and github page
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

static const char* optstring = "diImh";


int extract_decimal_number_ranges(void)
{
    // char *line = NULL;
    // size_t len = 0;
    // ssize_t line_len = 0;
    // while ((line_len = getline(&line, &len, stdin)) != -1) {
    //     printf("%s", line);
    // }
    // free(line);
    fprintf(stderr, "Not implemented yet\n");
    return EXIT_FAILURE;
}

int extract_hexadecimal_number_ranges(void)
{
    fprintf(stderr, "Not implemented yet\n");
    return EXIT_FAILURE;
}

int extract_octal_number_ranges(void)
{
    fprintf(stderr, "Not implemented yet\n");
    return EXIT_FAILURE;
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
    fprintf(stderr, "Not implemented yet\n");
    return EXIT_FAILURE;
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
                return 1;

            case '?':
                break;

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
