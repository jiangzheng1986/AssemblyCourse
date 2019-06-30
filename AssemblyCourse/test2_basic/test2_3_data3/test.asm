assume cs:codeseg

codeseg segment

var_a	dw		1234h

main:
	mov ax, var_a

codeseg ends

end main