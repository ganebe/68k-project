*-----------------------------------------------------------
* Title      : Dissambler store addresses function
* Written by : Aisha M
* Description:  function to store input from user 
* Store starting address at A5, and ending adress at A6
*-----------------------------------------------------------
      
START:  ORG     $1000 
; Code
    BRA STARTADDR
    
ENDADDR:    
    ;prompt user
    MOVE    #1,D6       ; keeps track if storing start/end
    LEA     prompt2,A1
    MOVE.B  #14,D0
    TRAP    #15
    BRA     FORMAT

STARTADDR:
    ;prompt user
    LEA     prompt1,A1
    MOVE.B  #14,D0
    TRAP    #15

FORMAT:    
    ;let user know format
    LEA     examp,A1
    MOVE.B  #14,D0
    TRAP    #15
   
    MOVE.L  #0, D2        ; Initialize subtotal   
    MOVE.L  #7, D3        ; Number of digits
    ; DBRA stops when it becomes -1, so made 8 to 7 to fix
        
LOOP1:
    ;shfit num
    ASL.L   #4,D2
    
    ; read input
    MOVE.B  #5, D0
    TRAP    #15
    
    ; Convert ASCII char to num (-'0')
    CMP.B   #58,D1  ; if greater than 0, then it's A-F
    BLT     ISDIGIT
    SUB.B   #7,D1   ; subtract 'A' - '9'
    
ISDIGIT:
    SUB.B   #48,D1      ; 0 - 9
    
    ADD.B   D1,D2       ; Temp to subtotal     
    DBRA    D3,LOOP1    ; Repeat until end of memory block
        
DONE:
    CMP     #1,D6
    BEQ     DONE2            ;check if storing start/end
    MOVE.L  D2,A5            ;store starting add at A5
DONE2:
    MOVE.L  D2,A6            ;store ending add at A6    
    CMP     #1,D6
    BNE     ENDADDR          ;check if we did end yet
    
    
    ; Call computing subroutine [MERGE CODE]
    ; Call output subroutine [MERGE CODE]
 
AGAIN:   
    ; Ask user if loop again:
    LEA     repeat,A1
    MOVE.B  #14,D0
    TRAP    #15
    
    ; Read user's response
    MOVE.B  #5, D0
    TRAP    #15
    
    ; Check user's response
    MOVE    #0,D6     ; Reset ending adress to not set
    CMP.B   #89, D1   ; 'Y' - ASCII value 89
    BEQ     START     ; Branch if equal (user wants to loop)
    CMP.B   #121, D1   ; 'y' - ASCII value 121
    BEQ     START     ; Branch if equal (user wants to loop)

    CMP.B   #78, D1   ; 'N' - ASCII value 
    BNE     AGAIN     ; Branch to re ask if typo

    SIMHALT           

; Output   
CR       EQU     $0D
LF       EQU     $0A
prompt1  DC.B CR,LF,'Enter starting adress in hexadecimal: ',CR,LF,0
prompt2  DC.B CR,LF,'Enter ending adress in hexadecimal: ',CR,LF,0
examp    DC.B 'Input should be 8 digits. Put leading 0s on left if needed. ',CR,LF,0
repeat   DC.B CR,LF,'Do you want to loop again? (Y/N): ',CR,LF,0

    END    START        

