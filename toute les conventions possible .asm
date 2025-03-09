
                   
                    ;Projet TP Architecture D'ordinateur 02
                    

;Un programme assembleur qui convertit une valeur d'une base Decimal  a une base Binaire, Hexadecimal et Octal.



;Le travail est fait en binome:

;Nom et Prenom d'etudiant numero 01: SLIMANI ABDELLAH RAYAN/Matricule:202031076001/ACAD C G04 


;Nom et Prenom d'etudiant numero 02: MECHIDAL MONCIF ABDELALI/Matricule:202031075774/ACAD C G03



                              ;Le debut du programme

org 100h
 
jmp debut
 
 
result db 16 dup('?'),'b'
 
msg1 db "Veuillez saisir un nombre,SVP : $", 0Dh,0Ah
 
msg2 db 0Dh,0Ah, "Le nombre en binaire est: $"
msg3 db 0Dh,0Ah, "Le nombre en hexadecimal est : $"
msg4 db 0Dh,0Ah, "Le nombre en octal est: $"
 
debut:
 
 
;conversion binaire.
 
 
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
 
 
 
 
;conversion hexadecimal
 
 
mov dx, offset msg3
mov ah, 9
int 21h
 
 
 
 
debut1: mov ax,bx
call affichHexa
int 20h
 
 
 
 
;conversion octal.
 
 
 
 
 
debut2: mov dx, offset msg4
mov ah, 9
int 21h
 
mov ax,bx
call affichOcta
int 20h
 
 
 
 
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
 
 
 
; conversion de nombre au octal.
 
 
start2: jmp debut2
 
 
affich2 proc near
 
push ax
push dx
 
 
add al,"0"
mov dl,al
mov ah,2
int 21h
pop dx
pop ax
 
ret
 
 
 
 
affich2 endp
 
 
affichOcta proc near
 
push ax
push bx
push cx
 
mov bx,ax
and ax,8000h
mov cl,15
shr ax,cl
call affich2
 
mov ax,bx
and ax,7000h
mov cl,12
shr ax,cl
call affich2
 
mov ax,bx
and ax,0E00h
mov cl,9
shr ax,cl
call affich2
 
mov ax,bx
and ax,01C0h
mov cl,6
shr ax,cl
call affich2
 
mov ax,bx
and ax,0038h
mov cl,3
shr ax,cl
call affich2
 
mov ax,bx
and ax,0007h
call affich2
 
pop cx
pop bx
pop ax
 
 
;attent de sorti ou dos
 
mov al, 'o'
mov ah, 0eh
int 10h
 
mov ah, 0
int 16h
 
 
ret
 
affichOcta endp
 
;fin de la procedure de conversion en octal.
 
                                     ;La fin du programme



