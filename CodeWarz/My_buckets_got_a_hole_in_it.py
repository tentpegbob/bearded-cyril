#!/usr/bin/env python

import sys

i = []
i = open(sys.argv[1]).read().split()

mycnt = []
MAX = int(max(i, key=int))/10+1
for x in range(MAX):
    mycnt.append(0)

for cnt in range(len(i)):
    for x in range(1, MAX+1):
        if (int(i[cnt]) < 10*x):
            mycnt[x-1] += 1
            break

c = ""
for x in range(len(mycnt)):
     c += str(mycnt[x])
print c
