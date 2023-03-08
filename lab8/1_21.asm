bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit, printf, scanf            
import exit msvcrt.dll     
import printf msvcrt.dll     ; indicating to the assembler that the printf fct can be found in the msvcrt.dll library
import scanf msvcrt.dll 

;21.Read two words a and b in base 10 from the keyboard. 
;Determine the doubleword c such that the low word of c is given by the sum of the a and b 
;and the high word of c is given by the difference between a and b. Display the result in base 16 
;Example:
;   a = 574, b = 136
;   c = 01B602C6h

; our data is declared here (the variables needed by our program)
segment  data use32 class=data
	a dw 0       ; rezervam un spatiu de un word pt a, pe care il initializam cu 0
    b dw 0       ; rezervam un spatiu de un word pt b, pe care il initializam cu 0
    c dd 0       ; rezervam un spatiu de un doubleword pt c, pe care il initializam cu 0
    message db "c=%xh",0
    format  db "%d", 0  ; %d <=> a decimal number (base 10)


    
segment  code use32 class=code
    start:
                                               
        ; calling scanf(format, n) => we read the number and store it in the variable n
        ; push parameters on the stack from right to left
        push  dword a       ; adresa lui a, nu valoarea
        push  dword format  ; formatul in care vrem sa citim valoarea
        call  [scanf]       ; call scanf pentru citire
        add  esp, 4 * 2     ; eliberam stackul de valorile introduse
        
        push  dword b       ; adresa lui b, nu valoarea
        push  dword format  ; formatul in care vrem sa citim valoarea
        call  [scanf]       ; call scanf pentru citire
        add  esp, 4 * 2     ; eliberam stackul de valorile introduse
        mov eax, [a]        ; punem in eax un dword de la adresa lui a, adica exact valoarea lui a
        add eax, [b]        ; adaugam in eax un dword de la adresa lui b, adica exact valoarea lui b
        ; in eax=sum(a si b)
        
        mov [c], eax;the sum of the a and b is in the low word of c

        mov ebx, [a]        ; punem in ebx un dword de la adresa lui a, adica exact valoarea lui a
        sbb ebx, [b]        ; adaugam in ebx un dword de la adresa lui b, adica exact valoarea lui b
        ; in ebx=dif(a si b)
        
        mov [c+2], bx;the dif of the a and b is in the high word of c
        
        push  dword [a]
        push  dword [b]
        push  dword [c]
        push  dword message ; push parameters on the stack from right to left
        call  [printf]      ; call printf pentru afisare
        add  esp,4*4     ; eliberam stackul de valorile introduse
        
        ; exit(0)
        push  dword 0       ; push the parameter for exit on the stack
        call  [exit] 