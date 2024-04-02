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

if ! [ "$XZMODE" == "" -o "$XZMODE" == "remove" -o "$XZMODE" == "keep" -o "$XZMODE" == "rename" -o "$XZMODE" == "link" -o "$XZMODE" == "rename-link" -o "$XZMODE" == "link-rename" ]; then
  echo
  echo -e "XZMODE must be one of the following:"
  echo -e "  [remove] (default) removes <file>.tar.xz after successfully creating <file>.tar.gz"
  echo -e "  [keep] keeps <file>.tar.xz without touching it"
  echo -e "  [rename] removes <file>.tar.xz, then renames <file>.tar.gz to <file>.tar.xz"
  echo -e "  [link] removes <file>.tar.xz, then creates a symlink to <file>.tar.gz named <file>.tar.xz"
  echo -e "  [rename-link] removes <file>.tar.xz, then renames <file>.tar.gz to <file>.tar.xz, then creates a symlink to <file>.tar.xz named <file>.tar.gz"
  echo
  exit
fi

for i in *.tar.xz; do
  if test -f "$i"; then
    tar -xJf "$i" -C "/output" --same-owner
    if [ "$?" != "0" ]; then
      rm -rf "/output/*"
      continue
    fi

    bash /app/recomp.sh "/output" "0"

    dir="$PWD"
    cd "/output"
    tar -czf "$dir/${i%\.xz}.gz" .
    if [ "$?" != "0" ]; then
      cd "$dir"
      rm -rf "/output/*"
      continue
    fi

    cd "$dir"
    rm -rf "/output/*"

    if test -f "${i%\.xz}.gz"; then
      chown --reference="$i" "${i%\.xz}.gz"
      bash /app/handle-xz.sh "$i"
    fi
  fi
done

for i in *; do
  if test -d "$i"; then
    bash /app/run.sh "$i"
  fi
done
