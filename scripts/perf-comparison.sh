#!/bin/bash

mkdir -p /tmp/ranges
scripts/iptestgen.py > /tmp/ranges/ips

TIMEFORMAT=%R
TIME1=$({ time cat /tmp/ranges/ips | scripts/ipranges.py > /tmp/ranges/ips-ranges1; } 2>&1)
TIME2=$({ time cat /tmp/ranges/ips | bin/ranges -i > /tmp/ranges/ips-ranges2; } 2>&1)

diff /tmp/ranges/ips-ranges1 /tmp/ranges/ips-ranges2
rm -rf /tmp/ranges

echo "ipranges.py: ${TIME1}s"
echo "ranges -i: ${TIME2}s"
