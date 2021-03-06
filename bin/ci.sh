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

cleanup() {
  rm ssh_config || :
  vagrant destroy -f || :
}

wait_ssh() {
  for i in `jot 100`; do
    ssh -F ssh_config build-fuguita true && return 0 || sleep 5
  done
  return 1
}

set -e
export MYFUGUITA_DIR=$(cd `dirname $0`; cd ..; pwd)
cd ${MYFUGUITA_DIR}

if [ ! -f "src.tar.gz" -o ! -f "xenocara.tar.gz" -o ! -f "ports.tar.gz" ]; then
  echo "src.tar.gz or xenocara.tar.gz or ports.tar.gz is not found."
  exit 1
fi

cleanup

vagrant up
vagrant ssh-config --host build-fuguita > ssh_config
rsync -avP --exclude=rel --exclude=packer -e 'ssh -F ssh_config' . build-fuguita:/var/tmp/myfuguita
ssh -F ssh_config build-fuguita 'sudo mkdir /usr/src /usr/obj /usr/xenocara /usr/ports || :'
ssh -F ssh_config build-fuguita 'sudo tar -C /usr/src -zxpf /var/tmp/myfuguita/src.tar.gz; ls -alh /usr/src'
ssh -F ssh_config build-fuguita 'sudo tar -C /usr/xenocara -zxpf /var/tmp/myfuguita/xenocara.tar.gz; ls -alh /usr/xenocara'
ssh -F ssh_config build-fuguita 'sudo tar -C /usr/ports -zxpf /var/tmp/myfuguita/ports.tar.gz; ls -alh /usr/ports'

ssh -F ssh_config build-fuguita "sudo /var/tmp/myfuguita/bin/build.sh kernel" || cleanup

sleep 60

echo "Waiting for reboot to complete"
wait_ssh

ssh -F ssh_config build-fuguita "sudo /var/tmp/myfuguita/bin/build.sh base" || cleanup
ssh -F ssh_config build-fuguita "sudo /var/tmp/myfuguita/bin/build.sh release" || cleanup
ssh -F ssh_config build-fuguita "sudo /var/tmp/myfuguita/bin/build.sh ports" || cleanup

rm -rf rel packages
rsync -avP -e 'ssh -F ssh_config' build-fuguita:/usr/rel/* rel
rsync -avP -e 'ssh -F ssh_config' build-fuguita:/usr/ports/packages/* packages

cleanup
