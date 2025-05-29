global x87_top, x87_head, x87_stack

global x87_gist, x87_ngist
global x87_about, x87_nabout

global x87_inform, x87_ninform
global x87_inspect, x87_ninspect

extern printf


%macro MAKE_OFFSET_TAB_ENTRY 4
%1%4:	equ (%2 + %4 * %3)
%endmacro

%macro MAKE_OFFSET_TAB 4
%assign i 0
%rep %4
	MAKE_OFFSET_TAB_ENTRY %1, %2, %3, i
%assign i i+1
%endrep
%endmacro

	struc SAVE
.CW	equ 0
.SW	equ 4
.TW	equ 8
.FIP	equ 12
.FDP	equ 20
.R	equ 28
MAKE_OFFSET_TAB .R, .R, 10, 8
	endstruc

	struc X87DUMP
.CW	equ 0
.SW	equ 4
.TW	equ 8
.R	equ 12
MAKE_OFFSET_TAB .R, .R, 12, 8
.FIP	equ 108
.FDP	equ 116
	endstruc

%macro F_TWORD_MEMCPY_ZX 2
	mov eax, dword [%2]
	mov dword [%1], eax
	mov eax, dword [%2 + 4]
	mov dword [%1 + 4], eax
	movzx eax, word [%2 + 8]
	mov dword [%1 + 8], eax
%endmacro

%macro F_TWORD_MEMCPY_ZX_TAB2TAB 6
	F_TWORD_MEMCPY_ZX %1 + %2%3, %4 + %5%6
%endmacro

%macro F_EXPAND_SAVE_TO_X87DUMP 1
	mov eax, dword [%1 + SAVE.FIP]
	mov dword [%1 + X87DUMP.FIP], eax
	mov eax, dword [%1 + SAVE.FIP + 4]
	mov dword [%1 + X87DUMP.FIP + 4], eax

	mov eax, dword [%1 + SAVE.FDP]
	mov dword [%1 + X87DUMP.FDP], eax
	mov eax, dword [%1 + SAVE.FDP + 4]
	mov dword [%1 + X87DUMP.FDP + 4], eax

%assign i 0
%rep 8
	F_TWORD_MEMCPY_ZX_TAB2TAB %1, X87DUMP.R, i, %1, SAVE.R, i
%assign i i+1
%endrep
%endmacro

%macro F_ENTER_DUMP 0-1
	push ebp
	mov ebp, esp
	push esi
	push edi
	sub esp, 128
%if %0 > 0
	%1 [esp+4]
%else
	fsave [esp+4]
%endif
	F_EXPAND_SAVE_TO_X87DUMP esp+4
%endmacro

%macro F_LEAVE_DUMP 0
	mov edi, dword [ebp-8]
	mov esi, dword [ebp-4]
	leave
%endmacro


section .rodata
fmt_stack_register_value:	db "|ST%u|%26.10Lg|", 10, 0
fmt_stack_register_empty:	db "|ST%u|                       ...|", 10, 0

fmt:				db "%x%x%x", 10, 0

section .text
x87_ntop:
	F_ENTER_DUMP fnsave
	jmp x87_top.body
x87_top:
	F_ENTER_DUMP
.body:

	movzx ecx, word [esp+4+X87DUMP.SW]
	movzx eax, word [esp+4+X87DUMP.TW]

	shr cx, 10
	and cl, 14
	shr ax, cl
	and al, 3
	cmp al, 3
	je .print_empty
.print_value:
	F_TWORD_MEMCPY_ZX esp+8, esp+4 + X87DUMP.R
	mov dword [esp+4], 0
	mov dword [esp], fmt_stack_register_value
	call printf

	F_LEAVE_DUMP
	ret

.print_empty:
	mov dword [esp+4], 0
	mov dword [esp], fmt_stack_register_empty
	call printf

	F_LEAVE_DUMP
	ret

x87_head:
x87_nhead:
x87_stack:
x87_nstack:
x87_gist:
x87_ngist:
x87_about:
x87_nabout:
x87_inform:
x87_ninform:
x87_inspect:
x87_ninspect:
	ret





