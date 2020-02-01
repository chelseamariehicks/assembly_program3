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
countMsg	BYTE	"The amount of valid numbers entered is ", 0
maxMsg		BYTE	"The maximum valid number is ", 0
minMsg		BYTE	"The minimum valid number is ", 0
sumMsg		BYTE	"The sum of the valid numbers is ", 0
avgMsg		BYTE	"The rounded average is ", 0

errMsg		BYTE	"Invalid entry! Numbers in [-88, -55] or [-40, -1] only!", 0
zeroMsg		BYTE	"No valid numbers were entered! There's nothing to see here!", 0
closing		BYTE	"Farewell my mathematical friend, ", 0

;variables for user input and loop operation
userName	BYTE	36 DUP(0)			;store the user's name
count		DWORD	0					;counter for valid numbers entered
sum			SDWORD	0					;accumulator for negative numbers entered
max			SDWORD	?					;stores maximum value entered by user
min			SDWORD	0					;stores minimum value entered by user
avg			SDWORD	?					;stores the average of the valid numbers entered

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
	cmp		eax, LOWER_LIMIT				;check integer > -88
	jl		error							;jump to error if less than
	cmp		eax, UPPER_LIMIT				;check if integer > -1
	jns		calculate						;jump if not signed, terminate getNumbers
	cmp		eax, UP_LOW_LIMIT				;check if integer > -55
	jle		valid
	cmp		eax, LOW_UP_LIMIT				;check if integer > -40
	jge		valid							;jump to valid if int > -40	
	jmp		error							;jump to error, -55 < int < -40 

valid:
	inc		count							;add one to count of valid numbers entered
	cmp		count, 1						;check if first valid num to set max and min
	je		firstNum

validStart:
	add		sum, eax						;add num to accumulator
	cmp		eax, max						;check if eax > max 
	jg		replaceMax						

validCont:
	cmp		eax, min						;check if eax < min 
	jl		replaceMin

validFin:
	jmp		getNumbers						;jump back to getNumbers 

replaceMax:									
	mov		max, eax						;replace maximum if eax > maximum
	jmp		validCont						;return to valid loop

replaceMin:
	mov		min, eax						;replace minimum if eax < minimum
	jmp		validFin						;return to end of valid loop

firstNum:									;set to max and min to first val entered
	mov		max, eax
	mov		min, eax
	jmp		validStart

error:
	mov		edx, OFFSET errMsg				;print error message
	call	WriteString
	call	Crlf
	call	Crlf
	jmp		getNumbers						;return to loop to get more numbers

;calculate and display data
calculate:
	call	Crlf
	call	Crlf
	mov		edx, 0							;compute average, divide accumulator by count
	mov		eax, sum						
	mov		ebx, count						
	cmp		ebx, 0							;check that count not equal to 0
	je		zero							;user didn't enter any numbers
	cdq										;extend sign bit of EAX into EDX
	idiv	ebx
	mov		avg, eax

display:
	mov		edx, OFFSET countMsg			;display the count
	call	WriteString
	mov		eax, count
	call	WriteInt
	mov		edx, OFFSET punc
	call	WriteString
	call	Crlf

	mov		edx, OFFSET	maxMsg				;display the maximum
	call	WriteString
	mov		eax, max
	call	WriteInt
	mov		edx, OFFSET punc
	call	WriteString
	call	Crlf

	mov		edx, OFFSET	minMsg				;display the minimum
	call	WriteString
	mov		eax, min
	call	WriteInt
	mov		edx, OFFSET punc
	call	WriteString
	call	Crlf

	mov		edx, OFFSET	sumMsg				;display the sum
	call	WriteString
	mov		eax, sum
	call	WriteInt
	mov		edx, OFFSET punc
	call	WriteString
	call	Crlf

	mov		edx, OFFSET	avgMsg				;display the average
	call	WriteString
	mov		eax, avg
	call	WriteInt
	mov		edx, OFFSET punc
	call	WriteString
	call	Crlf
	jmp		farewell						;jump to parting message

zero:
	mov		edx, OFFSET	zeroMsg				;print message if no valid num entered
	call	WriteString

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
