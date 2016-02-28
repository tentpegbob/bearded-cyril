#!/usr/bin/python
# Written by Leander Metcalf
# 22 January 2016
# Simple program with options that will sort a list of given integers.
# It then prints it out all pretty.

import sys, argparse

#pip install colorama
from colorama import *
    # Colorama constants are:
    #     Colors are Black, Red, Green, Yellow, Blue, Magenta, Cyan, White, and Reset
    #     Can be Fore or Back
    #     Can Style with Dim, Normal, Bright, Reset_All
    # Example: Fore.RED + Style.BRIGHT + "Hello World"

# func foo(int array[])
def sort_descending(array):
    for x in range(len(array)):
        for y in range(len(array)-1):
            if int(array[y]) < int(array[y+1]):
                temp = array[y+1]
                array[y+1] = array[y]
                array[y] = temp
    return array

def sort_ascending(array):
    for x in range(len(array)):
        for y in range(len(array)-1):
            if int(array[y]) > int(array[y+1]):
                temp = array[y+1]
                array[y+1] = array[y]
                array[y] = temp
    return array

def sort_me(order, input):
    if order == "a":
        return sort_ascending(input)
    elif order == "d":
        return sort_descending(input)
    else:
        print Fore.RED + Style.BRIGHT + "[ERROR]" + Fore.CYAN + " Sort method unavailable" + Style.RESET_ALL
        return -1

def handle_output(sorted_list):
    args.o.write(Fore.GREEN)
    try:
        for x in range(1, len(sorted_list)+1):

            if x%args.col == 0:
                if x%(args.col*2) == 0:
                    args.o.write("\t" + str(sorted_list[x-1]) + "\n" + Fore.GREEN)
                else:
                    args.o.write("\t" + str(sorted_list[x-1]) + "\n" + Fore.CYAN)
            else:
                args.o.write("\t" + str(sorted_list[x-1]) + "\t")
        print Style.RESET_ALL
    except Exception as e:
        print Fore.RED + Style.BRIGHT + "[ERROR]" + Fore.CYAN + " Unable to write to file" + Style.RESET_ALL
        exit()

# This starts the program
parser = argparse.ArgumentParser(description="Sorts some integers in a specified order. Input can come from a file, STDIN, or a list provided as arguments to this script. By default the sorted list will be printed to STDOUT, but you also have the option of writing to a choosen file.", usage="%(prog)s {a,d} [options]", epilog="and thats how you sort your head from your tail.")

parser.add_argument("order", choices=["a", "d"], type=str, nargs="?", default="a", help="Choose the order you want to sort ascending or descending. Default is ascending order.")
parser.add_argument("-i", metavar="iFILE", nargs="?", type=argparse.FileType("r"), default=sys.stdin, help="Use the -i option when you have integers in a file to sort. Default is STDIN.")
parser.add_argument("-o", metavar="oFILE", nargs="?", type=argparse.FileType("w+"), default=sys.stdout, help="Use the -o option when you want to write the output to a file. Default is STDOUT.")
parser.add_argument("-l", metavar="L", type=int, nargs="+", help="A list of integers.")
parser.add_argument("-col", metavar="COL", default=8, type=int, help="The number of columns you want your output. Default is 8.")

args = parser.parse_args()

if args.i and not args.l:
    try:
        sorted_list = sort_me(args.order, args.i.read().split())
    except:
        print Fore.RED + Style.BRIGHT + "[ERROR]" + Fore.CYAN + " Input does not contain all integers" + Style.RESET_ALL
        exit()
    handle_output(sorted_list)

if args.l:
    try:
        sorted_list = sort_me(args.order, args.l)
    except:
        print Fore.RED + Style.BRIGHT + "[ERROR]" + Fore.CYAN + " Input does not contain all integers" + Style.RESET_ALL
        exit()
    handle_output(sorted_list)

args.i.close()
args.o.close()
exit()
