#!/bin/bash

SCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
cd "${SCRIPTDIR}" || exit 1

function buildWithMask() {
  umask $1
  mvn clean package
  mv target target-${UMASK}
}

buildWithMask 0002
buildWithMask 0022
buildWithMask 0055

ls -laF target*/*.jar
md5sum target*/*.jar