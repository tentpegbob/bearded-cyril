from random import randint

#Initialize the Board here
#BOARDSIZE is a static constant that controls the size of the board
BOARDSIZE = 5
board = []
for x in range(0, BOARDSIZE):
    board.append(["O"] * BOARDSIZE)
    
def print_battleship():
	print \
"                                     # #  ( )\n"\
"                                  ___#_#___|__\n"\
"                              _  |____________|  _\n"\
"                       _=====| | |            | | |==== _\n"\
"                 =====| |.---------------------------. | |====\n"\
"   <--------------------'   .  .  .  .  .  .  .  .   '--------------/\n"\
"     \                                                             /\n"\
"      \_______________________________________________WWS_________/\n"\
"  wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww\n"\
"wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww\n"\
"   wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww \n"

def print_begin_art():
    print "Welcome to Battleship. You will get", BOARDSIZE, \
    "turns to try and win."
    print "Each column and row begins at 0 and continues until "\
    "the last column. \nFor example: The top most left corner "\
    "is row 0 and column 0.\n"

    print \
    " o__ __o                               o\n"\
    "<|     v\                            _<|>_            \n"\
    "/ \     <\                                            \n"\
    "\o/     o/    o__  __o     o__ __o/    o    \o__ __o  \n"\
    " |__  _<|    /v      |>   /v     |    <|>    |     |> \n"\
    " |       \  />      //   />     / \   / \   / \   / \ \n"\
    "<o>      /  \o    o/     \      \o/   \o/   \o/   \o/ \n"\
    " |      o    v\  /v __o   o      |     |     |     |  \n"\
    "/ \  __/>     <\/> __/>   <\__  < >   / \   / \   / \ \n"\
    "                                 |                    \n"\
    "                         o__     o                    \n"\
    "                         <\__ __/>                    \n"
 

def print_board(board):
    for row in board:
        print " ".join(row)

def random_row(board):
    return randint(0, len(board) - 1)

def random_col(board):
    return randint(0, len(board[0]) - 1)

def main():
    ship_row = random_row(board)
    ship_col = random_col(board)

    print_begin_art()
    print_board(board)

    turn = 0
    while True:
        try:
            guess_row = int(raw_input("Guess Row:"))
            guess_col = int(raw_input("Guess Col:"))
        except:
            print "\"You didn't even enter a number!\""
            print "\"Please enter a number from 0 -", BOARDSIZE-1,"\""
            continue
        
        if guess_row not in range(BOARDSIZE) or \
            guess_col not in range(BOARDSIZE):
            print "\"Oops, that's not even in the ocean.\""
            continue
    
        if (guess_row == ship_row) and (guess_col == ship_col):
            print "\"Congratulations! You sank my battleship!\""
            print_battleship()
            break
        elif board[guess_row][guess_col] == "X":
            print "You guessed that one already."
        else:
            print "\"You missed my battleship!\"\n"
            board[guess_row][guess_col] = "X"

            turn += 1
            print "Turn", turn
            print_board(board)
            if turn == (BOARDSIZE):
                print "\"Game Over\""
                break
                
main()
