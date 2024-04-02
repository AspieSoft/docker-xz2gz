#!/bin/bash

cd "$1"

r="$2"
if [ "$r" == "" ]; then
  r="0"
fi
r2="$((r+1))"

for i in *.tar.xz; do
  if test -f "$i"; then
    d="${i%\.tar\.xz}.ext.$RANDOM.tmp"

    mkdir "$d"
    tar -xf "$i" -C "$d" --same-owner

    if [ "$r" -lt "20" ]; then
      bash /app/recomp.sh "$d" "$r2"
    fi

    tar -czf "${i%\.xz}.gz" "$d"
    rm -rf "$d"

    if test -f "${i%\.xz}.gz"; then
      chown --reference="$i" "${i%\.xz}.gz"
      rm -f "$i"
    fi
  fi
done

for i in *; do
  if test -d "$i"; then
    bash /app/recomp.sh "$i" "0"
  fi
done
