bits 32
global concatenate_string
extern concat_string_final
segment data use32 class=data
    
segment code use32 class=code
    concatenate_string:
        mov esi, [esp + 4] ;punem primul sir in esi
        mov ecx, 0
        
        while_byte_esi_differ_from_0:
        
            mov dl, byte [esi + ecx];parcurgem sirul litera cu litera
            cmp dl, 0; daca ajungem la 0 atunci am parcurs tot sirul
            je fin_of_while
            
            mov byte [concat_string_final + ebx], dl; construim in concat_string_final sirul concatenat
                                                    ; punem litera cu litera, pozitie pe pozitie
            inc ecx; verificam urmatoarea litera
            inc ebx; mutam pe urmatoarea pozitie in concat_string_final
            jmp while_byte_esi_differ_from_0
            
        fin_of_while:  
        ret