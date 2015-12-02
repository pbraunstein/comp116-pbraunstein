#!/usr/bin/env python
# Prints options for random password PW_LENGTH long, containing 3 of the 4
# following character types: lower case letter, upper case letter, symbol,
# number

# CONSTANTS
NUM_PASSES = 10
PW_LENGTH = 10

from sys import exit
import string
import random
import re

def main():
    passes = []

    while len(passes) < NUM_PASSES:
        passWord = makePW()

        if isValid(passWord):
            passes.append(passWord)

    for pw in passes:
        print pw


# Makes a password of length PW_LENGTH using letters, digits, and punctuation
def makePW():
    toReturn = ''
    pool = string.letters + string.digits + string.punctuation
    for i in range(PW_LENGTH):
        toReturn += random.choice(pool)

    return toReturn

# Checks if a password is valid (has three of four of the following: lower case
# letter, upper case letter, number, and punctuation). Returns True if valid,
# False otherwise.
def isValid(pw):
    checks = 0
    if re.search('\d', pw) is not None:
        checks += 1
    if re.search('[a-z]', pw) is not None:
        checks += 1
    if re.search('[A-Z]', pw) is not None:
        checks += 1
    if re.search('\W|_', pw) is not None:
        checks += 1

    # Made at least 3 of 4
    if checks >= 3:
        return True
    else:
        return False

if __name__ == '__main__':
    main()
