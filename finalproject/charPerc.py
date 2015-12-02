#!/usr/bin/env python
#
# charPerc.py
# Philip Braunstein
# COMP116: Making Secure Easy-to-Remember Passwords
#
# Determines a perent similarity metric of character count similarity. Where
# the percentage of each character of a string in the other string is
# calculated.
#

from sys import exit
from sys import argv

def main():
    if len(argv) != 3:
        usage()

    dicts1 = makeDict(argv[1])
    dicts2 = makeDict(argv[2])

    charPercList = compareDicts(dicts1, dicts2)

    charPerc = float(sum(charPercList)) / float(len(charPercList))

    print "Character Percent Similarity:", charPerc

    exit(0)


# Prints the usage of the script then exits nonzero
def usage():
    print "USAGE:", argv[0], "STRING_1 STRING_2"
    exit(1)


# Makes a dictionary of character counts from string s and returns this dict
def makeDict(s):
    toReturn = {}

    for c in s:
        try:
            toReturn[c] += 1
        except KeyError:
            toReturn[c] = 1

    return toReturn


# Constructs a list of the percentage of each charater from one string in the
# other. To get this number the smaller is divided into the bigger. For
# example, if one string has 3 of one character and the other has 4 of that
# character, the percentage is always 0.75 rather than 1.33. Returns this list.
def compareDicts(dicts1, dicts2):
    toReturn = []
    allKeys = set(dicts1.keys() + dicts2.keys())  # Set for no duplicate keys

    for key in allKeys:
        try:
            toReturn.append(float(min(dicts1[key], dicts2[key])) /\
                                        float(max(dicts1[key], dicts2[key])))
        except KeyError:
            toReturn.append(0.0)  # If letter not found in a string, perc is 0

    return toReturn


if __name__ == '__main__':
    main()
