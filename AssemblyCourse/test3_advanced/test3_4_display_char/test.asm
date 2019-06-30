assume ds:dataseg
assume cs:codeseg

dataseg segment

back_buffer			dw	80*25 dup(0)

clear_screen_attr	db	17h

display_char_row	dw	0
display_char_col	dw	0
display_char_char	db	' '
display_char_attr	db	17h
					
dataseg ends

codeseg segment

main:
	mov ax, dataseg
	mov ds, ax

label_1:
	mov clear_screen_attr, 17h
	call clear_screen

	mov display_char_row, 3
	mov display_char_col, 15
	mov display_char_char, 'H'
	mov display_char_attr, 17h
	call display_char

	call swap_buffer

	jmp label_1

;交换缓冲区
swap_buffer:
	push ax
	push bx
	push cx
	push es
	
	mov ax, 0b800h
	mov es, ax
	
	mov bx, 0
	
	mov cx, 80 * 25
swap_buffer_1:
	mov ax, ds:back_buffer[bx]
	mov es:[bx], ax
	add bx, 2
	loop swap_buffer_1
	
	pop es
	pop cx
	pop bx
	pop ax
	ret

;清除屏幕
clear_screen:
	push ax
	push bx
	push cx
	
	mov bx, 0
	
	mov cx, 80 * 25
	mov al, ' '
	mov ah, clear_screen_attr
clear_screen_1:
	mov ds:back_buffer[bx], ax
	add bx, 2
	loop clear_screen_1
	
	pop cx
	pop bx
	pop ax
	ret

; 显示字符函数
display_char:
	push ax
	push bx
	push dx
	
	mov ax, display_char_row	; 行
	mov dx, 80					; 每行80字符
	mul dx
	add ax, display_char_col	; 列
	mov bx, ax
	shl bx, 1
	
	mov al, display_char_char
	mov ah, display_char_attr
	mov ds:back_buffer[bx], ax
	
	pop dx
	pop bx
	pop ax
	ret

codeseg ends

end main