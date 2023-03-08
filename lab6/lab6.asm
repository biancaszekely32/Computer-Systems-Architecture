;19.Being given two strings of bytes, compute all positions where the second string appears as a substring in the first string.
bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    ; ...
    s1 db 45,21,7,13,67,9,3,21, 7, 13,89
    s2 db 21, 7, 13
    l1 equ $-s1
    l2 equ $-s2
    d times l1 db 0
    
    ;2,3,4
    ;8,9,A
; our code starts here
segment code use32 class=code
    start:
        ; ...
    mov esi,s1 
    mov ecx,l1-l2 ; in ecx we put the length of s1 
    mov ebx, 0
    mov edi, 0
    repeta:
       lodsb ;in al we will have the first number from s1 (the byte from the adress <ds:esi>)
       Search:
            mov dl, [s2+edi] ; in dl we put the elements from s2
            cmp al, dl  ; we compare the elements from s2 with the elements from s1
            je Found
            cmp edi, l2
            je No ; if we went through the whole string s2 and we did not find the element from s1 in the substring s2 we jump to No 
            inc edi
            inc ecx
        loop Search
        Found:
            inc edi
          mov [d+ebx], si ; we add the positions where s2 appears in s1 
          mov edi, 0
          inc ebx
        No:
          mov edi, 0
        
    loop repeta
    
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
