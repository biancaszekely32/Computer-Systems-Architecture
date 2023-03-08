bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
    ;1)
    ; a db 2
    ; b dw 5A3h;=1443
    ; c dd 0AD42Fh;=709,679
    ; d dq 1F784Ah;=2,062,410
    
    ;2)
    ; a db 12h;=18
    ;b dw 5A3h;=1443
    ;c dd 0AD42Fh;=709,679
    ;d dq 1F784Ah;=2,062,410
    ;3)
    a db 43h
    b dw 100h
    c dd 112233h
    x dq 887766554433h
    a1 db 03h
    
    ;4)

; our code starts here
segment code use32 class=code
    start:
        ;1)a - byte, b - word, c - double word, d - qword - Unsigned representation
        ;(a+d)-(c-b)+c
        ; mov eax, dword [d+0]
        ; mov edx, dword [d+4]
        ; clc 
        ; add al, [a]
        ; adc ah, 0; edx:eax= 00000000:1F784Ch
                 ; ; a+d
        
        ; mov ebx, [c]
        ; mov edx, 0
        ; mov dx,[b]
        ; sub ebx,edx; c-b=0ACE8Ch
        ; mov edx,0
        ; mov ecx,0
        
        ; clc
        ; sub eax,ebx
        ; sub edx,ecx; edx:eax= 14A9C0h
        
        ; add eax, [c]; edx:eax= 1F7DEFh
        
        ;2)a - byte, b - word, c - double word, d - qword - Signed representation
        ;c-b-(a+a)-b
        ; mov ebx, [c]
        ; mov ax, [b]
        ; cwde
        ; sub ebx,eax; ebx= c-b=0ACE8Ch
        
        ; mov ecx,ebx
        ; ;mov eax,0
        ; mov al, [a]
        ; add al, [a]; al=a+a=24h
        ; cbw
        ; cwde
        
        ; sub ecx,eax; ecx= c-b-(a+a)=0ACE68h
        ; sub cx, [b]; ecx=c-b-(a+a)-b=0AC8C5h
       
        
        ;3)x+(2-a*b)/(a*3)-a+c; a-byte; b-word; c-doubleword; x-qword
        ;unsigned
        
        mov al, [a]
        mov ah,0
        mov bx,[b]
        mul bx; dx:ax=a*b=4300h
        
        push dx
        push ax
        pop eax;
        
        mov ebx, 2
        sub ebx,eax;ebx=2-a*b=BD02h
        
        mov al,[a]
        mov cl,[a1]
        mul cl; dx:ax=a*3=C9h
        
        push dx
        push ax
        pop eax;
        
        mov ecx, eax; cx=ax=a*3=C9h=201
        mov eax,ebx; ax=bx=2-a*b=BD02h=48,386
        mov edx,0
        div ecx; (2-a*b)/(a*3)=
              ; eax= F000h, edx= 9200h
             ;EAX ← EDX:EAX / EBX, EDX ← EDX:EAX % EBX

        
        sub eax, dword[a]; al=(2-a*b)/(a*3)-a= 9200ADh
        sbb edx, dword[a]
        add eax, [c]; eax=(2-a*b)/(a*3)-a+c= 0A322E0h
        
        mov ebx, eax
        mov ecx,0; ecx:ebx= (2-a*b)/(a*3)-a+c=0A322E0h
        
        mov eax, dword [x]
        mov edx, dword [x + 4]
        add eax,ebx 
        adc edx,ecx ; edx:eax=x+(2-a*b)/(a*3)-a+c= 
                        ; eax= 66F86713h 
                        ;edx=8877h
        
        ;4)x+(2-a*b)/(a*3)-a+c; a-byte; b-word; c-doubleword; x-qword
        ;signed
        mov al, [a]
        imul word[b]; ax=a*b=4300h
        
        mov bx, 2
        sub bx,ax;bx=2-a*b=BD02h
        
        mov al,[a]
        imul byte[a1]; ax=a*3=C9h
        
        mov cx, ax; cx=ax=a*3=C9h
        mov ax,bx; ax=bx=2-a*b=BD02h
        cwde
        idiv word cx; (2-a*b)/(a*3)=
               ; ax= FFABh, dx= FFBFh
        
        push dx
        push ax
        pop eax ; eax=FFBFFFAB
        
        sub al, [a]; al=(2-a*b)/(a*3)-a= FFBF FF68h
        add eax, [c]; eax=(2-a*b)/(a*3)-a+c= FFD1 219Bh
        cdq; edx:eax=FFFFFFFF FFD1219Bh
        
        add eax, dword [x]
        adc edx,dword [x+4];edx:eax=x+(2-a*b)/(a*3)-a+c
                           ; eax=6626 65CEh edx=  cf=1
        
        
        
    
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
