#!/bin/bash

i="$1"

if [ "$XZMODE" == "keep" ]; then
  exit
fi

rm -f "$i"

if [ "$XZMODE" == "rename" -o "$XZMODE" == "rename-link" -o "$XZMODE" == "link-rename" ]; then
  mv -f "${i%\.xz}.gz" "$i"
elif [ "$XZMODE" == "link" ]; then
  ln -s "${i%\.xz}.gz" "$i"
fi

if [ "$XZMODE" == "rename-link" -o "$XZMODE" == "link-rename" ]; then
  ln -s "$i" "${i%\.xz}.gz"
fi
