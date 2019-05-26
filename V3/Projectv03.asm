;CIS 11
;LAB 4
;Ian Harshbarger
;
;TEST SCORE CALCULATOR
;
;This program will find a minimum value, a maximum value and a letter grade equivalence of 
;inputed values. The input will be 5, 3 digit numbers that will be stored into arrays in 
;accordance with a base 10 number system

.ORIG x3000
	
	LD R1, SCORES1	;load scores base 10^2 address into R1
	LD R2, SCORES2	;load scores base 10^1 address into R2
	LD R3, SCORES3	;load scores base 10^-1 address into R3
	
	AND R4, R4, #0
	AND R0, R0, #0
	
INLOOP	LEA R0, MESG1
	PUTS
	AND R0, R0, #0
	GETC

	OUT
	STR R0, R1, #0	;Store input into address at R1[i]
	ADD R1, R1, #1	;i++ 
	
	GETC
	OUT
	STR R0, R2, #0	;Store input into address at R2[i]
	ADD R2, R2, #1	;i++ 

	GETC
	OUT
	STR R0, R3, #0	;Store input into address at R3[i]
	ADD R3, R3, #1	;i++ 
	
	LEA R0, ENDL
	PUTS
	ADD R4, R4, #1
	ADD R5, R4, #-5
	BRn INLOOP	

;===========================================================================
	;OUTPUT SECTION (For debugging)

	;LD R1, SCORES1	;load scores base 10^2 address into R1
	;LD R2, SCORES2	;load scores base 10^2 address into R1
	;LD R3, SCORES3	;load scores base 10^2 address into R1
	;AND R4, R4, #0

;OUTLOP1	LEA R0, ENDL
	;PUTS
	;LDR R0, R1, #0 
	;OUT
	;LDR R0, R2, #0 
	;OUT
	;LDR R0, R3, #0 
	;OUT
	;ADD R3, R3, #1
	;ADD R2, R2, #1
	;ADD R1, R1, #1
	;ADD R4, R4, #1
	;ADD R5, R4, #-5
	;BRn OUTLOP1
	
;===========================================================================

	LEA R0, ENDL	;add a space
	PUTS

	JSR MAX		;find Max value subroutine
	
	JSR MIN		;find Min value subroutine

	LEA R0, ENDL	;add a space
	PUTS

	JSR LETTER	;find and display letter grade of scores
	
	HALT

;===========================================================================

ENDL .STRINGZ "\n"
MESG1 .STRINGZ "Put in score: "
MAXMESG .STRINGZ "Max Score: "
MINMESG .STRINGZ "Min Score: "
LETMESG1 .STRINGZ "Letter Grade of "
LETMESG2 .STRINGZ " : "


SCORES1 .FILL x3500 ;10^2
SCORES2 .FILL X3600 ;10^1
SCORES3 .FILL x3700 ;10^-1

MAXI .FILL x3300
MINI .FILL x3301

SAVER0 .FILL x3204
SAVER1 .FILL x3205
SAVER2 .FILL x3206
SAVER3 .FILL x3207
SAVER4 .FILL x3208
SAVER5 .FILL x3209
SAVER6 .FILL x320A
SAVER7 .FILL x320B

RETADDRESS .FILL x6000
ADDRESS0 .FILL x320C

HEXN30 .FILL xFFD0 	;-48

;=================================================================================================================

MAX	ST R7, RETADDRESS
	AND R5, R5, #0
	ST R5, MAXI		;max value index
	LD R4, HEXN30

MLOOP1  ADD R5, R5, #1	;since first value is set to be the max we can start with address offset by 1
	AND R6, R6, #0
	ADD R6, R5, #-5
	BRz EXIT1

	LD R1, SCORES1	;10^2
	AND R2, R2, #0	;set max value
	LD R2 MAXI	
	ADD R1, R1, R2 	; ADDRESS OF MAX
	AND R2, R2, #0
	LDR R2, R1, #0	; load value of max

	LD R1, SCORES1	
	ADD R1, R1, R5 	; ADDRESS OF i
	LDR R3, R1, #0 	; load value of i
	
	ADD R2, R2, R4	; convert from ascii
	ADD R3, R3, R4	; ^^^^^^^
	
	ADD R6, R2, R3
	BRz MLOOP2	;if Max plus i is zero then no first number to compare	

	ADD R6, R3, #0
	BRz MLOOP1	;if Max>0 but i=0 then reiterate

	NOT R3, R3	; negate i
	ADD R3, R3, #1

	AND R6, R6, #0	
	ADD R6, R2, R3	;subtract i from MAX
	BRn GREATER 	;if negative i is greater
	BRz MLOOP2	;if zero more testing needed 
	BRp MLOOP1	;if positive i<MAX
	
MLOOP2	LD R2, SCORES2	;10^1
	AND R1, R1, #0	;set max value
	LD R1 MAXI
	ADD R2, R2, R1 	; ADDRESS OF MAX
	AND R1, R1, #0
	LDR R1, R2, #0	; load value of max

	LD R2, SCORES2	
	ADD R2, R2, R5 	; ADDRESS OF i
	LDR R3, R2, #0 	; load value of i

	ADD R1, R1, R4	; convert from ascii
	ADD R3, R3, R4	; ^^^^^^^

	ADD R6, R1, R3
	BRz MLOOP3	;if Max plus i is zero then no second number to compare	

	ADD R6, R3, #0
	BRz MLOOP1	;if Max>0 but i=0 then reiterate

	NOT R3, R3	; negate i
	ADD R3, R3, #1

	AND R6, R6, #0	
	ADD R6, R1, R3	;subtract i from MAX
	BRn GREATER 	;if negative i is greater
	BRz MLOOP3	;if zero more testing needed 
	BRp MLOOP1	;if positive i<MAX
	

MLOOP3	LD R3, SCORES3	;10^-1
	AND R1, R1, #0	;set max value
	LD R1 MAXI
	ADD R3, R3, R1 	; ADDRESS OF MAX
	AND R1, R1, #0
	LDR R1, R3, #0	; load value of max

	LD R3, SCORES3	
	ADD R3, R3, R5 	; ADDRESS OF i
	LDR R2, R3, #0 	; load value of i

	ADD R1, R1, R4	; convert from ascii
	ADD R2, R2, R4	; ^^^^^^^
	
	ADD R6, R1, R3
	BRz GREATER	;if Max plus i is zero then both are 0	

	ADD R6, R3, #0
	BRz MLOOP1	;if Max>0 but i=0 then reiterate

	NOT R2, R2	; negate i
	ADD R2, R2, #1

	AND R6, R6, #0	
	ADD R6, R1, R2	;subtract i from MAX
	BRnz GREATER 	;if negative i is greater
	BRp MLOOP1	;if positive i<MAX


GREATER	ST R5, MAXI	;store current i into max value index
	BR MLOOP1

EXIT1	LD R1, SCORES1	;output of max score
	LD R2, SCORES2	
	LD R3, SCORES3
	LD R4, MAXI
	ADD R1, R1, R4	
	ADD R2, R2, R4	
	ADD R3, R3, R4	

	LEA R0, MAXMESG
	PUTS
	LDR R0, R1, #0
	OUT
	LDR R0, R2, #0
	OUT
	LDR R0, R3, #0
	OUT	

	LEA R0, ENDL
	PUTS

	AND R7, R7, #0
	LD R7, RETADDRESS
	RET

;=================================================================================================================	

MIN	ST R7, RETADDRESS2
	AND R5, R5, #0
	AND R1, R1, #0
	ST R5, MINI		;min value index
	LD R4, HEXN30

NLOOP1  ADD R5, R5, #1	;since first value is set to be the min we can start with address offset by 1
	AND R6, R6, #0
	ADD R6, R5, #-5
	BRz EXIT2

	LD R1, SCORES1	;10^2
	AND R2, R2, #0	;set min value
	LD R2 MINI	
	ADD R1, R1, R2 	; ADDRESS OF MIN
	AND R2, R2, #0
	LDR R2, R1, #0	; load value of min

	LD R1, SCORES1	
	ADD R1, R1, R5 	; ADDRESS OF i
	LDR R3, R1, #0 	; load value of i

	ADD R2, R2, R4	; convert from ascii
	ADD R3, R3, R4	; ^^^^^^^

	ADD R6, R2, R3
	BRz NLOOP2	;if Min plus i is zero then no first number to compare	

	ADD R6, R2, #0
	BRz NLOOP1	;if (Min+i != 0) && (Min = 0) then Min is min 
	
	ADD R6, R3, #0
	BRz LESSER	;else if Min!=0 but i=0 then i is min

	NOT R3, R3	; negate i
	ADD R3, R3, #1

	AND R6, R6, #0	
	ADD R6, R2, R3	;subtract i from MIN
	BRp LESSER 	;if possitve i is lesser
	BRz NLOOP2	;if zero more testing needed 
	BRn NLOOP1	;if negative i>MIN
	
NLOOP2	LD R2, SCORES2	;10^1
	AND R1, R1, #0	;set min value
	LD R1 MINI
	ADD R2, R2, R1 	; ADDRESS OF MIN
	AND R1, R1, #0
	LDR R1, R2, #0	; load value of MIN

	LD R2, SCORES2	
	ADD R2, R2, R5 	; ADDRESS OF i
	LDR R3, R2, #0 	; load value of i

	ADD R1, R1, R4	; convert from ascii
	ADD R3, R3, R4	; ^^^^^^^

	ADD R6, R1, R3
	BRz NLOOP3	;if Min plus i is zero then no second number to compare	

	ADD R6, R1, #0
	BRz NLOOP1	;if (Min+i != 0) && (Min = 0) then Min is min 
	
	ADD R6, R3, #0
	BRz LESSER	;else if Min!=0 but i=0 then i is min

	NOT R3, R3	; negate i
	ADD R3, R3, #1

	AND R6, R6, #0	
	ADD R6, R1, R3	;subtract i from min
	BRp LESSER 	;if possitve i is lesser
	BRz NLOOP3	;if zero more testing needed 
	BRn NLOOP1	;if negative i>min	

NLOOP3	LD R3, SCORES3	;10^-1
	AND R1, R1, #0	;set min value
	LD R1 MINI
	ADD R3, R3, R1 	; ADDRESS OF min
	AND R1, R1, #0
	LDR R1, R3, #0	; load value of min

	LD R3, SCORES3	
	ADD R3, R3, R5 	; ADDRESS OF i
	LDR R2, R3, #0 	; load value of i

	ADD R1, R1, R4	; convert from ascii
	ADD R2, R2, R4	; ^^^^^^^

	ADD R6, R1, R1
	BRz LESSER	;if Min plus i is zero then both are 0	

	ADD R6, R1, #0
	BRz NLOOP1	;if (Min+i != 0) && (Min = 0) then Min is min 
	
	ADD R6, R2, #0
	BRz LESSER	;else if Min!=0 but i=0 then i is min

	NOT R2, R2	; negate i
	ADD R2, R2, #1

	AND R6, R6, #0	
	ADD R6, R1, R2	;subtract i from min
	BRzp LESSER 	;if possitve i is lesser
	BRn NLOOP1	;if negative i>min


LESSER 	ST R5, MINI	;store current i into the min value index
	BR NLOOP1

EXIT2	LD R1, SCORES1	;output
	LD R2, SCORES2	
	LD R3, SCORES3
	LD R4, MINI
	ADD R1, R1, R4	
	ADD R2, R2, R4	
	ADD R3, R3, R4	

	LEA R0, MINMESG
	PUTS
	LDR R0, R1, #0
	OUT
	LDR R0, R2, #0
	OUT
	LDR R0, R3, #0
	OUT	

	LEA R0, ENDL1
	PUTS
	
	AND R7, R7, #0
	LD R7, RETADDRESS2
	RET

;=================================================================================================================

RETADDRESS2 .FILL x6100

;=================================================================================================================

LETTER 	ST R7, RETADDRESS2
	AND R7, R7, #0

	LD R1, SCORES1	;load scores and initialze registers
	LD R2, SCORES2
	AND R3, R3, #0
	AND R6, R6, #0

GLOOP1	LDR R0, R1, #0	;diplay first two numbers of scores for confirmation
	OUT
	LDR R0, R2, #0
	OUT

	LDR R3, R1, #0	;load score from array 
	LD R4, HEXN301	;convert score from ascii to number
	ADD R3, R3, R4
	ADD R3, R3, #-1	;if the 10^2 score is 1 or greater then is is 100 or above
	BRzp GRADEA	;that is A
	BRn GLOOP2	;else check 10^1 score
	
GLOOP2	AND R3, R3, #0
	AND R4, R4, #0
	AND R5, R5, #0

	LDR R3, R2, #0	;load score from array 
	LD R4, HEXN301	;convert score from ascii to number
	ADD R3, R3, R4
	
	ADD R5, R3, #-9	;subtract exepcted letter grade values in decending order
	BRzp GRADEA
	
	ADD R5, R3, #-8
	BRzp GRADEB

	ADD R5, R3, #-7
	BRzp GRADEC
	
	ADD R5, R3, #-6
	BRzp GRADED
	
	BR GRADEF	;if 10^2 is less than 6 grade must be F

GRADEA	LEA R0, A	;Outputs
	PUTS
	LEA R0, ENDL1
	PUTS
	BR LOOPCNT

GRADEB	LEA R0, B
	PUTS
	LEA R0, ENDL1
	PUTS
	BR LOOPCNT

GRADEC	LEA R0, C
	PUTS
	LEA R0, ENDL1
	PUTS
	BR LOOPCNT

GRADED	LEA R0, D
	PUTS
	LEA R0, ENDL1
	PUTS
	BR LOOPCNT

GRADEF	LEA R0, F
	PUTs
	LEA R0, ENDL1
	PUTS
	BR LOOPCNT
	
LOOPCNT	ADD R1, R1, #1	;i++
	ADD R2, R2, #1	;i++
	ADD R6, R6, #1	;loop functionality 
	AND R5, R5, #0
	ADD R5, R6, #-5
	BRzp EXIT3
	BRn GLOOP1	

EXIT3	AND R7, R7, #0
	LD R7, RETADDRESS2
	RET

;=================================================================================================================

HEXN301 .FILL xFFD0 	;-48
HEX30 .FILL x0030 	;48

ENDL1 .STRINGZ "\n"

A .STRINGZ ": A"
B .STRINGZ ": B"
C .STRINGZ ": C"
D .STRINGZ ": D"
F .STRINGZ ": F"

;=================================================================================================================

.END