%include "nastx.inc"

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
.ST	equ 28
MAKE_OFFSET_TAB .ST, .ST, 10, 8
	endstruc

	struc X87DUMP
.CW	equ 0
.SW	equ 4
.TW	equ 8
.ST	equ 12
MAKE_OFFSET_TAB .ST, .ST, 12, 8
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

%macro F_LONG_DOUBLE_MEMCPY 2
	mov eax, dword [%2]
	mov dword [%1], eax
	mov eax, dword [%2 + 4]
	mov dword [%1 + 4], eax
	mov eax, dword [%2 + 8]
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
	F_TWORD_MEMCPY_ZX_TAB2TAB %1, X87DUMP.ST, i, %1, SAVE.ST, i
%assign i i+1
%endrep
%endmacro

%macro F_ENTER_DUMP 0-1
	push ebp
	mov ebp, esp
	push esi
	push edi
	push ebx
	sub esp, 124

%if %0 > 0
	%1 [esp+4]
%else
	fsave [esp]
%endif

	F_EXPAND_SAVE_TO_X87DUMP esp
%endmacro

%macro F_LEAVE_DUMP 0
	mov edi, dword [ebp-8]
	mov esi, dword [ebp-4]
	mov ebx, dword [ebp-12]
	leave
%endmacro


section .rodata
fmt_stack_register_value:	db "|ST%u|%26.10Lg|", 10, 0
fmt_stack_register_empty:	db "|ST%u|                       ...|", 10, 0

section .text
x87_ntop:
	F_ENTER_DUMP fnsave		;
	jmp x87_top.body		;
x87_top:
	F_ENTER_DUMP			;
.body:
	mov bx, word [esp+X87DUMP.TW]	; Rotate Tag Word in BX
	mov cx, word [esp+X87DUMP.SW]	; so that least significant bits
	shr cx, 10			; are tag of the ST0
	and cl, 14			;
	ror bx, cl			;

	and bl, 3			; Check tag of ST0
	cmp bl, 3			;
	je .print_empty			;
.print_value:
	sub esp, 32			;
	F_LONG_DOUBLE_MEMCPY esp+8, esp+32 + X87DUMP.ST0
	mov dword [esp+4], 0		;
	mov dword [esp], fmt_stack_register_value
	call printf			;

	F_LEAVE_DUMP			;
	ret				;

.print_empty:
	sub esp, 16			;
	mov dword [esp+4], 0		;
	mov dword [esp], fmt_stack_register_empty
	call printf			;

	F_LEAVE_DUMP			;
	ret				;

x87_nhead:
	F_ENTER_DUMP fnsave		;
	jmp x87_head.body		;
x87_head:
	F_ENTER_DUMP			;
.body:
	mov bx, word [esp + X87DUMP.TW]	;
	mov cx, word [esp + X87DUMP.SW]	;
	shr cx, 10			;
	and cl, 14			;
	ror bx, cl			;

	mov ecx, 7			;
.loop1:
	rol bx, 2			;
	mov al, bl			;
	and al, 3			;
	cmp al, 3			;
	jne .end1			;
	loop .loop1			;
.end1:

	lea esi, [ecx*2 + ecx]		;
	lea esi, [esi*4 + esp + X87DUMP.ST]
	sub esp, 32			;
	mov edi, ecx			;
	inc edi				;
.loop2:
	dec edi				;

	mov al, bl			;
	and al, 3			;
	cmp al, 3			;
	je .print_empty			;
.print_value:
	F_LONG_DOUBLE_MEMCPY esp+8, esi	;
	mov dword [esp+4], edi		;
	mov dword [esp], fmt_stack_register_value
	call printf			;
	jmp .continue			;
.print_empty:
	mov dword [esp+4], edi		;
	mov dword [esp], fmt_stack_register_empty
	call printf			;
.continue:
	rol bx, 2			;
	sub esi, 12			;
	test edi, edi			;
	jnz .loop2			;
.end2:
	F_LEAVE_DUMP			;
	ret				;

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





