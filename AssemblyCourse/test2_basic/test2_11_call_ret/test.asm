assume cs:codeseg

codeseg segment

func:
	ret

main:
	call func

label_1:
	jmp label_1


codeseg ends

end main