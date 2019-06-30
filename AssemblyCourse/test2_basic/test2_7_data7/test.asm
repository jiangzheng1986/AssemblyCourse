assume cs:codeseg

dataseg segment

var_a	dw		1234h

dataseg ends

codeseg segment

main:
	mov ax, dataseg
	mov ds, ax

	mov bx, offset var_a
	mov ax, [bx]

codeseg ends

end main