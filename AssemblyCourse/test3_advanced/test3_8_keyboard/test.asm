assume ds:dataseg
assume cs:codeseg

dataseg segment

back_buffer			dw	80*25 dup(0)

clear_screen_attr	db	17h

display_char_row	dw	0
display_char_col	dw	0
display_char_char	db	' '
display_char_attr	db	17h

display_word_row	dw	0
display_word_col	dw	0
display_word_value	dw	0
display_word_attr	db	17h

hex_table			db	'0', '1', '2', '3', '4', '5', '6', '7'
					db	'8', '9', 'A', 'B', 'C', 'D', 'E', 'F'

saved_key_int_ip	dw	0
saved_key_int_cs	dw	0

current_row			dw	13
current_col			dw	40
					
dataseg ends

codeseg segment

main:
	mov ax, dataseg
	mov ds, ax

	; 设置键盘中断处理程序
	call setup_keyboard_interrupt

label_1:
	mov clear_screen_attr, 17h
	call clear_screen

	; 绘制主角
	
	mov ax, current_row
	mov display_char_row, ax
	mov ax, current_col
	mov display_char_col, ax
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

; 十六进制显示字
display_word:
	push ax
	push bx
	push cx
	push dx

	mov ax, display_word_row
	mov display_char_row, ax
	
	mov ax, display_word_col
	mov display_char_col, ax
	
	mov al, display_word_attr
	mov display_char_attr, al
	
	mov ax, display_word_value
	
	mov bh, 0
	mov bl, ah
	mov cl, 4
	shr bl, cl
	mov dl, hex_table[bx]
	mov display_char_char, dl
	call display_char	
	inc display_char_col
	
	mov bh, 0
	mov bl, ah
	and bl, 0fh
	mov dl, hex_table[bx]
	mov display_char_char, dl
	call display_char
	inc display_char_col
	
	mov bh, 0
	mov bl, al
	mov cl, 4
	shr bl, cl
	mov dl, hex_table[bx]
	mov display_char_char, dl
	call display_char	
	inc display_char_col
	
	mov bh, 0
	mov bl, al
	and bl, 0fh
	mov dl, hex_table[bx]
	mov display_char_char, dl
	call display_char
	inc display_char_col
	
	pop dx
	pop cx
	pop bx
	pop ax
	
	ret

; 键盘中断处理程序
keyboard_interrupt:
	push ax
	push bx
	push ds
	
	; ds指向数据段
	
	mov ax, dataseg
	mov ds, ax
	
	; 读入键盘数据
	
	in al, 60h
	cmp al, 4dh
	jne keyboard_interrupt_2
	cmp current_col, 80 - 1
	jge keyboard_interrupt_2
	inc current_col
keyboard_interrupt_2:
	cmp al, 4bh
	jne keyboard_interrupt_3
	cmp current_col, 0
	jle keyboard_interrupt_3
	dec current_col
keyboard_interrupt_3:
	cmp al, 48h
	jne keyboard_interrupt_4
	cmp current_row, 0
	jle keyboard_interrupt_4
	dec current_row
keyboard_interrupt_4:
	cmp al, 50h
	jne keyboard_interrupt_5
	cmp current_row, 25 - 1
	jge keyboard_interrupt_5
	inc current_row
keyboard_interrupt_5:

	; 调用之前的键盘中断处理程序
	
	mov bx, offset saved_key_int_ip
	pushf
	call dword ptr ds:[bx]

	pop ds
	pop bx
	pop ax
	iret
	
; 设置键盘中断处理程序
setup_keyboard_interrupt:
	push ax
	push bx
	push es
	
	mov ax, 0
	mov es, ax
	
	mov bx, 9 * 4
	
	mov ax, es:[bx]
	mov saved_key_int_ip, ax
	mov ax, es:[bx + 2]
	mov saved_key_int_cs, ax
	
	mov ax, offset keyboard_interrupt
	mov es:[bx], ax
	mov ax, codeseg
	mov es:[bx + 2], ax
	
	pop es
	pop bx
	pop ax
	
	ret

codeseg ends

end main