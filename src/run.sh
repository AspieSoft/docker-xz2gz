#!/bin/bash

# disable ssh
systemctl stop ssh &>/dev/null
systemctl stop sshd &>/dev/null
update-rc.d ssh remove &>/dev/null
update-rc.d sshd remove &>/dev/null

# search dirs and subdires for .tar.xz, and decompress
# then recompress to .tar.gz

if [ "$1" == "" ]; then
  cd /input
else
  cd "$1"
fi

for i in *.tar.xz; do
  if test -f "$i"; then
    tar -xf "$i" -C "/output" --same-owner
    bash /app/recomp.sh "/output" "0"

    tar -czf "${i%\.xz}.gz" "/output"
    rm -rf "/output/*"

    if test -f "${i%\.xz}.gz"; then
      chown --reference="$i" "${i%\.xz}.gz"
      rm -f "$i"
    fi
  fi
done

for i in *; do
  if test -d "$i"; then
    bash /app/run.sh "$i"
  fi
done
