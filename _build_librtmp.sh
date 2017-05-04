function build_librtmp {
  echo "Building librtmp for android ..."
SYSROOT=c:/dev/android-ndk-r14b/platforms/android-19/arch-arm

  test -d ${src_root}/rtmpdump || \
    git clone git://git.ffmpeg.org/rtmpdump ${src_root}/rtmpdump >> ${build_log} 2>&1 || \
    die "Couldn't clone rtmpdump repository!"

  cd ${src_root}/rtmpdump/librtmp

  # patch the Makefile to use an Android-friendly versioning scheme
#  patch -u Makefile ${patch_root}/librtmp-Makefile.patch >> ${build_log} 2>&1 || \
#    die "Couldn't patch librtmp Makefile!"

  src_root=c:/dev/android-ffmpeg/src
  openssl_dir=${src_root}/openssl-1.0.2k
  prefix=${src_root}/rtmpdump/librtmp/android/arm
  addi_cflags="-marm"
  addi_ldflags=""

#ln -s ${src_root}/openssl-1.0.2k/crypto/comp/comp.h ${src_root}/openssl-1.0.2k/include/openssl/
  test -L "crtbegin_so.o" || ln -s ${SYSROOT}/usr/lib/crtbegin_so.o
  test -L "crtend_so.o" || ln -s ${SYSROOT}/usr/lib/crtend_so.o
  export XLDFLAGS="$addi_ldflags -L${openssl_dir} -L${SYSROOT}/usr/lib"
  export CROSS_COMPILE=${TOOLCHAIN}/bin/arm-linux-androideabi-
  export CPATH=../../openssl-1.0.2k/include
  export XCFLAGS="${addi_cflags} -I${openssl_dir}/include -isysroot ${SYSROOT}"
  export INC="-I${SYSROOT}"
  make prefix=\"${prefix}\" OPT= SHARED= install >> ${build_log} 2>&1 || \
    die "Couldn't build librtmp for android!"

  # copy the versioned libraries
  cp ${prefix}/lib/lib*.a ${dist_lib_root}/.
  # copy the headers
  cp -r ${prefix}/include/* ${dist_include_root}/.

  cd ${top_root}
}
