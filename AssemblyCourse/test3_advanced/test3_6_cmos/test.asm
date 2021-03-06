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

time_year			db	0
time_month			db	0
time_day			db	0
time_hour			db	0
time_minute			db	0
time_second			db	0
					
dataseg ends

codeseg segment

main:
	mov ax, dataseg
	mov ds, ax

label_1:
	mov clear_screen_attr, 17h
	call clear_screen

	; 获取时间
	
	mov al, 9
	out 70h, al
	in al, 71h
	mov time_year, al
	
	mov al, 8
	out 70h, al
	in al, 71h
	mov time_month, al
	
	mov al, 7
	out 70h, al
	in al, 71h
	mov time_day, al
	
	mov al, 4
	out 70h, al
	in al, 71h
	mov time_hour, al
	
	mov al, 2
	out 70h, al
	in al, 71h
	mov time_minute, al
	
	mov al, 0
	out 70h, al
	in al, 71h
	mov time_second, al
	
	; 显示时间
	
	mov display_word_row, 0
	mov display_word_col, 0
	mov display_word_attr, 12h
	
	mov ah, 20h
	mov al, time_year
	mov display_word_value, ax
	call display_word
	add display_word_col, 5
	
	mov ah, time_month
	mov al, time_day
	mov display_word_value, ax
	call display_word
	add display_word_col, 5
	
	mov ah, time_hour
	mov al, time_minute
	mov display_word_value, ax
	call display_word
	add display_word_col, 5
	
	mov ah, time_second
	mov al, 0
	mov display_word_value, ax
	call display_word
	add display_word_col, 5

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

codeseg ends

end main