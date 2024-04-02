#!/bin/bash

cd "$1"

r="$2"
if [ "$r" == "" ]; then
  r="0"
fi
r2="$((r+1))"

for i in *.tar.xz; do
  if test -f "$i"; then
    d="${i%\.tar\.xz}.xz2gz.ext.$RANDOM.tmp"
    mkdir "$d"

    tar -xJf "$i" -C "$d" --same-owner
    if [ "$?" != "0" ]; then
      rm -rf "$d"
      continue
    fi

    if [ "$r" -lt "20" ]; then
      bash /app/recomp.sh "$d" "$r2"
    fi

    dir="$PWD"
    cd "$d"
    tar -czf "$dir/${i%\.xz}.gz" .
    if [ "$?" != "0" ]; then
      cd "$dir"
      rm -rf "$d"
      continue
    fi

    cd "$dir"
    rm -rf "$d"

    if test -f "${i%\.xz}.gz"; then
      chown --reference="$i" "${i%\.xz}.gz"
      bash /app/handle-xz.sh "$i"
    fi
  fi
done

for i in *; do
  if test -d "$i"; then
    bash /app/recomp.sh "$i" "0"
  fi
done
