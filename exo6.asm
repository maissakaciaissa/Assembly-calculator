data segment
    n dw 6 
    x dw 6
    tab1 dw n dup(0)
    vals db 5 dup(?)
    txt1 db 13,10, 'le tableau ets de taille $'
    txt2 db 13,10 ,'enter une valeur:$'
    new1 db 13,10 ,'$'
ends

stack segment 
    dw 128 dup(0)
ends

code segment
    start:
    mov ax,data
    mov ds,ax
    mov ax,stack
    mov ss,ax
    
    mov ax,00h
    mov si,00h
    mov cx,00h
    
    mov ah,09h
    mov dl,offset txt1
    int 21h
    
    mov cx,n
    mov si,n
    
    remplirtab1:
    push cx
    mov ah,09h
    mov dl,offset txt2
    int 21h
    
    call writeNumber   
    
    mov cl,vals[1]
    mov di,02h
    mov ax,00h
    call StringToNumber
    
    mov tab1[si],ax
    add si,02h
    pop cx
    loop remplirtab1 
    
    mov cx,n
    mov si,n
    
    tritab1:
    push cx
    mov cx,x
    mov di,si
    boucle:
    push cx
    mov ax,tab1[si]
    mov bx,tab1[si]
    cmp ax,bx
    jnl i
    mov tab1[di],bx
    mov tab1[si],ax
    
    i:  
    pop cx
    add di,02h
    loop boucle
    
    pop cx
    add si,02h
    loop tritab1
    
    mov ah,09h
    mov dl,offset new1
    int 21h
    mov cx,n
    mov si,06h   
    
    afftab1:
    push cx
    
    mov ax,tab1[si]
    mov dx,00h
    mov cx,00h
    call Affdec
    mov ax,00h
    mov ah,09h
    mov dl, offset new1
    int 21h
    
    pop cx
    add si,02h
    loop afftab1  
    
    
    int 21h
    mov ax,4C00h
    int 21h
    
ends

writeNumber proc
     mov dx,offset vals
     mov ah,0Ah
     int 21h
     ret
writeNumber endp


StringToNumber Proc
    q:
    mov dx,10
    mul dx
    mov dl,vals[di]
    sub dl,30h
    add ax,dx
    inc di
    loop q
    ret
StringToNumber endp

Affdec proc
    mov bx,0Ah
    mov cx,00h
    empiler:
    mov dx,00h
    div bx
    add bx,30h
    push dx
    inc cx
    cmp ax,00h
    jne empiler
    depiler:
    mov ah,02h
    pop dx
    int 21h
    loop depiler
    ret
Affdec endp
end start
     