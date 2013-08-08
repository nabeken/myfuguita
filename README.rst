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

Make a release build as usual described in ``man release(8)`` or use the following::

    build# ./bin/build.sh

``fuguitaXX.iso`` is stored at ``${RELEASEDIR}/fuguitaXX.iso``

Continuous Intergration
-----------------------

A preparing ``src.tar.gz`` is up to you.

Once storing ``src.tar.gz`` in the top directory of working copy you can execute ``bin/ci.sh``.
This script allows you to:

- set up a build server with ``vagrant up``
- rsync the working copy to the server
- execute ``bin/myfuguita.sh`` and ``bin/build.sh`` in the server
- rsync the release directory in the server to ``rel`` directory in the top of the working copy
- destroy the server wtih ``vagrant destroy -f``

You can archive the rel directory as artifacts.

Daily Build
------------

See http://projects.tsuntsun.net/~nabeken/myfuguita/5.4/

The build is brought you by FreeBSD + Vagrant + Jenkins.

LICENSE
-------

See individual files. Patches in ``distrib/``, ``MFC``, ``sys`` are subject to its original license.
