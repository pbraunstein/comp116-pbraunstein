#!/usr/bin/env python

from sys import exit
import random

def main():
    opts = ['Random Strings', 'Memorable Phrase and Number', 'Modified XKCD']

    random.shuffle(opts)

    for method in opts:
        print method

    exit(0)


if __name__ == '__main__':
    main()
