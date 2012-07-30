MyFuguIta - Fuguita ported to OpenBSD build system to support amd64/i386
========================================================================

.. _`FuguIta`: http://kaw.ath.cx/openbsd/index.php?FuguIta

`FuguIta`_ is the LiveCD/LiveUSB system developed by Yoshihiro Kawamata.
FuguIta works like a charm but only available for i386.

To support amd64, the following works were made.

- ported FuguIta build system to OpenBSD build system
= build FuguIta with ``make release`` on OpenBSD amd64

REQUIREMENTS
------------

- OpenBSD running on amd64 x2 (build machine, base system for LiveCD)
- extracted source code (src.tar, sys.tar) in /usr/src
- git

SETTING UP BASE SYSTEM FOR LIVECD
---------------------------------

If you have a base installation for LiveCD you can skip this section. If not
You can install OpenBSD as the base installation.

SETTING UP BUILD SYSMTEM
------------------------

.. _`memo: create disk image under openbsd`: http://westfox.livejournal.com/51329.html

::

    build# git clone git://github.com/nabeken/myfuguita.git
    build# cd myfuguita

Create a disk image with the base installation prepared in the above. ::

    build# dd if=/dev/zero of=fuguita.ffsimg bs=1M count=500
    build# vnconfig vnd0 fuguita.ffsimg
    build# fdisk -e vnd0
    reinit
    build# disklabel -E vnd0
    a
    w
    build# newfs vnd0a
    build# mkdir /fuguita.ffsimg
    build# mount /dev/vnd0a /fuguita.ffsimg
    build# /fuguita.ffsimg
    build# ssh your-base-installation 'tar cpf - /' | tar xvpf -
    or
    build# ( cd /usr/dest; tar cpf - . ) | tar xvpf -
    build# cd /
    build# umount /fuguita.ffsimg; vnconfig -u vnd0

Integrate FuguIta with OpenBSD build system. ::

    build# cd /usr/src
    build# cp -R /root/myfuguita/distrib .
    build# cp -R /root/myfuguita/sys .
    build# vi distrib/amd64/Makefile
    // Add fuguita_cd, fuguita-cdfs to SUBDIR
    SUBDIR= ramdisk_cd ramdiskA cdfs fuguita_cd fuguita-cdfs

    // Add cd fuguita_cd; ${MAKE} unconfig to unconfig target
    unconfig:
            cd ramdisk_cd; ${MAKE} unconfig
            cd ramdiskA; ${MAKE} unconfig
            cd fuguita_cd; ${MAKE} unconfig

Make a release build as usual described in ``man 8 release``.
``fuguita51.iso`` lives in ``/usr/src/distrib/amd64/fuguita-cdfs/obj/fuguita51.iso``
