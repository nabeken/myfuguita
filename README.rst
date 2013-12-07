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
    master is for 5.5-current.
5.4
    5.4 is for 5.4-stable
5.2
    5.2 is for 5.2-stable
5.3
    5.3 is for 5.3-stable

REQUIREMENTS
------------

.. _`Virtualbox`: http://www.virtualbox.org/
.. _`Packer`: https://github.com/mitchellh/packer

- `Packer`_ to build a builder from a snapshot
- `Virtualbox`
- source codes (src.tar, sys.tar)

SETTING UP BASE SYSTEM FOR LIVECD
---------------------------------

MyFuguIta now creates base image automatically based on ``/usr/dest``.

SETTING UP A BUILDER
--------------------

::

    $ git clone git://github.com/nabeken/myfuguita.git
    $ cd myfuguita/packer
    $ packer build openbsd-<version>.json

If packer builds successfully you can find a vagrant box ``packer_virtualbox_virtualbox.box``.

Specify this box in ``Vagrantfile`` in the top directory like this::

    Vagrant.configure("2") do |config|
      config.vm.guest = :openbsd
      config.vm.box = "packer_virtualbox_virtualbox"
      config.vm.box_url = "http://example.org/packer_virtualbox_virtualbox.box"
      config.vm.hostname = "build-fuguita.dev"
      config.vm.synced_folder "../", "/vagrant", :disabled => true
    end

Continuous Integration
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

See http://projects.tsuntsun.net/~nabeken/myfuguita/5.5/

This build is brought to you by FreeBSD + Vagrant + Jenkins.

LICENSE
-------

See individual files. Patches in ``distrib/``, ``MFC``, ``sys`` are subject to its original license.
