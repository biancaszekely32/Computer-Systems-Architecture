bits 32 ; assembling for the 32 bits architecture
; our code starts here
global _Prime

segment data public data use32
segment code public code use32

   
_Prime:
    push ebp
    mov ebp, esp
    mov eax, [esp +8] ;punem primul numar in eax
    
    cmp eax, 2 ; daca numarul e 0 sau 1 NU este prim 
    jb not_prime
    je prime ; daca numarul e 2, acesta ESTE prim
    mov ecx, eax ; salvam in ecx
    mov ebx,2 ; in ebx punem 2
    cdq
    div ebx ; impartim numarul la 2, il obtinem in eax 
    mov ebx,eax
    mov eax,ecx
    mov ecx,ebx ; eax= numar initial, ecx= jumatatea lui
    
    Loop:
        cmp ecx,1 ; daca am ajuns la 1 numarul ESTE prim
        je prime
        mov ebx,eax ; salvam eax in ebx
        cdq
        div ecx ; impartim edx:eax cu numarul curent
        test edx, edx ; verificam daca edx este 0 sau nu 
        jz not_prime ; daca este 0 numarul NU este prim
        mov eax,ebx ; eax= numarul initial
        loop Loop
    
    not_prime:
        mov eax, -1 ; daca nu e prim, schimbam valuarea cu -1
        mov esp,ebp
        pop ebp
        ret  
    
    prime:
        mov esp, ebp
        pop ebp
        ret 