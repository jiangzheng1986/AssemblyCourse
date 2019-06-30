assume cs:codeseg

codeseg segment

label_1:
	mov ax, 1
	mov bx, 2
	add ax, bx
	jmp label_1

codeseg ends

end