assume ds:dataseg
assume cs:codeseg

dataseg segment

clear_screen_attr	db	17h
					
dataseg ends

codeseg segment

main:
	mov ax, dataseg
	mov ds, ax

	mov clear_screen_attr, 17h
	call clear_screen
label_1:
	jmp label_1

;清除屏幕
clear_screen:
	push ax
	push bx
	push cx
	push es

	mov ax, 0b800h
	mov es, ax
	
	mov bx, 0
	
	mov cx, 80 * 25
	mov al, ' '
	mov ah, clear_screen_attr
clear_screen_1:
	mov es:[bx], ax
	add bx, 2
	loop clear_screen_1

	pop es
	pop cx
	pop bx
	pop ax

	ret

codeseg ends

end main