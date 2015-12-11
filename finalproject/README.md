### Making Secure Easy-to-Remember Passwords
##### Philip Braunstein (pbraunstein12@gmail.com)
##### Advised by Ming Chow
##### Fall 2015

#### Overview
This repository contains my final project for the COMP116 security class. The
`scripts` folder contains all of the scripts described in the report, and the
wordlists folder contains the word lists used to make the MX passwords. The
final write up of the report is the Better\_Passwords.pdf document. The scripts
and wordlists are publically available in this github repository:
https://github.com/pbraunstein/Security-Final-Project

#### Scripts
`charFracSim.py`: This script deterimines the fraction of the characters common
between two passwords provided on the command line.

`determineOrder.py`: This script randomizes the order in which the password
types should be tested.

`humanPass.py`: This script uses the noun, verb, and adjective word lists to
generate 10 of the MX passwords.

`makeHashes.py`: This script takes a file name as input and writes out a new
file with each of the lines of the file hashed using MD5 without salt.

`randomPass.py`: This script generates 10 of the RS passwords.

`smartFracSim.py`: This script determines the average of the forward and
reverse percent similarities of two passwords.
