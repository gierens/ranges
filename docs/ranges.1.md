---
title: RANGES
section: 1
header: User Manual
footer: ranges 0.1
date: October 25, 2022
---
# NAME
**ranges** - Command line program to extract ranges from the inputted list.

# SYNOPSIS
**ranges** [-H|-o|-b|-d|-i|-I|-m] [-f] [-h] [FILE]

# DESCRIPTION
**ranges** is a command line program written in C that extracts ranges from
various types of lists. By default it parses signed decimal integer lists,
but given the right argument it can work with unsigned hexadecimal, octal
and binary numbers, dates, IPv4, IPv6 and MAC addresses. The list input
is given over the standard input, so by pipe, and is assumed to be sorted,
but can have duplicates.

# OPTIONS
When no other range type is given, the program will extract ranges form a
list of signed decimal numbers in the format DDD...D with D being a decimal
digit. An example number would be 1234.

**FILE**
: Path to input file. If not specified, stdin is used, which has to be a pipe
and not a tty.

**-H**, **\--hex**
: Extract ranges from a list of unsigned hexadecimal numbers in the format
0xHHH...H with H being a hexadecimal digit, for example 0x12ab.

**-o**, **\--octal**
: Extract ranges from a list of unsigned octal numbers in the format
0oOOO...O with O being an octal digit, for example 0o0127.

**-b**, **\--binary**
: Extract ranges from a list of unsigned binary numbers in the format
0bBBB...B with B being a binary digit, for example 0b0110.

**-d**, **\--date**
: Extract ranges from a list of dates in the format YYYY-MM-DD, with YYYY
being the year, MM the month, and DD the month day, for example 2022-10-25.

**-i**, **\--ipv4**
: Extract ranges from a list of IPv4 addresses in the format iii.iii.iii.iii,
with iii being a decimal number between 0 and 255, for example 127.0.0.1 .

**-I**, **\--ipv6**
: Extract ranges from a list of IPv6 addresses either in the full format
IIII:IIII:IIII:IIII:IIII:IIII:IIII:IIII with I being a hexadecimal digit.
The shortened format is also supported, so for example ::1.

**-m**, **\--mac**
: Extract ranges from a list of MAC addresses in the format MM:MM:MM:MM:MM:MM,
with M being a hexadecimal digit, so for example 00:12:34:ab:cd:ef.

**-s**, **\--size**
: Count the ranges' sizes and output them in the third column.

**-f**, **\--force**
: Force the execution, so ignore parsing errors, like malformed IPv6
addresses.

**-h**, **\--help**
: Print the help message, containing a summary of this manual page.

**-v**, **\--version**
: Print version, copyright and license information.

# EXAMPLES
**printf \'1\\n2\\n2\\n3\\n6\\n7\\n8\\n\' | ranges**
: Default decimal number range extraction with will return the ranges
1 to 3 and 6 to 8 in the format: \'1 2\\n3 4\\n\'

**printf \'1.0.0.1\\n1.0.0.2\\n1.1.1.1\\n\' | ranges \--ipv4**
: Default decimal number range extraction with will return the ranges
1 to 3 and 6 to 8 in the format: \'1.0.0.1 1.0.0.2\\n1.1.1.1 1.1.1.1\\n\'

# BUGS
Submit bug reports online at: <https://github.com/gierens/ranges/issues>

# SEE ALSO
Full documentation and sources at: <https://github.com/gierens/ranges>

# COPYRIGHT
Copyright (C) 2022 Sandro-Alessio Gierens

License GPLv3+: GNU GPL version 3 or later <https://gnu.org/licenses/gpl.html>.

This is free software, you are free to change and redistribute it.
This program comes with ABSOLUTELY NO WARRANTY.

# AUTHORS
Written by Sandro-Alessio Gierens.
