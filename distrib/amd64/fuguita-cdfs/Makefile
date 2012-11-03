#	$OpenBSD: Makefile,v 1.6 2009/04/17 03:58:54 deraadt Exp $

TOP=	${.CURDIR}/..

.include "${TOP}/Makefile.inc"

VND=vnd1
VND_DEV=/dev/${VND}a
FUGUITA_FFSIMG_SIZE=600
FUGUITA_FFSIMG=${MYFUGUITA_DIR}/fuguita.ffsimg
FUGUITA_FFSIMG_MOUNT=/fuguita.ffsimg

BSDRD=	bsd.rd
CDROM=	fuguita${REV}.iso

all: ${CDROM}

${CDROM}: fuguita.ffsimg
	-rm -rf ${.OBJDIR}/cd-dir
	mkdir -p ${.OBJDIR}/cd-dir/${OSREV}/amd64
	mkdir -p ${.OBJDIR}/cd-dir/etc
	echo "set image /${OSREV}/amd64/bsd.rd" > ${.OBJDIR}/cd-dir/etc/boot.conf
	cp ${.OBJDIR}/../fuguita_cd/${BSDRD} ${.OBJDIR}/cd-dir/${OSREV}/amd64
	cp ${DESTDIR}/usr/mdec/cdbr ${.OBJDIR}/cd-dir/${OSREV}/amd64
	cp ${DESTDIR}/usr/mdec/cdboot ${.OBJDIR}/cd-dir/${OSREV}/amd64/cdboot
	cp ${MYFUGUITA_DIR}/fuguita.ffsimg ${.OBJDIR}/cd-dir/
	mkhybrid -a -R -T -L -l -d -D -N -o ${.OBJDIR}/${CDROM} -v -v \
	    -A "MyFuguIta ${OSREV} amd64 LiveCD" \
	    -P "Copyright (c) `date +%Y`" \
	    -p "TANABE Ken-ichi <nabeken@tknetworks.org>" \
	    -V "OpenBSD/amd64   ${OSREV} LiveCD CD" \
	    -b ${OSREV}/amd64/cdbr -c ${OSREV}/amd64/boot.catalog \
	    ${.OBJDIR}/cd-dir

fuguita.ffsimg:
	dd if=/dev/zero of=${FUGUITA_FFSIMG} bs=1M count=${FUGUITA_FFSIMG_SIZE}
	vnconfig ${VND} ${FUGUITA_FFSIMG}
	echo "a\n\n\n\n\nw\nq\n" | disklabel -E ${VND}
	newfs ${VND}a
	-mkdir ${FUGUITA_FFSIMG_MOUNT}
	mount ${VND_DEV} ${FUGUITA_FFSIMG_MOUNT}
	cd ${FUGUITA_FFSIMG_MOUNT}; ( cd ${DESTDIR}; tar cpf - . ) | tar xpf -
	cd /
	umount ${FUGUITA_FFSIMG_MOUNT}
	vnconfig -u ${VND}

.ifdef RELEASEDIR
install:
	cp ${CDROM} ${RELEASEDIR}
.endif

clean cleandir:
	/bin/rm -f ${CDROM}
	-vnconfig -u ${VND}
	rm -rf cd-dir
	rm -rf ${FUGUITA_FFSIMG}
	rm -rf ${FUGUITA_FFSIMG_MOUNT}

.include <bsd.obj.mk>
.include <bsd.subdir.mk>
