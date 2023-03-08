bits 32 ; assembling for the 32 bits architecture

; declare the EntryPoint (a label defining the very first instruction of the program)
global start        

; declare external functions needed by our program
extern exit               ; tell nasm that exit exists even if we won't be defining it
import exit msvcrt.dll    ; exit is a function that ends the calling process. It is defined in msvcrt.dll
                          ; msvcrt.dll contains exit, printf and all the other important C-runtime specific functions

; our data is declared here (the variables needed by our program)
segment data use32 class=data
  ;2)
    ; a db 4
    ; b db 3
    ; c db 9 
    ; d db 10
  ;3)
    ; a dw 10
    ; b dw 64
    ; c dw 20 
    ; d dw 5
  ;4)
    ; a db 12
    ; b db 70
    ; c db 4
    ; d dw 256
  
  ;5)
    a db 20
    b db 30
    c db 10
    d db 8
    e dw 112 
    f dw 50
    g dw 256
    h dw 270

; our code starts here
segment code use32 class=code
    start:
      ; 1)64*4
        ;mov ax, 64
        ;mov bx, 4
        ;mul bx
        
      ;2)a,b,c,d - byte
      ;  (c+d+d)-(a+a+b)= (9+10+10)-(4+4+3)=29-11= 18= 12h
        ; mov ax,0
        ; mov al, [c]
        ; add al, [d]
        ; add al, [d]
        
        ; mov bl,[a]
        ; add bl,[a]
        ; add bl,[b]
        
        ; sub al,bl 
        
      ;3)a,b,c,d - word
      ;(a+b-c)-d = (10+64-20)-5= 54- 5= 49=31h
        ; mov ax,[a]
        ; add ax,[b]
        ; sub ax,[c]
        ; sub ax,[d]
        
      ;4)a,b,c - byte, d - word
      ;[100-10*a+4*(b+c)]-d=[100-10*12+4*(70+4)]-256= [100-120+296]-256=20=14h
        ; mov ax,0
        ; mov al, [a]
        ; mov bl, 10
        ; mul bl ; 10*a
      
        ; mov bx, ax
        ; mov ax,0
        ; mov al,[b]
        ; add al,[c]
        ; mov dl,4
        ; mul dl  ; 4*(b+c)
      
        ; mov cx, 100
        ; sub cx,bx ; 100-10*a
        ; add cx,ax ; 100-10*a+4*(b+c)
        ; sub cx, [d]; [100-10*a+4*(b+c)]-d
      
        ; mov ax,0
        ; mov ax,cx ; result in ax
     
      
      ;5)a,b,c,d-byte, e,f,g,h-word
      ;(e+f+g)/(a+b)=(112+50+256)/(20+30)=8 r=18=12h
        mov ax,0
        mov ax,[e]
        add ax,[f]
        add ax,[g]
        
        mov bx,0
        mov bl,[a]
        add bl,[b]
        
        div bl ; al=8,ah=18=12h
      
        
        ; exit(0)
        push    dword 0      ; push the parameter for exit onto the stack
        call    [exit]       ; call exit to terminate the program
