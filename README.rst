MyFuguIta - Fuguita ported to OpenBSD build system to support amd64/i386
========================================================================

.. _`FuguIta`: http://kaw.ath.cx/openbsd/index.php?FuguIta

`FuguIta`_ is the LiveCD/LiveUSB system developed by Yoshihiro Kawamata.
FuguIta works like a charm but only available for i386.

To support amd64, the following works were made.

- port FuguIta build system to OpenBSD build system
- intergrate FuguIta with ``release(8)`` on OpenBSD amd64

BRANCH
------

MyFuguita has branches according to OpenBSD's branches.

master
	master is for 5.4-current.
5.2
	5.2 is for 5.2-stable
5.3
	5.3 is for 5.3-stable

REQUIREMENTS
------------

- OpenBSD running on amd64 x1
- extracted source code (src.tar, sys.tar) in /usr/src
- git

SETTING UP BASE SYSTEM FOR LIVECD
---------------------------------

MyFuguIta now creates base image automatically based on ``/usr/dest``.

SETTING UP BUILD SYSMTEM
------------------------

::

    build# cd /usr/src
    build# tar zxpf /path/to/src.tar.gz
    build# tar zxpf /path/to/sys.tar.gz
    build# cd
    build# git clone git://github.com/nabeken/myfuguita.git
    build# cd myfuguita

Integrate FuguIta with OpenBSD build system. ::

    build# ./bin/myfuguitanize.sh

Make a release build as usual described in ``man release(8)``.
``fuguita52.iso`` is stored at ``${RELEASEDIR}/fuguita52.iso``

LICENSE
-------

See individual files. Patches in ``distrib/``, ``MFC``, ``sys`` are subject to its original license.
