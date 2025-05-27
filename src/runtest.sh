#!/bin/bash


if [ -z "$TESTDIR" ]; then
	TESTDIR="./test"
fi


die() {
	if [ $# -gt 0 ]; then
		echo "$*" >&2
	fi
	exit 1
}

cleardir() {
	if [ -z "$1" ]; then
		echo "No dir to clear" >&2
		exit 1
	fi
	rm -rf "$1/*"
}


TMPDIR=$(mktemp -d)
TMPOUT=$(mktemp -p "$TMPDIR")
TMPERR=$(mktemp -p "$TMPDIR")
for FILE in $(find ./test -name '*.asm') ; do
	BASE="$(basename "$FILE" .asm)"
	DIR="$(dirname "$FILE")"
	FILE="$DIR/$BASE"
	cleardir "$TMPDIR"
	nasm -felf32 -o "$TMPDIR/a.o" "$FILE.asm" -I. >&2 || die
	gcc -m32 -o "$TMPDIR/a.out" "$TMPDIR/a.o" nastx.o \
		1> /dev/null 2> /dev/null || die
	$TMPDIR/a.out 1> "$TMPOUT" 2> "$TMPERR"
	EXIT_CODE=$?
	if [ $EXIT_CODE -ne 0 -o -n "$(head -c1 "$TMPERR")" ]; then
		echo "FAIL:$FILE:$EXIT_CODE" >&2
		cat "$TMPERR" >&2
		cat "$TMPOUT"
		exit 1
	fi
	if [ ! -f "$FILE.ans" ]; then
		echo "FAIL:$FILE:NO_ANSWER" >&2
		exit 1
	fi
	DIFF_REPORT="$(diff "$FILE.ans" "$TMPOUT" )"
	if [ -n "$DIFF_REPORT" ]; then
		echo "FAIL:$FILE:DIFF" >&2
		echo "$DIFF_REPORT"
		exit 1
	fi
	echo "OK:$FILE"
done



