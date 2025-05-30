%include "test/layout.inc"
TEST_BEGIN
	fldpi
	fld1
	fld ST0
	fadd ST0, ST2

	call x87_head
TEST_END
