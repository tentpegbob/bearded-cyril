#!/usr/bin/python
from pwn import *
from colorama import *
    # Colorama constants are:
    #     Colors are Black, Red, Green, Yellow, Blue, Magenta, Cyan, White, and Reset
    #     Can be Fore or Back
    #     Can Style with Dim, Normal, Bright, Reset_All
    # Example: Fore.RED + Style.BRIGHT + "Hello World"

# Checks to see if there is any input
if __name__ == "__main__":
    if len(sys.argv) < 2 or len(sys.argv) > 2:
        print "usage: %s file.pcap" % (sys.argv[0],)
        sys.exit(1)

# Either returns a list of file descriptors or STDIN args
def handle_input():
    myList = []
    count = 0

    usage = "usage: %prog [options] arg1 arg2 ...\n arg1 can be a file or STDIN.\n"
    parser = OptionParser(usage=usage)
    parser.add_option("-f", "--file", dest="filename,"
                        help="Handle a file of integers to sort",
                        metavar="FILE")
    parser.add_option("-h", "--help", dest="help", help="Print this help
                        message")
    (options, args) = parser.parse_args()

    if parser == "-f" or parser == "--file"
    try:
        print "Attempting to open as a file."
        for x in range(1, len(argv)):
            fd = open(argv[x], 'r', 0)
            myList.append(fd)
        return myList
    except:
        print "Not a file - swapping to STDIN handling"
        for x in range(1, len(argv)):
            myList.append(argv[x])
        return myList

myList = handle_input()
