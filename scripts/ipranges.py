#!/usr/bin/env python3

from sys import stdin
from ipaddress import ip_address

line = stdin.readline()
ip = ip_address(line.splitlines()[0])
end = ip

print(f'{ip}', end='')
for line in stdin:
    ip = ip_address(line.splitlines()[0])
    if ip == end + 1:
        end = ip
    else:
        print(f' {end}')
        print(f'{ip}', end='')
        end = ip
print(f' {end}')
