#!/bin/bash

set -e

CONTAINER=pdbg-build

Dockerfile=$(cat << EOF
FROM ubuntu:17.04
RUN apt-get update && apt-get install --no-install-recommends -yy \
	make \
	gcc-arm-linux-gnueabi \
	libc-dev-armel-cross \
	autoconf \
	automake \
	libtool \
	git \
	device-tree-compiler
RUN groupadd -g ${GROUPS} ${USER} && useradd -d ${HOME} -m -u ${UID} -g ${GROUPS} ${USER}
USER ${USER}
ENV HOME ${HOME}
RUN /bin/bash
EOF
)

docker pull ubuntu:17.04
docker build -t ${CONTAINER} - <<< "${Dockerfile}"

RUN="docker run --rm=true --user=${USER} -w ${PWD} -v ${HOME}:${HOME} -t ${CONTAINER}"

${RUN} ./bootstrap.sh

# Out-of-tree build, ARM
SRCDIR=$PWD
TEMPDIR=`mktemp -d ${HOME}/pdbgobjXXXXXX`
RUN_TMP="docker run --rm=true --user=${USER} -w ${TEMPDIR} -v ${HOME}:${HOME} -t ${CONTAINER}"
${RUN_TMP} ${SRCDIR}/configure --host=arm-linux-gnueabi
${RUN_TMP} make
rm -rf ${TEMPDIR}

# In-tree build, ARM
${RUN} ./configure --host=arm-linux-gnueabi
${RUN} make
${RUN} make distclean

# Out-of-tree build, ppc64le
SRCDIR=$PWD
TEMPDIR=`mktemp -d ${HOME}/pdbgobjXXXXXX`
RUN_TMP="docker run --rm=true --user=${USER} -w ${TEMPDIR} -v ${HOME}:${HOME} -t ${CONTAINER}"
${RUN_TMP} ${SRCDIR}/configure --host=powerpc64le-linux-gnu
${RUN_TMP} make
rm -rf ${TEMPDIR}

# In-tree build, ppc64le
${RUN} ./configure --host=powerpc64le-linux-gnu
${RUN} make
${RUN} make distclean

# Out-of-tree build, native
SRCDIR=$PWD
TEMPDIR=`mktemp -d ${HOME}/pdbgobjXXXXXX`
INSTALLTEMPDIR=`mktemp -d ${HOME}/pdbginstallXXXXXX`
RUN_TMP="docker run --rm=true --user=${USER} -w ${TEMPDIR} -v ${HOME}:${HOME} -t ${CONTAINER}"
${RUN_TMP} ${SRCDIR}/configure --prefix=${INSTALLTEMPDIR}
${RUN_TMP} make
${RUN_TMP} make install
echo "LD_LIBRARY_PATH=${INSTALLTEMPDIR}/lib ${INSTALLTEMPDIR}/bin/pdbg -b fake probe -a" > run.sh
${RUN_TMP} bash ${SRCDIR}/run.sh
rm -rf ${TEMPDIR} ${INSTALLTEMPDIR}
