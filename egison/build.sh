#!/bin/bash
#ref: https://github.com/egison/egison-package-builder/blob/master/dockerfiles/tarball-builder/build.sh
set -ue
VERSION="$1"
readonly REPODIR="${HOME}/egison"

## Make shared libraries static
cabal update
git clone --depth 1 --branch "${VERSION}" https://github.com/egison/egison.git "${REPODIR}"
cd "${REPODIR}"
sed -i '/Executable egison-translate/,//d' egison.cabal
cabal configure --enable-executable-static --jobs
cabal build
_pathsfile="$(find "${REPODIR}/dist-newstyle/" -type f -name Paths_egison.hs | head -n 1)"
perl -i -pe 's@datadir[ ]*=[ ]*.*$@datadir = "/usr/lib/egison"@' "$_pathsfile"
cp "$_pathsfile" ./hs-src
cabal build

## Packaging
WORKDIR="${HOME}/work"
BUILDROOT="${WORKDIR}/egison-${VERSION}"
mkdir -p "${BUILDROOT}/bin"
_binfile="$(find "${REPODIR}/dist-newstyle" -type f -name egison)"
cp "${_binfile}" "${BUILDROOT}/bin"
cp -rf "${REPODIR}/lib" "${BUILDROOT}/"
cp "${REPODIR}/LICENSE" "${BUILDROOT}/"
cp "${REPODIR}/README.md" "${BUILDROOT}/"
cp "${REPODIR}/THANKS.md" "${BUILDROOT}/"
cd "${WORKDIR}"
tar -zcvf "${HOME}/pkg/egison-linux-$(uname -m | sed 's/x86_/amd/;s/aarch/arm/').tar.gz" "egison-${VERSION}"
