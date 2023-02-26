#!/bin/bash

SCRIPTDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
cd "${SCRIPTDIR}" || exit 1

# Configure it for the local user
if [ "$(uname -s)" == "Linux" ]; then
  USER_NAME=${SUDO_USER:=${USER}}
  USER_ID=$(id -u "${USER_NAME}")
  GROUP_ID=$(id -g "${USER_NAME}")
else # boot2docker uid and gid
  USER_NAME=${USER}
  USER_ID=1000
  GROUP_ID=50
fi

function buildWithMask() {
    local UMASK=$1

    #=================================================
    cat - > Dockerfile${UMASK} << UserSpecificDocker
FROM maven:3.9.0-eclipse-temurin-17-focal

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

ENV UMASK ${UMASK}
ADD mvn /usr/local/bin
RUN chmod 755 /usr/local/bin/mvn

RUN groupadd --non-unique -g "${GROUP_ID}" "${USER_NAME}"
RUN useradd -g "${GROUP_ID}" -u "${USER_ID}" -k /root -m "${USER_NAME}"
RUN chown "${USER_NAME}" "/home/${USER_NAME}"
ENV HOME "/home/${USER_NAME}"
WORKDIR "/home/${USER_NAME}"
UserSpecificDocker

    docker build -t "demomaven-${USER_NAME}-${UMASK}" -f "Dockerfile${UMASK}" "${SCRIPTDIR}/docker/"

    docker run --rm=true                                 \
       -u "${USER_NAME}"                                 \
       -v "${PWD}:/home/${USER_NAME}/assembly"           \
       -w "/home/${USER}/assembly"                       \
       "demomaven-${USER_NAME}-${UMASK}"                 \
       mvn clean package

    mv target target-${UMASK}
}

buildWithMask 0002
buildWithMask 0022
buildWithMask 0055


diffoscope