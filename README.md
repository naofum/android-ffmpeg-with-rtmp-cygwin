# android-ffmpeg-with-rtmp-cygwin

This repository contains script(s) to build ffmpeg for android with RTMP (and OpenSSL) support.
This script was inspired with cine-io/android-ffmpeg-with-rtmp and modified for cygwin environment.

## Instructions

1. Install the [Android NDK][android-ndk] (tested with version r14).
2. Ensure that [cURL][cURL] is installed.
3. Ensure that [pkg-config][pkg-config] is installed.
4. Clone this repository and `cd` into its directory.
5. Run `build.sh`.
6. Look in `build/dist` for the resulting libraries and executables.
7. Look in `build/build.log` if something goes wrong.

For example:

```bash
$ git clone git@github.com:naofum/android-ffmpeg-with-rtmp-cygwin.git
$ cd android-ffmpeg-with-rtmp-cygwin
$ ./build.sh
```

## Notes

The first time you run the script, it will try to find the location where
you've installed the NDK. It will also try to auto-detect your operating
system and architecture. This process might take a minute or two, so the
information will be saved into a configuration file called
`.build-config.sh` which will be used on subsequent executions of
the script.

The script is meant to be idempotent. However, should you want to start over
from scratch, it's a simple matter of:

```bash
$ rm -rf src build .build-config.sh
$ ./build.sh
```


.build-config.sh example:

```.build-config.sh
OS_ARCH=cygwin_nt-10.0-i686
NDK=/cygdrive/c/dev/android-ndk-r14b
SYSROOT=c:/dev/android-ndk-r14b/platforms/android-19/arch-arm
TOOLCHAIN=c:/dev/android-ndk-r14b/toolchains/arm-linux-androideabi-4.9/prebuilt/windows
```


.bashrc example:

```bash
// to create symlinks when extract OpenSSL archive in cygwin environment
export CYGWIN="winsymlinks:native"

export ANDROID_NDK_ROOT=c:/dev/android-ndk-r14b
export ANDROID_NDK=/cygdrive/c/dev/android-ndk-r14b
export PATH=/cygdrive/c/dev/android-ndk-r14b:$PATH
export TMPDIR=C:/cygwin/tmp
```


## Acknowledgements

Inspired by: [openssl-android][openssl-android] and [FFmpeg-Android][FFmpeg-Android].


<!-- external links -->
[openssl-android]:https://github.com/guardianproject/openssl-android
[FFmpeg-Android]:https://github.com/OnlyInAmerica/FFmpeg-Android
[android-ndk]:https://developer.android.com/tools/sdk/ndk/index.html
[cURL]:http://curl.haxx.se/
[pkg-config]:http://www.freedesktop.org/wiki/Software/pkg-config/
