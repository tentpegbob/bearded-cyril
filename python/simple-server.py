#!/usr/bin/python           # This is server.py file

import socket               # Import socket module

s = socket.socket()         # Create a socket object
host = socket.gethostname() # Get local machine name
port = 22222                # Reserve a port for your service.
s.bind((host, port))        # Bind to the port

s.listen(5)                 # Now wait for client connection.
while True:
   c, m = s.accept()     # Establish connection with client.
                         # whats the difference between c and m?
   print 'Got connection from', m
   c.send('Thank you for connecting')
   c.close()                # Close the connection

