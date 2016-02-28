#!/usr/bin/python

import socket

s = socket.socket()
host = socket.gethostname() #string,1.1.1.1, 12:45:ba::::00
port = 22222 #string, decimal, name of service
s.connect((host,port))
print s.recv(1024) #read until \n or \r
#s.read()
s.close()
