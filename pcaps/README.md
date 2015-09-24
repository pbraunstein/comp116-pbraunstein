### Comp 116 Assignment 1
#### Philip Braunstein (pbraunstein12@gmail.com)
###### September 23, 2015


**set1.pcap**

1. 861 packets

2. FTP

3. FTP is an unencrypted service. Therefore, all the data is transmitted in plaintext / in the clear,
and anyone capturing traffic can construct a copy of the file.

4. sFTP

5. 192.168.1.8.

6. defcon:m1ngisablowhard (username:password)

7. 6 files

8. CDkv69qUsAAq8zN.jpg, CLu-m0MWoAAgjkr.jpg, CJoWmoOUkAAAYpx.jpg, COaqQWnU8AAwX3K.jpg, CNsAEaYUYAARuaj.jpg, CKBXgmOWcAAtc4u.jpg


**set2.pcap**

10. 77982 packets

11. 1 pair

12. This was insanenly easy using GUI ettercap. I just loaded the file and scanned the output to see any username or passwords.

13. larry@radsot.com:Z3lenzmej, PROTOCOL: IMAP, SOURCE: 10.125.15.197, DESTINATION: 87.120.13.118, PORT: 143, DOMAIN_NAME:neterra.net

14. This username password pair was granted access successfully.

**set3.pcap**

15. 3 pairs

16. seymore:butts, PROTOCOL: HTTP, SOURCE: 10.134.15.231, DESTINATION: 162.222.171.208, PORT: 80, DOMAIN_NAME: cascadelink.com

    nab01620@nifty.com:Nifty->takirin1, PROTOCOL: IMAP, SOURCE: 10.115.15.213, DESTINATION: 210.131.4.155, PORT: 143, DOMAIN_NAME: nifty.com

    jeff:asdasdasd, PROTOCOL: HTTP, Source: 10.139.15.225, DESTINATION: 54.191.109.23, PORT: 80, DOMAIN_NAME: aws.amazon.com

17. The last two pairs listed in 16. were granted access successfully.

18. The most popular hostnames include amazon web services (a number of IP addresses including 54.193.4.196 and 54.219.162.53), twitter api (199.16.156.xxx block), and various google services (216.58.216.xxx and 216.58.217.xxx).

**general**

19. To verify successful username-password pairs, I followed the TCP stream in Wireshark to see if either 200 OK and/or LOGIN SUCCESSFUL messages were sent back by the server, or there was some kind of PERMISSION DENIED message. It was generally pretty clear what happened.

20. Whenever you are using any kind of passwords or dealing with any kind of sensitive data, only only only use encrypted protocols (sFTP, HTTPS, etc.)

**Cool hack I came up with**

In order to correlate the names of the jpg files with the actual files pulled from the pcap files, I noticed that also transferred by ftp was a list of the file names including their sizes (looked like ls -l). Since each file had a unique size, it was possible to figure out from the names of the files.
