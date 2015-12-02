#!/usr/bin/env python
#
# humanPass.py
# Philip Braunstein
# COMP116: Making Secure Easy-to-Remember Passwords
#
# Generates 10 modified XKCD style passwords from noun, verb, and adjective
# word lists. Prints all passwords (each word separated by spaces for
# readability) to screen.
#

# CONSTANTS
NOUN_FILE = "../wordlists/nouns.txt"
VERB_FILE = "../wordlists/verbs.txt"
ADJ_FILE = "../wordlists/adjectives.txt"
NUM_PASSES = 10

from sys import exit
import random

def main():
    nouns = readIn(NOUN_FILE)
    verbs = readIn(VERB_FILE)
    adjs = readIn(ADJ_FILE)

    for x in range(NUM_PASSES):
        passWord = ''
        passWord += random.choice(adjs) + ' '
        passWord += random.choice(nouns) + ' '
        passWord += random.choice(verbs) + ' '
        passWord += random.choice(adjs) + ' '
        passWord += random.choice(nouns) + ' '
        print passWord

    exit(0)


# Reads in a line separated file into one long list. Controls for
# capitalization
def readIn(inputFile):
    toReturn = []
    with open(inputFile, 'r') as filer:
        for line in filer:
            toReturn.append(line.strip().lower())

    return toReturn


if __name__ == '__main__':
    main()
