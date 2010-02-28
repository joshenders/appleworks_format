#!/bin/bash

files=$(find . -type f -maxdepth 1 | grep -v $0 | sed 's/\.\///g')

if [[ ! -d dumps ]]; then
  [[ -n "${files}" ]] && mkdir dumps
fi

if [[ -n "${files}" ]]; then
  for i in ${files}; do xxd $i > dumps/$i.xxd; done
fi
