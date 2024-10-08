#!/bin/bash

#init ksu
git submodule init && git submodule update

export RDIR=$(pwd)
export ARCH=arm64

#symlinking python2
if [ ! -f "$HOME/python" ]; then
    ln -s /usr/bin/python2.7 "$HOME/python"
fi 

# ⚠️ EDIT THIS VALUE BY USING THE PATH FOR YOUR COMPLIER'S BIN (ONLY EDIT $PWD/toolchains/clang/bin PART)
export PATH=$PWD/toolchains/clang/bin:$PATH

#output dir
if [ ! -d "${RDIR}/out" ]; then
    mkdir -p "${RDIR}/out"
fi

# ⚠️ EDIT THIS ALSO ACCORDING TO YOUR NEEDS
export ARGS="
-j$(nproc) \
O=$(pwd)/out \
ARCH=arm64 \
CC=clang \
CROSS_COMPILE=aarch64-linux-gnu- \
CROSS_COMPILE_ARM32=arm-linux-gnueabi- \
"
#allowlist patch
if [ ! -f ".allowlist_patched" ]; then
    patch -p1 < "${RDIR}/ksu.patch"
    echo "1" > "${RDIR}/.allowlist_patched"
fi

build_kernel(){
    make ${ARGS} acrux_defconfig ksu.config
    make ${ARGS} menuconfig
    make ${ARGS}
}

build_kernel