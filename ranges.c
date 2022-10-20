#include <stdio.h>
#include <stdlib.h>
#include <getopt.h>


void print_usage(void)
{
    printf("Usage: ranges [-h]\n"
           "Try 'ranges -h' for more information\n");
}


void print_help(void)
{
    print_usage();
    printf("\n"
           "Ranges is a command line program to extrac ranges from various\n"
           "types of lists, e.g. integer numbers, dates, IP and MAC\n"
           "addresses.\n"
           "\n"
           "optional arguments:\n"
           "  -h, --help             print this help message\n"
           );
}


static struct option long_options[] = {
    {"help", no_argument, 0, 'h'},
};

static const char* optstring = "h";


int main(int argc, char *argv[])
{
    // option character
    int c;

    // parse arguments
    while ( 1 ) {
        //int this_option_optind = optind ? optind : 1;
        int option_index = 0;

        c = getopt_long(argc, argv, optstring, long_options, &option_index);
        if ( c == -1 ) {
            break;
        }

        switch ( c ) {
            case 'h':
                print_help();
                return 1;

            case '?':
                break;

            default:
                printf(
                    "Error: getopt returned unrecognized character code 0%o\n",
                    c);
                return 2;
        }
    }

    // check that no extra arguments given
    if ( optind != argc ) {
        print_usage();
        if ( optind > argc ) {
            printf("Error: too few arguments.\n");
        } else {
            printf("Error: too many arguments.\n");
        }
        exit(1);
    }

    return 0;
}
