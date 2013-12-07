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

set -e
export MYFUGUITA_DIR=$(cd `dirname $0`; cd ..; pwd)
cd ${MYFUGUITA_DIR}

if [ ! -f "src.tar.gz" ]; then
  echo "src.tar.gz is not found. Prepareing src.tar.gz is up to you."
  exit 1
fi

cleanup

vagrant up
vagrant ssh-config --host build-fuguita > ssh_config
rsync -avP -e 'ssh -F ssh_config' . build-fuguita:/tmp/myfuguita
ssh -F ssh_config build-fuguita 'sudo tar -C /usr/src -zxpf /tmp/myfuguita/src.tar.gz; ls -alh /usr/src'

ssh -F ssh_config build-fuguita "sudo /tmp/myfuguita/bin/build.sh" || cleanup

rm -rf rel
rsync -avP -e 'ssh -F ssh_config' build-fuguita:/usr/rel/* rel

cleanup
