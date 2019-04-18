#!/bin/python3

import os
import pprint
import re

def printboards(boards):
    print("%s\n" % re.sub(r"'|[)]|[(]|^ ", '', pprint.pformat("%s" % boards, width=80)))

os.chdir("boards.d")

allwinner = ""
allwinner64 = ""
mx6 = ""
omap = ""
mvebu = ""
st = ""
other = ""

for entry in sorted(os.listdir('.')):

    if os.path.islink(entry):
        if 'AllWinner' == os.path.basename(os.path.realpath(entry)):
            allwinner += "%s " % entry
        elif 'AllWinner-A64' == os.path.basename(os.path.realpath(entry)):
            allwinner64 += "%s " % entry
        elif 'omap' == os.path.basename(os.path.realpath(entry)):
            omap += "%s " % entry
        elif 'imx6' == os.path.basename(os.path.realpath(entry)):
            mx6 += "%s " % entry
        elif 'mvebu' == os.path.basename(os.path.realpath(entry)):
            mvebu += "%s " % entry
        elif 'st' == os.path.basename(os.path.realpath(entry)):
            st += "%s " % entry
        else:
            if entry != 'none':
                other += "%s " % entry



print("AllWinner Devices:")
printboards(allwinner)

print("AllWinner-A64 Devices:")
printboards(allwinner64)

print("MX6 Devices:")
printboards(mx6)

print("OMAP Devices:")
printboards(omap)

print("MVEBU Devices:")
printboards(mvebu)

print("ST Devices:")
printboards(st)

print("Other Devices:")
printboards(other)
