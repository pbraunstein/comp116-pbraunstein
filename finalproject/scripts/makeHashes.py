#!/usr/bin/env python
#
# makeHashes.py
# Philip Braunstein
# COMP116: Making Secure Easy-to-Remember Passwords
#
# Hashes each line of the first file on the command line and writes out the
# results to the second file provided on the command line. This script uses an
# unsalted MD5 hash/
#

from sys import argv
from sys import exit
import hashlib

def main():
    if len(argv) != 3:
        usage()

    filew = open(argv[2], 'w') 

    with open(argv[1]) as filer:
        for line in filer:
            line = line.strip()
            p = hashlib.md5()
            p.update(line)
            filew.write(p.hexdigest() + "\n")

    filew.close()

    exit(0)


def usage():
    print "USAGE:", argv[0], "INPUT_FILE OUTPUT_FILE"
    exit(1)


if __name__ == '__main__':
    main()
