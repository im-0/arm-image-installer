#!/bin/python3

import os
import pprint
import re

def printboards(boards):
    print("%s\n" % re.sub(r"'|[)]|[(]|^ ", '', pprint.pformat("%s" % boards, width=80)))

os.chdir("boards.d")

allwinner = ""
mx6 = ""
omap = ""
mvebu = ""
other = ""

for entry in sorted(os.listdir('.')):

    if os.path.islink(entry):
        if 'AllWinner' in os.path.realpath(entry):
            allwinner += "%s " % entry
        elif 'omap' in os.path.realpath(entry):
            omap += "%s " % entry
        elif 'imx6' in os.path.realpath(entry):
            mx6 += "%s " % entry
        elif 'mvebu' in os.path.realpath(entry):
            mvebu += "%s " % entry
        else:
            if entry != 'none':
                other += "%s " % entry


print("AllWinner ones:")
printboards(allwinner)

print("MX6 ones:")
printboards(mx6)

print("OMAP ones:")
printboards(omap)

print("MVEBU ones:")
printboards(mvebu)

print("Other ones:")
printboards(other)