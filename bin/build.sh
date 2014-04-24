#!/bin/sh
# /*
#  * Copyright (c) 2013 TANABE Ken-ichi <nabeken@tknetworks.org>
#  *
#  * Permission to use, copy, modify, and distribute this software for any
#  * purpose with or without fee is hereby granted, provided that the above
#  * copyright notice and this permission notice appear in all copies.
#  *
#  * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
#  * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
#  * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
#  * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
#  * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
#  * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
#  * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
#  */
set -e
export MYFUGUITA_DIR=$(cd `dirname $0`; cd ..; pwd)

case "$1" in
  kernel)
    mkdir /usr/src /usr/obj || :
    #${MYFUGUITA_DIR}/bin/myfuguitanize.sh

    cd /usr/src/sys/arch/amd64/conf
    config GENERIC
    cd ../compile/GENERIC
    make clean && make
    make install
    shutdown -r now
    ;;
  base)
    cd /usr/src && make obj
    cd /usr/src/etc && env DESTDIR=/ make distrib-dirs
    cd /usr/src && make build

    export DESTDIR=/usr/dest RELEASEDIR=/usr/rel
    export RELDIR=$RELEASEDIR
    rm -rf ${DESTDIR} ${RELEASEDIR} ${WORKSPACE}/rel || :
    mkdir -p ${DESTDIR} ${RELEASEDIR}
    cp ${MYFUGUITA_DIR}/src.tar.gz ${RELEASEDIR}
    cd /usr/src/etc && make release
    #cd /usr/src/distrib/sets && sh checkflist
    cd /usr/src/distrib/`machine -a`/iso && make && make install
    cd ${RELEASEDIR} && ls -l | tail -n+2 > index.txt
    ;;
esac
