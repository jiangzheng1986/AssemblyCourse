assume cs:codeseg

dataseg segment

var_a	dw		1234h

dataseg ends

codeseg segment

main:
	mov ds, dataseg

	mov ax, var_a

codeseg ends

end main