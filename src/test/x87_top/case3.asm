%include "test/layout.inc"
TEST_BEGIN
	fldpi
	fst ST3
	fdecstp
	fdecstp
	fdecstp
	fdecstp
	fdecstp

	call x87_top
TEST_END
