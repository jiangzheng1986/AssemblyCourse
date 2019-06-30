assume cs:codeseg

codeseg segment

	mov ax, 1
	mov bx, 2
	
	mov cx, 3
label_1:
	add ax, bx
	loop label_1

codeseg ends

end