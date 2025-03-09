;**********************************************;
;partie messsage
    data segment     
   result db 16 dup('?'),'b'
 
msg1 db "Veuillez saisir un nombre,SVP : $", 0Dh,0Ah
 
msg2 db 0Dh,0Ah, "Le nombre en binaire est: $"
msg3 db 0Dh,0Ah, "Le nombre en hexadecimal est : $"
msg4 db 0Dh,0Ah, "Le nombre en octal est: $"  
    ends
            
            
    mov ah,09h
    mov dl,offset msg1 
    int 21h  
    
    mov ah,09h
    mov dl,offset msg2 
    int 21h  

    
    
    
 ;***********************************************;
    conditions et appels fonctions             
    
   
 ;***********************************************;
 
 
      ;fonction: 
                   
hexatodec PROC   ;convertir d'hexa vers decimal

HEXA_INPUT:
    mov ah,1 
    int 21h
    cmp al,'0'
    jb HEXA_INPUT ; inf à 0
    cmp al ,'9'
    ja HEX ; sup à 9
    sub al ,'0' ; convertir vers une valeur 
    jmp inputdone

 HEX:
   cmp al ,'a'
   jb HEXA_INPUT
   cmp al ,'f'
   ja HEXA_INPUT
   sub al ,'a'
   add al ,10 ; convertir un caractère vers une valeur
   
 inputdone:
   mov bl,al
   shl ax ,4
   add ax,bx 
   cmp ax ,0FFFFh
   jbe HEXA_INPUT
HEX_TO_DEC:
                                                                            
START:  
    
    PRINTN " "
    PRINTN "The result is: "
    
    CALL HEX2DEC
    ;afficher le resultat par l'it 9
    LEA dx,RES
    MOV ah,9
    INT 21H 
    PRINTN " "
    PRINTN "the result is : "
    
      

HEX2DEC PROC NEAR 
    
    ;initialize the count
    MOV cx,0         
    ;initialize bx a 10 pour faire les divisons
    MOV bx,10
   
  LOOP1: MOV dx,0 ;initialiser dx a 0 ;equivalent a xor dx,dx
       ;diviser par 10 et puis faire des empilements du reste de la div
       DIV bx   
       ADD dl,30H ;on ajoute 48 pour avoir le code ASCII du chiffre
       PUSH dx 
       ;increment the count pour faire la boucle de division
       INC cx
       CMP ax,9
       JG LOOP1 ;si c'est superieur a 9 on refait la boucle  
       
       ;sinon on lui ajoute 48 et on la met dans res
       ADD al,30H
       MOV [SI],al
  ;oucle pour depiler    
  LOOP2:POP ax
        INC si
        MOV [SI],al
        LOOP LOOP2 ;decrementer cx et le comparer a 0
        RET
HEX2DEC ENDP  
RET
hexatodec ENDP  




conver_bin proc
mov dx, offset msg1
mov ah, 9
int 21h
 
 
call scan_num
 
mov bx, cx
 
call convert_to_bin
 
mov dx, offset msg2
mov ah, 9
int 21h
 
 
 
mov si, offset result
mov ah, 0eh
mov cx, 17
print_me:
mov al, [si]
int 10h
inc si
loop print_me 
; procedure de conversion au binaire.
 
 
 
 
convert_to_bin proc near
pusha
 
lea di, result
 
mov cx, 16
print: mov ah, 2
mov [di], '0'
test bx, 1000_0000_0000_0000b
jz zero
mov [di], '1'
zero: shl bx, 1
inc di
loop print
 
popa
ret
convert_to_bin endp
 
 
 
 
putc macro char
push ax
mov al, char
mov ah, 0eh
int 10h
pop ax
endm
 
 
scan_num proc near
push dx
push ax
push si
 
mov cx, 0
 
 
 
 
next_digit:
 
 
mov ah, 00h
int 16h
 
mov ah, 0eh
int 10h
 
 
 
 
 
cmp al, 13
jne not_cr
jmp stop_input
not_cr:
 
 
cmp al, 8
jne backspace_checked
mov dx, 0
mov ax, cx
div cs:ten
mov cx, ax
putc ' '
putc 8
jmp next_digit
backspace_checked:
 
 
 
cmp al, '0'
jae ok_ae_0
jmp remove_not_digit
ok_ae_0:
cmp al, '9'
jbe ok_digit
remove_not_digit:
putc 8
putc ' '
putc 8
jmp next_digit
ok_digit:
 
 
 
push ax
mov ax, cx
mul cs:ten
mov cx, ax
pop ax
 
 
 
 
 
sub al, 30h
 
 
mov ah, 0
mov dx, cx
add cx, ax
 
 
jmp next_digit
 
set_minus:
 
jmp next_digit
 
 
 
div cs:ten
mov cx, ax
putc 8
putc ' '
putc 8
jmp next_digit
 
 
stop_input:
 
 
je not_minus
neg cx
not_minus:
 
pop si
pop ax
pop dx
ret
 
ten dw 10
scan_num endp
 
 
;fin de la conversion decimal binaire.
conver_bin ENDP 


conver_hex PROC
;conversion hexadecimal
 
 
mov dx, offset msg3
mov ah, 9
int 21h
 
 
 
 
debut1: mov ax,bx
call affichHexa
int 20h    
 ;procedure de conversion au hexadecimal.
 
 
start1: jmp debut1
affich1 proc near
push ax
push dx
cmp al,10
jb w4chiffre
add al,"a"-10
 
jmp w4affiche
w4chiffre: add al,"0"
w4affiche: mov dl,al
mov ah,2
int 21h
pop dx
pop ax
ret
 
 
 
affich1 endp
 
 
 
affichHexa proc near
 
push ax
push bx
push cx
mov bx,ax
and ax,0F000h
 
mov cl,12
shr ax,cl
call affich1
mov ax,bx
 
and ax,0F00h
 
mov cl,8
shr ax,cl
call affich1
mov ax,bx
 
and ax,00F0h
 
mov cl,4
shr ax,cl
call affich1
mov ax,bx
 
and ax,000Fh
 
call affich1
pop cx
pop bx
pop ax
 
mov al, 'h'
mov ah, 0eh
int 10h
 
 
 
 
affichHexa endp
 
 
; fin de la conversion decimal hexadecimal.

conver_hex ENDP


 

SCAN_NUM        PROC    NEAR
        PUSH    DX
        PUSH    AX
        PUSH    SI
        
        MOV     CX, 0

        ; reset flag:
        MOV     CS:make_minus, 0

next_digit:

        ; get char from keyboard
        ; into AL:
        MOV     AH, 00h
        INT     16h
        ; and print it:
        MOV     AH, 0Eh
        INT     10h

        ; check for MINUS:
        CMP     AL, '-'
        JE      set_minus

        ; check for ENTER key:
        CMP     AL, 13  ; carriage return?
        JNE     not_cr
        JMP     stop_input
not_cr:


        CMP     AL, 8                   ; 'BACKSPACE' pressed?
        JNE     backspace_checked
        MOV     DX, 0                   ; remove last digit by
        MOV     AX, CX                  ; division:
        DIV     CS:ten                  ; AX = DX:AX / 10 (DX-rem).
        MOV     CX, AX
        PUTC    ' '                     ; clear position.
        PUTC    8                       ; backspace again.
        JMP     next_digit
backspace_checked:


        ; allow only digits:
        CMP     AL, '0'
        JAE     ok_AE_0
        JMP     remove_not_digit
ok_AE_0:        
        CMP     AL, '9'
        JBE     ok_digit
remove_not_digit:       
        PUTC    8       ; backspace.
        PUTC    ' '     ; clear last entered not digit.
        PUTC    8       ; backspace again.        
        JMP     next_digit ; wait for next input.       
ok_digit:


        ; multiply CX by 10 (first time the result is zero)
        PUSH    AX
        MOV     AX, CX
        MUL     CS:ten                  ; DX:AX = AX*10
        MOV     CX, AX
        POP     AX

        ; check if the number is too big
        ; (result should be 16 bits)
        CMP     DX, 0
        JNE     too_big

        ; convert from ASCII code:
        SUB     AL, 30h

        ; add AL to CX:
        MOV     AH, 0
        MOV     DX, CX      ; backup, in case the result will be too big.
        ADD     CX, AX
        JC      too_big2    ; jump if the number is too big.

        JMP     next_digit

set_minus:
        MOV     CS:make_minus, 1
        JMP     next_digit

too_big2:
        MOV     CX, DX      ; restore the backuped value before add.
        MOV     DX, 0       ; DX was zero before backup!
too_big:
        MOV     AX, CX
        DIV     CS:ten  ; reverse last DX:AX = AX*10, make AX = DX:AX / 10
        MOV     CX, AX
        PUTC    8       ; backspace.
        PUTC    ' '     ; clear last entered digit.
        PUTC    8       ; backspace again.        
        JMP     next_digit ; wait for Enter/Backspace.
        
        
stop_input:
        ; check flag:
        CMP     CS:make_minus, 0
        JE      not_minus
        NEG     CX
not_minus:

        POP     SI
        POP     AX
        POP     DX
        RET
make_minus      DB      ?       ; used as a flag.
ten             DW      10      ; used as multiplier.
SCAN_NUM        ENDP