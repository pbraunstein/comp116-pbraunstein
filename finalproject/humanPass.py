#!/usr/bin/env python

# CONSTANTS
NOUN_FILE = "nouns.txt"
VERB_FILE = "verbs.txt"
ADJ_FILE = "adjectives.txt"
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
