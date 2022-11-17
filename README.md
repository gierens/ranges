# ranges

![build](https://github.com/gierens/ranges/actions/workflows/build.yml/badge.svg)
![tests](https://github.com/gierens/ranges/actions/workflows/test.yml/badge.svg)

**ranges** is a command line program written in C that extracts ranges from
various types of lists. By default it parses signed decimal integer lists,
but given the right argument it can work with unsigned hexadecimal, octal
and binary numbers, dates, IPv4, IPv6 and MAC addresses. The list input
is given over the standard input, so by pipe, and is assumed to be sorted,
but can have duplicates.

## Installation

## Usage

## Remarks

### Use Cases
In case you wonder when this program might be useful, let me give you a short
example: I work in data center on a system consisting of a larger number of
servers. Their different IP addresses are configured statically and also
contained in the `/etc/hosts` of our management machine. Unfortunately, the way
we initially assigned the addresses to the different types of nodes (compute,
gpu, ...) turned out not to be very scalable, when we got a huge bunch of new
servers. Our subnet was a mess in terms of fragmentation and finding the
still free addresses manually would have been tedious. We wondered whether
there was any command line tool that could summarize the list of IP addresses
from the `/etc/hosts` into address ranges, so we could easily find the gaps.
While it didn't take more than a few minutes to program a small Python script
that would do just that, at least for IPv4 addresses, I was surprised that I
couldn't find any general command line tool for the job.

### Performance
It is obviously more convenient to have a ready to use command line tool that
supports different types of lists, instead of scripting a new one anytime
some problem like the one described above comes up, **ranges** is written in C
and therefore also much faster. A short runtime comparison with a Python
script similar to my first one on a large IPv4 address list (10 million
entries) gives the following results:
```bash
$> make perf-comparison
./scripts/perf-comparison.sh
ipranges.py: 29.188s
ranges -i: 0.836s
$>
```

## License
This code is distributed under [GPLv3](LICENSE) license.
