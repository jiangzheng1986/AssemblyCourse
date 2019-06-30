del test.exe
del test.obj
..\..\masm\masm test.asm;
..\..\masm\link test.obj;
del test.obj
debug test.exe
cmd