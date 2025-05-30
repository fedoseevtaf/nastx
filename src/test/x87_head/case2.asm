%include "test/layout.inc"
TEST_BEGIN
	fld1
	mov ecx, 7
.loop1:
	fld ST0
	fadd ST0, ST1
	loop .loop1

	ffree ST7
	ffree ST6
	ffree ST5
	mov ecx, 3
.loop2:
	fld ST0
	fadd ST0, ST1
	loop .loop2

	call x87_head
TEST_END
