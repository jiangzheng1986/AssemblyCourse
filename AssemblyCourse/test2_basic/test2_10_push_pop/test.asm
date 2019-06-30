assume cs:codeseg

codeseg segment

main:
	mov ax, 1234h
	push ax
	mov ax, 5678h
	pop ax

codeseg ends

end main