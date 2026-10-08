#!/bin/sh
# Checks whether a C compiler accepts a command-line flag.
# Exits 0 if it does, 1 if it does not.
#
# $1: compiler (e.g. gcc, clang, or $CC)
# $2: flag to test (e.g. -Wno-error=incompatible-pointer-types)
#
# Used by install.sh to build OLDC_WFLAGS: warning names differ between
# clang and GCC and across versions (GCC 4.8 on CentOS 7 rejects
# -Wno-error=incompatible-function-pointer-types outright).

#########################
# processing arguments
#########################
if [ $# -ne 2 ]; then
    echo "usage: $0 <compiler> <flag>" >&2
    exit 2
fi

COMPILER=$1
FLAG=$2

compile_test=$(echo 'int main(void){return 0;}' | $COMPILER -Werror $FLAG -x c -c -o /dev/null - 2>&1)
if echo 'int main(void){return 0;}' | $COMPILER -Werror $FLAG -x c -c -o /dev/null - >/dev/null 2>&1 ; then
    exit 0
fi

echo "${FLAG} not accepted by ${COMPILER}"
exit 1
