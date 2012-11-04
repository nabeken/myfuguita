#!/bin/sh
MYFUGUITA_DIR=$(cd `dirname $0`; cd ..; pwd)
SRC_DIR=/usr/src
export MYFUGUITA_DIR

die() {
  echo $1
  exit 1
}

if [ ! -d "${SRC_DIR}/sys" ]; then
  die "OpenBSD sys tree is missing. abort."
fi

if [ ! -d "${SRC_DIR}/distrib" ]; then
  die "OpenBSD src tree is missing. abort."
fi

echo -n "Patching to distrib/amd64..."
cd ${SRC_DIR}/distrib/amd64
patch -p0 < ${MYFUGUITA_DIR}/distrib/amd64/Makefile.patch || die "failed to patch Makefile"

cp -R ${MYFUGUITA_DIR}/distrib/amd64/fuguita* . || die "failed to cp fuguita subdir"
cd fuguita_cd
cp ${SRC_DIR}/distrib/amd64/common/list . || die "failed to cp distrib/common/list"
patch -p0 < list.patch || die "failed to patch list"

echo " done"

echo -n "Patching to GENERIC..."
cd ${SRC_DIR}/sys/arch/amd64/conf
cp GENERIC FUGUITA.MP || die "failed to cp GENERIC"
patch -p0 < ${MYFUGUITA_DIR}/sys/arch/amd64/conf/FUGUITA.MP.patch || die "failed to patch FUGUITA.MP"

echo " done"

echo "It's a time to make release."
