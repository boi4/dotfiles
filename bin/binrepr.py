#!/usr/bin/env python3
import ipaddress
import sys

if len(sys.argv) != 2:
    print("""
    Usage: {} xxx.xxx.xxx.xxx
    """.format(sys.argv[0])
    )
    sys.exit(0)

if ':' in sys.argv[1]:
    a = ipaddress.IPv6Address(sys.argv[1])
    l = 16
else:
    a = ipaddress.IPv4Address(sys.argv[1])
    l = 4
b = int(a)

res = ""
for i in range(l):
    res += bin((b >> ((l-i-1) * 8)) & 0xff)[2:].rjust(8,'0')
    if i != 3:
        res += " "
print(res)

