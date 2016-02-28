#!/usr/bin/python
import binascii

var1 = 1
var2 = ""

var2 = "A"
var_is_hex = "\x41"
var_is_oct = "\o100"
var_is_bin = "\b10001000"
print var2
print binascii.hexlify(var2)
print int(binascii.hexlify(var2))-1

try:
    print var2-1
except:
    print "\tthat didn't quite work right"

array1 = [1, 2, 3, 4]
array2 = ["a", "b", "c"]
array3 = [array1, array2]

print array1, "\n", array2, "\n", array3
print "A" + " " + "array2"
print "%s" % array1

dictionary = { "user": "Leander, Alex, Bob, Joe", "fav_food": "pizza"}
print dictionary
print "User is", dictionary["user"], "and his favorite food is", dictionary["fav_food"]
