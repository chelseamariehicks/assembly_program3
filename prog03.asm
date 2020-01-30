TITLE Programming Assignment #3     (prog03.asm)

; Author: Chelsea Marie Hicks
; OSU email address: hicksche@oregonstate.edu
; Course number/section: C271-400
; Project Number: Program #3          Due Date: Sunday, February 9 by 11:59 PM
;
; Description: Program repeatedly prompts user to enter a number within the
;		specified ranges of [-88, -55] or [-40, -1] (inclusive) and counts and
;		accumulates the validated user numbers until a non-negative number
;		is entered, which is detected via the SIGN flag. Program calculates
;		and displays data including: 
;				-the number of validated numbers entered 
;				-the sum of negative numbers entered
;				-the maximum valid value entered
;				-the minimum valid value entered
;				-the rounded integer average of the valid numbers entered		

INCLUDE Irvine32.inc

;definitions of constants
LOWER_LIMIT		EQU	-88					;defines the lower limit as constant = -88
UP_LOW_LIMIT	EQU -55					;defines the upper limit of the low range = -55
LOW_UP_LIMIT	EQU -40					;defines the lower limit of upper range = -40
UPPER_LIMIT		EQU	-1					;defines upper limit as constant = -1

.data

;messages printed to screen throughout program
progTitle	BYTE	"Integer Accumulator", 0
authName	BYTE	"Written by Chelsea Marie Hicks", 0
greeting1	BYTE	"Welcome! What is your name? ", 0
greeting2	BYTE	"It is a pleasure to meet you, ", 0
instruc1	BYTE	"Please enter numbers in [-88, -55] or [-40, -1].", 0
instruc2	BYTE	"Enter a non-negative number when you are finished "
			BYTE	"to see the results of the Integer Accumulator!", 0
numPrompt	BYTE	"Enter a number: ", 0
errMsg		BYTE	"Invalid entry! Numbers in [-88, -55] or [-40, -1] only!", 0
closing		BYTE	"Farewell my mathematical friend, ", 0

;variables for user input and loop operation
userName	BYTE	36 DUP(0)			;store the user's name
count		DWORD	0					;counter for valid numbers entered
accum		SDWORD	0					;accumulator for negative numbers entered
max			SDWORD	0					;stores maximum value entered by user
min			SDWORD	0					;stores minimum value entered by user
avg			SDWORD	0					;stores the average of the valid numbers entered

;useful components
punc		BYTE	".", 0

.code
main PROC

;display introduction
introduction:
	mov		edx, OFFSET progTitle				;print title and programmer name
	call	WriteString
	call	Crlf
	mov		edx, OFFSET authName
	call	WriteString
	call	Crlf
	call	Crlf

;acquire user's name and greet the user
	mov		edx, OFFSET greeting1				;get the user's name
	call	WriteString
	mov		edx, OFFSET userName
	mov		ecx, SIZEOF userName
	call	ReadString

	mov		edx, OFFSET greeting2				;greet the user
	call	WriteString
	mov		edx, OFFSET userName
	call	WriteString
	mov		edx, OFFSET punc
	call	WriteString
	call	Crlf
	call	Crlf

;print instructions for the user
instructions:
	mov		edx, OFFSET instruc1				;print instructions for the user
	call	WriteString
	call	Crlf
	mov		edx, OFFSET instruc2
	call	WriteString
	call    Crlf
	call	Crlf

;repeatedly prompt user to enter numbers
getNumbers:
	mov		edx, OFFSET numPrompt
	call	WriteString
	call	ReadInt
	cmp		eax, LOWER_LIMIT				;check integer < -88
	jl		error							;jump to error if less than
	cmp		eax, UPPER_LIMIT				;check if integer > -1
	jns		calculate						;jump if not signed to calculations
	cmp		eax, UP_LOW_LIMIT				;check if integer > -55
	jle		valid

valid:
	inc		count							;add one to count of valid numbers entered
	;add what's in eax to accumulator variable (mov accumulator, eax)
	;compare what is in maximum to eax, replace if eax > maximum
	;compare what is in minimum to eax, replace if eax < minimum
	jmp		getNumbers						;jump back to getNumbers 


error:
	mov		edx, OFFSET errMsg				;print error message
	call	WriteString
	call	Crlf
	jmp		getNumbers						;return to loop to get more numbers

;calculate and display data
calculate:
	;compute average, divide accumulator by count
	;display count, sum/accumulator, max, min
	;add messages ie maxMsg, minMsg to messages section

;bid the user adieu
farewell:
	call	Crlf
	call	Crlf
	mov		edx, OFFSET closing				;print closing message
	call	WriteString
	mov		edx, OFFSET userName
	call	WriteString
	mov		edx, OFFSET punc
	call	WriteString
	call	Crlf

	exit	; exit to operating system
main ENDP

; (insert additional procedures here)

END main
