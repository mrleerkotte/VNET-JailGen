#!/usr/bin/python
# macgen.py script to generate a MAC address for Red Hat Virtualization guests
#
import random
#
format = ""

def randomMAC():
    mac = [ 0x00, 0x16, 0x3e,
            random.randint(0x00, 0x7f),
            random.randint(0x00, 0xff),
            random.randint(0x00, 0xff) ]

    if format == "t":
        return '-'.join(map(lambda x: "%02x" % x, mac))
    else:
        return ':'.join(map(lambda x: "%02x" % x, mac))
#
print randomMAC()
