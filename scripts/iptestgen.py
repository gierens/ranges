#!/usr/bin/env python3

from ipaddress import ip_address
from random import random

ip = ip_address('10.0.0.0')

number = 10000000
count = 0
while count < number:
    if random() < 0.1:
        ip += 1
    if random() < 0.9:
        print(ip)
        ip += 1
        count += 1
