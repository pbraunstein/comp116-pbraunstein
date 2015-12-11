#!/usr/bin/env python
#
# determineOrder.py
# Philip Braunstein
# COMP116: Making Secure Easy-to-Remember Passwords
#
# Randomizes the order of experiments for each participant.
# RS  - random string
# MPN - memorable phrase and number
# MX  - modified XKCD
#

from sys import exit
import random

def main():
    opts = ['RS', 'MPM', 'MX']

    random.shuffle(opts)

    for method in opts:
        print method

    exit(0)


if __name__ == '__main__':
    main()
