function build_ffmpeg {
  echo "Building ffmpeg for android ..."

  # download ffmpeg
  ffmpeg_archive=${src_root}/ffmpeg-3.3.tar.bz2
  if [ ! -f "${ffmpeg_archive}" ]; then
    test -x "$(which curl)" || die "You must install curl!"
    curl -s http://ffmpeg.org/releases/ffmpeg-3.3.tar.bz2 -o ${ffmpeg_archive} >> ${build_log} 2>&1 || \
      die "Couldn't download ffmpeg sources!"
  fi

  # extract ffmpeg
  if [ ! -d "${src_root}/ffmpeg-3.3" ]; then
    cd ${src_root}
    tar xvfj ${ffmpeg_archive} >> ${build_log} 2>&1 || die "Couldn't extract ffmpeg sources!"
  fi

  cd ${src_root}/ffmpeg-3.3

  # patch the configure script to use an Android-friendly versioning scheme
  patch -u configure ${patch_root}/ffmpeg-configure.patch >> ${build_log} 2>&1 || \
    die "Couldn't patch ffmpeg configure script!"
  #20150207
  patch -u libavcodec/libmp3lame.c ${patch_root}/ffmpeg-libmp3lame.patch >> ${build_log} 2>&1 || \
    die "Couldn't patch ffmpeg libmp3lame.c!"

  #20150207
  #cp ${src_root}/../patches/*.pc ${src_root}/openssl-android/
  cp ${src_root}/lame-3.99.5/include/lame.h ${src_root}/ffmpeg-3.3/libavcodec

  # run the configure script
  prefix=${src_root}/ffmpeg-3.3/android/arm
  addi_cflags="-marm"
  addi_ldflags=""
  #20150207
  # export PKG_CONFIG_PATH="${src_root}/openssl-1.0.2k:${src_root}/rtmpdump/librtmp"
  export PKG_CONFIG_PATH="${src_root}/openssl-1.0.2k:${src_root}/rtmpdump/librtmp:${src_root}/lame-3.99.5/libmp3lame"
  ./configure \
    --prefix=${prefix} \
    --disable-shared \
    --enable-static \
    --disable-doc \
    --disable-ffplay \
    --disable-ffprobe \
    --disable-ffserver \
    --disable-symver \
    --cross-prefix=${TOOLCHAIN}/bin/arm-linux-androideabi- \
    --target-os=linux \
    --arch=arm \
    --enable-cross-compile \
    --enable-librtmp \
    --enable-openssl \
    --enable-libmp3lame \
    --enable-decoder=h264 \
    --sysroot=${SYSROOT} \
    --extra-cflags="-Os -fpic ${addi_cflags} -I${src_root}/openssl-1.0.2k/include -Ic:/dev/android-ffmpeg/src/openssl-1.0.2k/include -Ic:/dev/android-ffmpeg/src/rtmpdump -fvisibility=default --static -fPIE" \
    --extra-ldflags="-L${src_root}/openssl-1.0.2k -L${src_root}/lame-3.99.5/libs/armeabi -LC:/dev/android-ndk-r14b/platforms/android-19/arch-arm/usr/lib -Lc:/dev/android-ffmpeg/build/dist/lib -Lc:/dev/android-ffmpeg/src/rtmpdump/librtmp c:/dev/android-ffmpeg/src/rtmpdump/librtmp/librtmp.a -Lc:/dev/android-ffmpeg/src/openssl-1.0.2k -L c:/dev/android-ffmpeg/src/lame-3.99.5/obj/local/armeabi-v7a/libmp3lame.a c:/dev/android-ffmpeg/src/openssl-1.0.2k/libssl.a c:/dev/android-ffmpeg/src/openssl-1.0.2k/libcrypto.a c:/dev/android-ffmpeg/src/lame-3.99.5/obj/local/armeabi-v7a/libmp3lame.a ${addi_ldflags} -pie" \
    --extra-libs="-lmp3lame -lm -ldl" \
    --pkg-config=$(which pkg-config) >> ${build_log} 2>&1 || die "Couldn't configure ffmpeg!"

  # patch config.h LOG2 function 
  patch -u config.h ${patch_root}/ffmpeg-config.h.patch >> ${build_log} 2>&1 || \
    die "Couldn't patch ffmpeg config.h !"

  # build
  make >> ${build_log} 2>&1 || die "Couldn't build ffmpeg!"
  make install >> ${build_log} 2>&1 || die "Couldn't install ffmpeg!"

  # copy the versioned libraries
  cp ${prefix}/lib/lib*-+([0-9]).a ${dist_lib_root}/.
  # copy the executables
  cp ${prefix}/bin/ff* ${dist_bin_root}/.
  # copy the headers
  cp -r ${prefix}/include/* ${dist_include_root}/.

  cd ${top_root}
}
