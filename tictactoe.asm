TITLE Tic Tac Toe

; Link to github code: 
; Tic-Tac-Toe created in MASM x86. 


; Registers used in the program: 	
	;1)	eax, esi, edx, ecx, edi , ebp, esi
	
; Classification of registers:
	;1) EDX: Used to display text instructions
	
; Procedures:
	;1)	Main Procedure
	;2)  resetBoard Procedure
	;3)  displayBoard  Procedure
	;4)  convert  Procedure
	;5)  checkWin Procedure
	;6)  printWinner Procedure

	
; Problems with game:

INCLUDE Irvine32.inc

.const
	max			DWORD		9		;This is for the loop (mov ECX, max) in restBoard PROC				
	empty		BYTE        " ",0
	letterO        BYTE        "O",0
	letterX        BYTE        "X",0    


MAX_SIZE = 9	;Size of array that keeps track of the O/X/Empty spaces on the board

.data
	intro		         BYTE		"WELCOME TO TIC TAC TOE",0		;intro text for the game
	board                   DWORD       MAX_SIZE	DUP(?)				;This will be the array that will keep track of which spots have O/X/Empty || Empty = 0 || O = 1 || X = 2
	horizontal              BYTE        "|",0
	vertical                BYTE        "-----",0
	xwinStatement           BYTE       "X wins!",0                           ;Displays if X player wins
	owinStatement           BYTE       "O wins!",0                           ;Displays if O player wins
	tieGame                 BYTE       "The game is a tie!",0                ;Displays if the game results in a tie
	playerMoveStatement     BYTE       " Move:"
	Turn_count              DWORD      0							    ;keeps track of how many turns have passed in the game

.code
main PROC
	introduction:
		mov EDX, OFFSET intro
		call WriteString
		call crlf
		call resetBoard
		call displayBoard




		exit
main ENDP

resetBoard PROC						;This procedure is responsible of making all values on the board empty(0)
	mov ECX, max					;Make ECX = 9 which how many times loop needs to reiterate to reset the board
	mov ESI, 0						;Start ESI = 0 which is the starting index of the array
	insertZero:						;Loop that makes board[ESI] = 0
		mov board[ESI], 0			;Make board [ESI] = 0
		add ESI, 4					;Make ESI increase to the next index of the array
		loop insertZero				;End of loop
	ret								;Returns back to the main procedure
resetBoard ENDP						;End of resetBoard procedure

displayBoard PROC					;This procedure will display the current values on the tictactoe board
	mov ECX, 3						;Make ECX = 3 which how many times the display loop will run
	mov ESI, 0						;Start ESI = 0 which is the starting index of the array
	display:						;Loop that will print out a row (3 values from the board)
		mov	EAX, board[ESI]			;Make EAX = board[ESI] = 0/1/2
		call convert				;Call covert to print out / /O/X/
		mov EDX, OFFSET horizontal	;Make EDX = '|'
		call WriteString			;Print horizontal bar of the tictactoe board

		add ESI, 4					;Make ESI increase to the next index of the array
		mov EAX, board[ESI]			;Make EAX = board[ESI] = 0/1/2
		call convert				;Call covert to print out / /O/X/
		mov EDX, OFFSET horizontal  ;Make EDX = '|'
		call WriteString			;Print horizontal bar of the tictactoe board

		add ESI, 4					;Make ESI increase to the next index of the array
		mov EAX, board[ESI]			;Make EAX = board[ESI] = 0/1/2
		call convert				;Call covert to print out / /O/X/

		call crlf					;Start on the next command line		
		mov EDX, OFFSET vertical	;Make EDX = '-----'
		call WriteString			;Print vertical bar of the tictactoe board
		call crlf					;Start on the next command line

		add ESI, 4					;Make ESI increase to the next index of the array

		loop display				;End of loop
	ret								;Return to main

displayBoard ENDP

convert PROC						;This procedure will use compare statements to decide what needs printed on the board. If EAX = 0, then ' ' . If EAX = 1, then 'O'. If EAX = 2, then 'X'  
	cmp EAX, 0						;Comparing EAX and 0
	je printEmpty					;If EAX = 0, then jump to printEmpty
	cmp EAX, 1						;Comparing EAX and 1
	je printO						;If EAX = 1, then jump to printO
	cmp EAX, 2						;Comparing EAX and 2
	je printX						;If EAX = 2, then jump to printX
	ret								;Return to displayBoard

	printEmpty:						;Prints ' '
		mov EDX, OFFSET empty		;Make EDX = ' '
		call WriteString			;Print EDX
		ret							;Return to displayBoard

	printO:							;Prints '0'
		mov EDX, OFFSET letterO		;Make EDX = 'O'
		call WriteString			;Print EDX
		ret							;Return to displayBoard

	printX:							;Prints 'X'
		mov EDX, OFFSET letterX		;Make EDX = 'X'
		call WriteString			;Print EDX
		ret							;Return to displayBoard

convert ENDP						;End of covert procedure

;Just takes player input and edits array accordingly
;Pops num off stack to determine if player is x or o
playerMove PROC
	push EBP								
	mov EBP,ESP
	mov EDI, [EBP+8]							;Moves player indication into EDI
	player_moves:
		mov EDX, OFFSET playerMoveStatement          ;moves player move statement into EDX
		call WriteString						;prints out move instruction
		call ReadInt							;takes user input for move
		cmp EAX,0								;checks that move is within board range(0,8)
		JL player_moves
		cmp EAX,8								;checks that move is within board range(0,8)
		JG player_moves
		mov EBX, board[EAX]						;moves board at entered location into ebx
		cmp EBX,0								;checks that board is empty at move destination
		JNE player_moves
		mov board[EAX], EDI						;Replaces board at EAX(player input) with player indicator 
playerMove ENDP


;take value stored in the stack to determine whether current player is x or o
checkWin PROC
	Horizontal_top:                               ;compares top 3 spots of board to see if they're equal and not equal to 0 to determine a winner
		mov EAX, board[0]                        ;moves board at 0 into eax
		mov EBX, board[1]					 ;moves board at 1 into eax
		mov ECX, board[2]					 ;moves board at 2 into eax
		cmp EAX,0					
		Je Horizontal_mid						
		cmp EAX, EBX						 ;compares board at 0 to board at 1
		Jne Horizontal_mid
		cmp EAX, ECX                             ;compares board at 1 to board at 2
		Jne Horizontal_mid
		call printWinner					;If theyre all the same prints winner out depending on value pushed into stack
		jmp Won

	Horizontal_mid:                                ;compares middle(horizontal) 3 spots of board to see if they're equal and not equal to 0 to determine a winner
		mov EAX, board[3]
		mov EBX, board[4]
		mov ECX, board[5]
		cmp EAX,0
		Je Horizontal_bottom
		cmp EAX, EBX
		Jne Horizontal_bottom
		cmp EAX, ECX
		Jne Horizontal_bottom
		call printWinner
		jmp Won

	Horizontal_bottom:                            ;compares bottom 3 spots of board to see if they're equal and not equal to 0 to determine a winner
		mov EAX, board[6]
		mov EBX, board[7]
		mov ECX, board[8]
		cmp EAX,0
		Je Vertical_left
		cmp EAX, EBX
		Jne Vertical_left
		cmp EAX, ECX
		Jne Vertical_left
		call printWinner
		jmp Won

	Vertical_left:                                 ;compares left 3 spots of board to see if they're equal and not equal to 0 to determine a winner
		mov EAX, board[0]
		mov EBX, board[3]
		mov ECX, board[6]
		cmp EAX,0
		Je Vertical_mid
		cmp EAX, EBX
		Jne Vertical_mid
		cmp EAX, ECX
		Jne Vertical_mid
		call printWinner
		jmp Won

	Vertical_mid:                                  ;compares middle(vertical) 3 spots of board to see if they're equal and not equal to 0 to determine a winner
		mov EAX, board[1]
		mov EBX, board[4]
		mov ECX, board[7]
		cmp EAX,0
		Je Vertical_right
		cmp EAX, EBX
		Jne Vertical_right
		cmp EAX, ECX
		Jne Vertical_right
		call printWinner
		jmp Won

	Vertical_right:                               ;compares right 3 spots of board to see if they're equal and not equal to 0 to determine a winner
		mov EAX, board[2]
		mov EBX, board[5]
		mov ECX, board[8]
		cmp EAX,0
		Je Cross_left
		cmp EAX, EBX
		Jne Cross_left
		cmp EAX, ECX
		Jne Cross_left
		call printWinner
		jmp Won

	Cross_left:                                 ;compares diagonal from top left to bottom right 3 spots of board to see if they're equal and not equal to 0 to determine a winner
		mov EAX, board[0]
		mov EBX, board[4]
		mov ECX, board[8]
		cmp EAX,0
		Je Cross_right
		cmp EAX, EBX
		Jne Cross_right
		cmp EAX, ECX
		Jne Cross_right
		call printWinner
		jmp Won

	Cross_right:                                ;compares diagonal from top right to bottom left 3 spots of board to see if they're equal and not equal to 0 to determine a winner
		mov EAX, board[0]
		mov EBX, board[4]
		mov ECX, board[8]
		cmp EAX,0
		Je Tie
		cmp EAX, EBX
		Jne Tie
		cmp EAX, ECX
		Jne Tie
		call printWinner
		jmp Won

	Tie:                                       ;Determines if no winner has been found and turn count has hit maximum(9) that game ends in tie and prints out tie statement
		cmp Turn_Count,9
		mov EDX, OFFSET tieGame
		call WriteString
		call Crlf

	Won:
		;call Either board reset or end game

	No_win:
ret 4
checkWin ENDP


;Uses value on stack to determine whether current player is x or o
printWinner PROC
	push EBP
	mov EBP,ESP
	mov EDI, [EBP+12]                             ;Moves player indication into EDI
	cmp EDI, 1                                    ;Test if player is O
		JNE Winner_x                             ;Jumps to X if player is not O
		winner_o:
			mov EDX, OFFSET owinstatement       ;Prints out O winner
			call WriteString
			call Crlf
		cmp EDI, 2                                ;Jumps past x winner if player is O    
		JNE next
		winner_x:
			mov EDX, OFFSET xwinstatement       ;Prints out X winner
			call WriteString
			call Crlf
		next:
	pop EBP                                      ;pops EBP back off the stack to restore it
	ret 
	printWinner ENDP

END main