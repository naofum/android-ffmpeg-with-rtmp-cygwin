function build_openssl {
  echo "Building openssl-android ..."

  #export ANDROID_NDK=~/Development/android-ndk-r10
  . ./setenv-android-arm.sh
  test -d ${src_root}/openssl-1.0.2k || \
    curl -s https://www.openssl.org/source/openssl-1.0.2k.tar.gz -o ${src_root}/openssl-1.0.2k.tar.gz >> ${build_log} 2>&1 || \
    die "Couldn't clone openssl-android repository!"
  cd ${src_root}
  tar xvfz openssl-1.0.2k.tar.gz  >> ${build_log} 2>&1 || die "Couldn't build openssl-android!"

  cd openssl-1.0.2k
  export CC="gcc -v -Ic:/dev/android-ndk-r14b/platforms/android-19/arch-arm/usr/include -Iusr/include --sysroot=c:/dev/android-ndk-r14b/platforms/android-19/arch-arm"
  echo "Configuring openssl-android ..."
  ./config no-shared -no-ssl2 -no-ssl3 -no-comp -no-hw -no-engine --openssldir=. >> ${build_log} 2>&1 || \
    die "Couldn't config openssl Makefile!"


  # patch the Makefile to use an Android-friendly versioning scheme
#  patch -u Makefile ${patch_root}/openssl-Makefile.patch >> ${build_log} 2>&1 || \
#   die "Couldn't patch openssl Makefile!"
#  patch -u util/mkbuildinf.pl ${patch_root}/openssl-mkbuildinf.pl.patch >> ${build_log} 2>&1 || \
#   die "Couldn't patch openssl mkbuildinf.pl!"

  echo "Making openssl-android ..."
  make depend  >> ${build_log} 2>&1 || die "Couldn't build openssl-android!"
  make all  >> ${build_log} 2>&1 || die "Couldn't build openssl-android!"

  # copy the versioned libraries
  cp ${src_root}/openssl-1.0.2k/lib*.a ${dist_lib_root}/.
  # copy the executables
  cp ${src_root}/openssl-1.0.2k/apps/openssl ${dist_bin_root}/.
  cp ${src_root}/openssl-1.0.2k/test/ssltest ${dist_bin_root}/.
  # copy the headers
  cp -r ${src_root}/openssl-1.0.2k/include/* ${dist_include_root}/.

  cd ${top_root}
}
