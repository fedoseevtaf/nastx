%macro TEST_BEGIN 0
global main

%include "nastx.inc"

section  .text
main:
	push ebp
	mov ebp, esp
	sub esp, 8
	finit
	fwait
%endmacro

%macro TEST_END 0
	xor eax, eax
	leave
	ret
%endmacro

