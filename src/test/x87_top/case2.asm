%include "test/layout.inc"
TEST_BEGIN
	fldpi
	fldln2
	fsubp

	call x87_top
TEST_END
