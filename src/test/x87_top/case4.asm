%include "test/layout.inc"
TEST_BEGIN
	fld1
	mov ecx, 13
	jecxz .end
.loop:
	fld ST0
	fadd ST1
	ffree ST1
	loop .loop
.end:

	call x87_top
TEST_END
