assume cs:codeseg

dataseg segment

var_a	dw		1234h

dataseg ends

codeseg segment

main:
	mov ax, dataseg
	mov ds, ax

	mov ax, var_a

codeseg ends

end main