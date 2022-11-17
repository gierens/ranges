# ranges

![build](https://github.com/gierens/ranges/actions/workflows/build.yml/badge.svg)
![tests](https://github.com/gierens/ranges/actions/workflows/test.yml/badge.svg)

**ranges** is a command line program written in C that extracts ranges from
various types of lists. By default it parses signed decimal integer lists,
but given the right argument it can work with unsigned hexadecimal, octal
and binary numbers, dates, IPv4, IPv6 and MAC addresses. The list input
is given over the standard input, so by pipe, and is assumed to be sorted,
but can have duplicates.

## License
This code is distributed under [GPLv3](LICENSE) license.
