### Alarm
##### Philip Braunstein (philb)

I believe all aspects of the program have been implemented successfully. I discussed this assignment with Evan Parton. I spent around 12 hours on this assignment (longer than I imagined myself needing).

1. The heuristics are okay, but they are clearly easily evadable. Detecting NMAP and NIKTO scans is done by string matching payload to those terms, but this is easily evadable. The most reliable heuristics are the ones that actually look at the flags that are on in the packet. For example, I am fairly confident that my alarm would notice an XMAS scan, but not as confident that it would recognize any generic NMAP scan. The credit card detection is also pretty good. The heuristic for finding code injected into shells just looks for anything containing \x in it. This might lead to some false positives, but better safe than sorry. However, I wonder if there is a better heuristic for this.

2. If I had more time, I would hard code the rest of the types of NMAP scans in with respect to the flags they have on instead of just looking for NMAP in the text. 

#### Changes / (possible) Improvements
1. I added a bit to the suggested regex for credit cards in the article the assignment links to. I added a \D character at the end, to make sure that there weren’t more numbers, which would indicate some other kind of number, (not a credit card number).

2. I have the alarm actually print out the credit card number discovered. I would imagine that a user of this alarm may want to cancel or at least closely monitor card numbers leaked in the plain text to prevent suspicious activity. To do this, it is helpful for the alarm to tell the user what the credit card numbers were, that were leaked.

3. I do not print the payload when analyzing live traffic. I found that whether or not using Base64 decoding, printing the payload often resulted in gross unprintable characters. I decided for usability sake to not print the payload. This is not a problem in the log files, so the log files print the payload.