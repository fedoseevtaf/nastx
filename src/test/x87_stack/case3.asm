%include "test/layout.inc"
TEST_BEGIN
	fincstp
	fld1
	fldpi
	fld ST0
	fadd ST0, ST2
	fld1
	fld1
	fadd ST0, ST1
	fld ST0
	fmul ST0, ST3

	call x87_stack
TEST_END
