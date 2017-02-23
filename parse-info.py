#!/usr/bin/python

import fileinput

for line in fileinput.input():
    if line.startswith("SF:"):
        file = line.split("SF:")[1].rstrip()
    elif line.startswith("DA:") and int(line.split(",")[1].rstrip()) > 0:
        print file, (line.split("DA:")[1].rstrip()).split(",")[0]
