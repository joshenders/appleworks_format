#!/bin/bash

# Detect if file is an appleworks file and add .cwk extensiona
# find . -print -exec ./chkformat {} \;

# ==> format_appleworks_4.xxd <==
# 0000000: 0481 ad00 424f 424f 0001 233e 716c 0000  ....BOBO..#>ql..
#
# ==> format_appleworks_5.xxd <==
# 0000000: 0581 7600 424f 424f 0607 9d00 0000 0000  ..v.BOBO........
#
# ==> format_appleworks_6.xxd <==
# 0000000: 0607 9d00 424f 424f 0607 9d00 0000 0000  ....BOBO........
#
# ==> format_appleworks_6.2.xxd <==
# 0000000: 0607 bd00 424f 424f 0607 bd00 0000 0000  ....BOBO........

[[ $# -ne 1 ]] && { \
  echo "usage: $(basename ${0}) filename" >&2;
  exit 1;
}

signature=$(xxd -p -l 16 "${1}")

version_4=0481ad00424f424f0001233e716c0000
version_5=05817600424f424f06079d0000000000
version_6=06079d00424f424f06079d0000000000
version_62=0607bd00424f424f0607bd0000000000

if [[ ${version_62} == ${signature} ]]; then
  echo "Detected AppleWorks 6.2 file"
  mv -v "${1}" "${1}.cwk"
elif [[ ${version_6} == ${signature} ]]; then
  echo "Detected AppleWorks 6 file"
  mv -v "${1}" "${1}.cwk"
elif [[ ${version_5} == ${signature} ]]; then
  echo "Detected AppleWorks 5 file"
  mv -v "${1}" "${1}.cwk"
elif [[ ${version_4} == ${signature} ]]; then
  echo "Detected ClarisWorks 4 file"
  mv -v "${1}" "${1}.cwk"
else
  echo "non-AppleWorks file format"
fi
