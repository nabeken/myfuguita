#	$OpenBSD: Makefile,v 1.5 2010/10/18 04:07:50 deraadt Exp $

.PATH: ${.CURDIR}/../ramdisk
RAMDISK=FUGUITA.MP
FLOPPYSIZE=11520
FLOPPYTYPE=floppy576
XNAME=fuguita
NOFS=1
NOBSDRD=1

.include "${.CURDIR}/../common/Makefile.inc"

NEWFSARGS= -m 0 -o space -i 2040 

LISTS=		${.CURDIR}/list
