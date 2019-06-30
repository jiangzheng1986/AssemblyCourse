assume cs:codeseg

codeseg segment

main:
	mov ax, 0b800h
	mov es, ax
	
	mov bx, 0
	
	mov cx, 80 * 25
	mov al, ' '
	mov ah, 17h
label_1:
	mov es:[bx], ax
	add bx, 2
	loop label_1

label_2:
	jmp label_2

codeseg ends

end main