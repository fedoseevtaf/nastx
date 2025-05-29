%include "test/layout.inc"
TEST_BEGIN
	fldpi
	fst ST3

	fld1
	faddp

	fdecstp
	fdecstp
	fdecstp
	fdecstp
	fdecstp

	call x87_top
TEST_END
