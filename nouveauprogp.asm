;**********************************************;
;partie messsage :;
    data segment     
   result db 16 dup('?'),'b'   
 msg db"       "
 
msg1 db "Veuillez saisir un nombre,SVP : $", 0Dh,0Ah
 
msg2 db 0Dh,0Ah, "Le nombre en binaire est: $"
msg3 db 0Dh,0Ah, "Le nombre en hexadecimal est : $"
msg4 db 0Dh,0Ah, "Veuillez saisir la base    :
                   1:decimal
                   2:binaire
                   3:hexa
                   
$" 
msg5 db 0Dh,0Ah, "Veuillez saisir l'operande    :
                   4:+
                   5:-
                   6:*
                   7:/
$"

msg6:    db      0dh,0ah,"Enter First No : $"
msg7:    db      0dh,0ah,"Enter Second No : $"
msg8:    db      0dh,0ah,"Choice Error $" 
msg9:    db      0dh,0ah,"Result : $" 
    
    
    
 ;***********************************************;
    ;conditions et appels fonctions:;  
    
    
      
    here:  
    mov ah,9
    mov dx, offset msg1 ;first we will display hte first message from which he can choose the operation using int 21h
    int 21h
    mov ah,0                       
    int 16h  ;then we will use int 16h to read a key press, to know the operation he choosed
    cmp al,31h ;the keypress will be stored in al so, we will comapre to 1 addition ..........
    je call Addition_decimal
    cmp al,32h
    je Multiply
    cmp al,33h
    je Subtract_decimal
    cmp al,34h
    je Divide_decimal
    mov ah,09h
    mov dx, offset msg8
    int 21h
    mov ah,0
    int 16h
    jmp here
        
    la_base:  
    
    mov cx,offset msg4 
    
    decimal:
    mov bl,1
    je operande
    call conver_bin 
     
    binaire:
    mov bl,2 
    je operande
    jne hexa
    ;call bintodec  
    
     hexa:
    mov bl,3 
    je operande
    jne decimal
    call hexatodec 
    
    jmp la_base
    
    operande: 
        
    mov cx,offset msg5  
    
    addition:
     
    mov bl,4    
    jne substraction   
    
    
    substraction:
    
    mov bl,5    
    jne multiplication  
    
    
    multiplication:
    
    mov bl,6    
    jne division 
    division:
    
     
    mov bl,7   
    jne addition
    
    
   
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



Input_NO PROC
 
InputNo:    mov ah,0
            int 16h ;then we will use int 16h to read a key press     
            mov dx,0  
            mov bx,1 
            cmp al,0dh ;the keypress will be stored in al so, we will comapre to  0d which represent the enter key, to know wheter he finished entering the number or not 
            je FormNo ;if it's the enter key then this mean we already have our number stored in the stack, so we will return it back using FormNo
            sub ax,30h ;we will subtract 30 from the the value of ax to convert the value of key press from ascii to decimal
            call View_No ;then call ViewNo to view the key we pressed on the screen
            mov ah,0 ;we will mov 0 to ah before we push ax to the stack bec we only need the value in al
            push ax  ;push the contents of ax to the stack
            inc cx   ;we will add 1 to cx as this represent the counter for the number of digit
            jmp InputNo ;then we will jump back to input number to either take another number or press enter          
 
Input_NO ENDP
     ret
Form_No proc

;we took each number separatly so we need to form our number and store in one bit for example if our number 235
FormNo:     pop ax  
            push dx      
            mul bx
            pop dx
            add dx,ax
            mov ax,bx       
            mov bx,10
            push dx
            mul bx
            pop dx
            mov bx,ax
            dec cx
            cmp cx,0
            jne Form_No
            ret   

Form_No ENDP
       
VIEW PROC       
Vie:  mov ax,dx
       mov dx,0
       div cx 
       call View_No
       mov bx,dx 
       mov dx,0
       mov ax,cx 
       mov cx,10
       div cx
       mov dx,bx 
       mov cx,ax
       cmp ax,0
       jne Vie
       ret

VIEW endp

View_No proc
    
ViewNo:    push ax ;we will push ax and dx to the stack because we will change there values while viewing then we will pop them back from
           push dx ;the stack we will do these so, we don't affect their contents
           mov dx,ax ;we will mov the value to dx as interrupt 21h expect that the output is stored in it
           add dl,30h ;add 30 to its value to convert it back to ascii
           mov ah,2
           int 21h
           pop dx  
           pop ax
           ret
      
View_No ENDP

EXIT PROC
exi:   mov dx,offset msg6
        mov ah, 09h
        int 21h  


        mov ah, 0
        int 16h

        ret
        
EXIT ENDP       


Addition_decimal Proc
Addition:   mov ah,09h  ;then let us handle the case of addition operation
            mov dx, offset msg2  ;first we will display this message enter first no also using int 21h
            int 21h
            mov cx,0 ;we will call InputNo to handle our input as we will take each number seprately
            call InputNo  ;first we will move to cx 0 because we will increment on it later in InputNo
            push dx
            mov ah,9
            mov dx, offset msg3
            int 21h 
            mov cx,0
            call Input_No
            pop bx
            add dx,bx
            push dx 
            mov ah,9
            mov dx, offset msg5
            int 21h
            mov cx,10000
            pop dx
            call VIEW
            jmp exi
Addition_decimal ENDP 


Multiply_decimal Proc
Multiply:   mov ah,09h
            mov dx, offset msg2
            int 21h
            mov cx,0
            call Input_No
            push dx
            mov ah,9
            mov dx, offset msg3
            int 21h 
            mov cx,0
            call Input_No
            pop bx
            mov ax,dx
            mul bx 
            mov dx,ax
            push dx 
            mov ah,9
            mov dx, offset msg5
            int 21h
            mov cx,10000
            pop dx
            call Vie
            jmp exi
Multiply_decimal ENDP 


Subtract_decimal PROC
Subtract:   mov ah,09h
            mov dx, offset msg2
            int 21h
            mov cx,0
            call Input_No
            push dx
            mov ah,9
            mov dx, offset msg3
            int 21h 
            mov cx,0
            call Input_No
            pop bx
            sub bx,dx
            mov dx,bx
            push dx 
            mov ah,9
            mov dx, offset msg5
            int 21h
            mov cx,10000
            pop dx
            call Vie 
            jmp exi 
    
Subtract_dcimal ENDP

Divide_deciaml PROC
Divide:     mov ah,09h
            mov dx, offset msg2
            int 21h
            mov cx,0
            call Input_No
            push dx
            mov ah,9
            mov dx, offset msg3
            int 21h 
            mov cx,0
            call Input_No
            pop bx
            mov ax,bx
            mov cx,dx
            mov dx,0
            mov bx,0
            div cx
            mov bx,dx
            mov dx,ax
            push bx 
            push dx 
            mov ah,9
            mov dx, offset msg5
            int 21h
            mov cx,10000
            pop dx
            call Vie
            pop bx
            cmp bx,0
            je exi 
            jmp exi 
Divide_decimal ENDP