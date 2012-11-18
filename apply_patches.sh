#!/bin/bash

TOP=`pwd`

if [ ! -d patches ]
then
  echo Unable to locate patch folder
  exit 1
fi

apply_patch() {
  patch_name=`echo $1 | cut -d _ -f2-`
  dest=`echo $patch_name | sed "s/_/\//" | cut -d . -f1`
  legacy=`echo $dest | cut -d _ -f2`
  if [ ! $legacy == "legacy" ]
  then
    dest=`echo $patch_name | sed "s/_/\//g" | cut -d . -f1`
  fi
  echo "Applying android_$patch_name to $dest"
  if [ -d $dest ]
  then
    pushd $dest >/dev/null
    patch -f -N --no-backup-if-mismatch -r - -p1 < $1
#   git apply -C1 --binary --whitespace=nowarn $1
    popd >/dev/null
  fi
}

for patch in $TOP/patches/android_*.patch
do
  apply_patch $patch
done

if [ ! $FOLDER = "" ]
then
  for patch in $TOP/patches/$FOLDER/android_*.patch
  do
    apply_patch $patch
  done
fi

