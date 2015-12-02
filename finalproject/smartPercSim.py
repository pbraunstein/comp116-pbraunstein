#!/usr/bin/env python
#
# smartPercSim.py
# Philip Braunstein
# COMP116: Making Secure Easy-to-Remember Passwords
#
# Evaluates the percent similarity of two strings passed to the script on the
# command line by averaging the forward and backgward percent similarities
#

from sys import exit
from sys import argv

def main():
    if len(argv) != 3:
        usage()

    forPercSim = percSim(argv[1], argv[2])
    revPercSim = percSim(argv[1][::-1], argv[2][::-1])


    avgPercSim = (forPercSim + revPercSim) / 2.0

    print "Forward Percent Similarity:", forPercSim
    print "Reverse Percent Similarity:", revPercSim
    print "Average Percent Similarity:", avgPercSim
    
    exit(0)


# Prints the usage of the script then exits nonzero
def usage():
    print "USAGE:", argv[0], "STRING_1 STRING_2"
    exit(1)


# Returns the percent similarity of the strings s1 and s2
# If the strings are of unequal lengths, spaces are inserted at the end of the
# shorter string
def percSim(s1, s2):
    numSims = 0

    if len(s1) < len(s2):
        s1 = addNSpaces(s1, len(s2) - len(s1))
    elif len(s2) < len(s1):
        s2 = addNSpaces(s2, len(s1) - len(s2))

    # INVARIANT: Both strings must be the same length at this point
    for i in range(len(s1)):
        if s1[i] == s2[i]:
            numSims += 1


    return float(numSims) / float(len(s1))





# Returns a string s with spacesToAdd spaces appended to the end of it
def addNSpaces(s, spacesToAdd):
    for i in range(spacesToAdd):
        s += ' '

    return s


if __name__ == '__main__':
    main()
