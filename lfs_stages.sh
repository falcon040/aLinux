# 09/2015 M.Roller

# Wo befindet sich das LFS 
export LFS=/lfs

# parallel build on multicore machines
J=5

# "sandybridge"	
#  Intel Sandy Bridge CPU with 64-bit extensions, 
#  MMX, SSE, SSE2, SSE3, SSSE3, SSE4.1,
#  SSE4.2, POPCNT, AVX, AES and PCLMUL instruction set support.

# "ivybridge"
#  Intel Ivy Bridge CPU with 64-bit extensions, 
#  MMX, SSE, SSE2, SSE3, SSSE3, SSE4.1,
#  SSE4.2, POPCNT, AVX, AES, PCLMUL, FSGSBASE, RDRND and F16C instruction set support.

# "haswell"
#  Intel Haswell CPU with 64-bit extensions, 
#  MOVBE, MMX, SSE, SSE2, SSE3, SSSE3,
#  SSE4.1, SSE4.2, POPCNT, AVX, AVX2, AES, PCLMUL, FSGSBASE, RDRND, FMA, BMI, BMI2 and
#  F16C instruction set support.                                         
                                         
ARCH="ivybridge"
LFSCFLAGS="-O2 -s -march=$ARCH -pipe "

# https://ftp.gnu.org/gnu
BINUTILS="binutils-2.25.1.tar.bz2"
GCC="gcc-5.2.0.tar.bz2"
MPFR="mpfr-3.1.3.tar.bz2"
GMP="gmp-6.0.0a.tar.xz"
MPC="mpc-1.0.3.tar.gz"
LINUX="linux-4.2.2.tar.xz"
GLIBC="glibc-2.22.tar.bz2"
TCL="tcl8.6.4-src.tar.gz"
EXPECT="expect5.45.tar.gz"
DEJAGNU="dejagnu-1.5.3.tar.gz"
ZLIB="zlib-1.2.8.tar.xz"
NCURSES="ncurses-6.0.tar.gz"
ATTR="attr-2.4.47.src.tar.gz"
BASH="bash-4.3.30.tar.gz"
BZIP2="bzip2-1.0.6.tar.gz"
COREUTILS="coreutils-8.24.tar.xz"
DIFFUTILS="diffutils-3.3.tar.xz"
FILE="file-5.24.tar.gz"
FINDUTILS="findutils-4.4.2.tar.gz"
GAWK="gawk-4.1.3.tar.xz"
GETTEXT="gettext-0.19.6.tar.xz"
GREP="grep-2.21.tar.xz"
GZIP="gzip-1.6.tar.xz"
M4="m4-1.4.17.tar.xz"
MAKE="make-4.1.tar.bz2"
PATCH="patch-2.7.5.tar.xz"
PERL="perl-5.22.0.tar.bz2"
SED="sed-4.2.2.tar.bz2"
TAR="tar-1.28.tar.xz"
TEXINFO="texinfo-6.0.tar.xz"
E2FSPROGS="e2fsprogs-1.42.13.tar.gz"
UTILLINUXNG="util-linux-2.27.tar.xz"
XZ="xz-5.2.1.tar.xz"
GDBM="gdbm-1.11.tar.gz"
BISON="bison-3.0.4.tar.xz"
PROCPS="procps-ng-3.3.11.tar.xz"
LIBTOOL="libtool-2.4.6.tar.xz"
READLINE="readline-6.3.tar.gz"
AUTOCONF="autoconf-2.69.tar.xz"
AUTOMAKE="automake-1.15.tar.xz"
FLEX="flex-2.5.39.tar.xz"
GROFF="groff-1.22.3.tar.gz"
IPROUTE="iproute2-4.2.0.tar.xz"
INETUTILS="inetutils-1.9.4.tar.xz"
PKGCONFIG="pkg-config-0.28.tar.gz"
CHECK="check-0.10.0.tar.gz"
KBD="kbd-2.0.3.tar.xz"
LESS="less-458.tar.gz"
LIBPIPELINE="libpipeline-1.4.1.tar.gz"
MANDB="man-db-2.7.2.tar.xz"
KMOD="kmod-21.tar.xz"
PSMISC="psmisc-22.21.tar.gz"
SHADOW="shadow-4.2.1.tar.xz"
SYSKLOGD="sysklogd-1.5.1.tar.gz"
SYSVINIT="sysvinit-2.88dsf.tar.bz2"
VIM="vim-7.4.tar.bz2"
BC="bc-1.06.95.tar.bz2"
GPERF="gperf-3.0.4.tar.gz"
EUDEV="eudev-3.1.2.tar.gz"

### ---------------------------------------------------------------------------------------------------

umask 022
LC_ALL=POSIX
CC="gcc -s "
CFLAGS=""
CXXFLAGS=""
PATH=/tools/bin:/bin:/usr/bin
export LFS LC_ALL PATH CFLAGS CXXFLAGS
# stop on any error
set -e

if [ $# = 0 ]; then
        echo "Usage: $0 stage0"
        exit
fi

if test $1 = stage0
then
echo ""
echo "!!!!!!!!!!! Execute at bash: !!!!!!!!!!!!!!"
echo "declare -x PATH=/tools/bin:/bin:/usr/bin"
echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"

echo " "
echo "Start next stage1"
echo " "
if test -d $LFS/tools
then
echo "okay... "
else
mkdir -v $LFS/tools
fi
if test -L /tools
then
echo "okay... "
else
ln -sv $LFS/tools /
fi
fi

 


if test $1 = stage1 
then
# Nur ein lib Verzeichniss benutzen !
mkdir /tools/lib
ln -s /tools/lib /tools/lib64

tar xvfj SOURCE/$BINUTILS
cd binutils-*
mkdir -v build1
cd build1
../configure --prefix=/tools --disable-werror --disable-nls --with-sysroot=$LFS &&
make configure-host &&
make -j $J &&
make install
make -C ld clean
make -C ld LIB_PATH=/tools/lib
cp -v ld/ld-new /tools/bin
fi

if test $1 = stage2 
then
tar xvfj SOURCE/$GCC
tar xvfj SOURCE/$MPFR
tar xvf  SOURCE/$GMP
tar xvfz SOURCE/$MPC
cd gcc-*
mv ../mpfr-* mpfr
mv ../gmp-* gmp
mv ../mpc-* mpc

mkdir -v build1
cd build1
../configure --prefix=/tools --disable-libmudflap --disable-libssp --disable-libgomp \
    --libexecdir=/tools/lib --disable-multilib \
    --with-local-prefix=/tools --disable-nls --enable-shared --enable-languages=c &&
make -j $J &&
make install
ln -vs gcc /tools/bin/cc
fi

if test $1 = stage3 
then
tar xvf SOURCE/$LINUX
cd linux-*
make mrproper &&
make headers_check &&
make INSTALL_HDR_PATH=dest headers_install
cp -rv dest/include/* /tools/include
fi

if test $1 = stage4 
then
tar xvf SOURCE/$GLIBC
cd glibc-*
mkdir -v glibc-build
cd glibc-build
#ThOe
echo "CFLAGS += -march=$ARCH -O2 " > configparms
../configure --prefix=/tools \
    --disable-profile --enable-add-ons \
    --enable-kernel=2.6.32 --with-binutils=/tools/bin \
    --without-gd --with-headers=/tools/include \
    --without-selinux &&
make -j $J &&
mkdir -v /tools/etc
touch /tools/etc/ld.so.conf
make install

mv -v /tools/bin/{ld,ld-old}
mv -v /tools/$(gcc -dumpmachine)/bin/{ld,ld-old}
mv -v /tools/bin/{ld-new,ld}
ln -sv /tools/bin/ld /tools/$(gcc -dumpmachine)/bin/ld

# Hier den richtigen Link angeben welcher linker benutzt wird !!! checken !!!
ln -sv  /tools/lib/ld-2.22.so /tools/lib/ld-linux.so.2
fi


if test $1 = stage5 
then
SPECFILE=`dirname $(gcc -print-libgcc-file-name)`/specs 
gcc -dumpspecs > $SPECFILE 
sed -i 's@:/lib64/ld-linux-x86-64.so.2@:/tools/lib/ld-linux.so.2@g' $SPECFILE
sed -i 's@:/tools/lib64/ld-linux-x86-64.so.2@:/tools/lib/ld-linux.so.2@g' $SPECFILE
sed -i 's@:/lib/ld-linux.so.2@:/tools/lib/ld-linux.so.2@g' $SPECFILE
unset SPECFILE

GCC_INCLUDEDIR=`dirname $(gcc -print-libgcc-file-name)`/include &&
find ${GCC_INCLUDEDIR}/* -maxdepth 0 -xtype d -exec rm -rvf '{}' \; &&
rm -vf `grep -l "DO NOT EDIT THIS FILE" ${GCC_INCLUDEDIR}/*` &&
unset GCC_INCLUDEDIR
echo ""
echo "Ausgabe muss sein :"
echo " [Requesting program interpreter: /tools/lib/ld-linux.so.2] "
echo "-------------------------------------"
echo 'int main(){}' > dummy.c
cc dummy.c
readelf -l a.out | grep ': /tools'
rm a.out dummy.c
fi

if test $1 = stage6
then
tar xvf SOURCE/$ZLIB
cd zlib-*
./configure --prefix=/tools --shared --libdir=/tools/lib
make
make install
fi

if test $1 = stage7 
then
tar xvf SOURCE/$TCL
cd  tcl*/unix
./configure --prefix=/tools
make -j $J
make install
make install-private-headers
ln -sv tclsh8.6 /tools/bin/tclsh
fi

if test $1 = stage8
then
tar xvfz SOURCE/$EXPECT
cd expect*
./configure --prefix=/tools --with-tcl=/tools/lib \
  --with-tclinclude=/tools/include --with-x=no &&
make -j $J
make SCRIPTS="" install
fi

if test $1 = stage9
then
tar xvfz SOURCE/$DEJAGNU
cd dejagnu-*
./configure --prefix=/tools &&
make install
fi

if test $1 = stage10
then
rm -rf gcc-*
tar xvfj SOURCE/$GCC
tar xvfj SOURCE/$MPFR
tar xvf  SOURCE/$GMP
tar xvfz SOURCE/$MPC
cd gcc-*
mv ../mpfr-* mpfr
mv ../gmp-* gmp
mv ../mpc-* mpc

cp gcc/Makefile.in gcc/Makefile.in.orig 
sed 's@\./fixinc\.sh@-c true@' gcc/Makefile.in.orig > gcc/Makefile.in
cp gcc/Makefile.in gcc/Makefile.in.tmp 
sed 's/^XCFLAGS =$/& -fomit-frame-pointer/' gcc/Makefile.in.tmp > gcc/Makefile.in

for file in $(find gcc/config -name linux64.h -o -name linux.h)
do
  cp -uv $file{,.orig}
  sed -e 's@/lib\(64\)\?\(32\)\?/ld@/tools&@g' -e 's@/usr@/tools@g' $file.orig > $file
  echo '
  #undef STANDARD_STARTFILE_PREFIX_1
  #undef STANDARD_STARTFILE_PREFIX_2
  #define STANDARD_STARTFILE_PREFIX_1 "/tools/lib/"
  #define STANDARD_STARTFILE_PREFIX_2 ""' >> $file
  touch $file.orig
done

mkdir build2
cd build2
../configure --prefix=/tools \
    --with-local-prefix=/tools --enable-clocale=gnu \
    --enable-shared --enable-threads=posix \
    --enable-__cxa_atexit --enable-languages=c,c++ \
    --disable-libstdcxx-pch --disable-multilib &&
make -j $J &&
make install

echo ""
echo "!!! STAGE5 wird neu gestartet !!!"
cd ../..
./lfs_stages.sh stage5
echo "Okay..."
echo "weiter gehts mit stage12 "
fi

#if test $1 = stage11 
#then
#tar xvf SOURCE/$ZLIB
#cd zlib-*
#./configure --prefix=/tools --shared --libdir=/tools/lib
#make
#make install
#fi

if test $1 = stage12
then
rm -rf zlib-*
cd binutils-*
mkdir -v build2
cd build2
../configure --prefix=/tools --disable-nls --with-lib-path=/tools/lib &&
make -j $J &&
make install
make -C ld clean
make -C ld LIB_PATH=/usr/lib:/lib
cp -v ld/ld-new /tools/bin
fi

if test $1 = stage13
then
tar xvfz SOURCE/$NCURSES
cd ncurses-*
sed -i s/mawk// configure
./configure --prefix=/tools --with-shared --without-debug --without-ada --enable-overwrite --without-gpm
make -j $J &&
make install
fi

if test $1 = stage14
then
tar xvfz SOURCE/$BASH
cd bash-*
./configure --prefix=/tools --without-bash-malloc &&
make -j $J
make install
ln -vs bash /tools/bin/sh
fi

if test $1 = stage15
then
tar xvfz SOURCE/$BZIP2
cd bzip2-*
sed -i 's@CFLAGS=-Wall -Winline -O @CFLAGS=-Wall -Winline -O3 @g' Makefile
make -j $J &&
make PREFIX=/tools install
fi

if test $1 = stage16
then
tar xvf SOURCE/$COREUTILS
cd coreutils-*
FORCE_UNSAFE_CONFIGURE=1 ./configure --prefix=/tools --enable-install-program=hostname
make -j $J &&
make install
#cp -v src/su /tools/bin/su-tools
fi

if test $1 = stage17
then
tar xvf SOURCE/$DIFFUTILS
cd diffutils-*
./configure --prefix=/tools
make -j $J &&
make install
fi

if test $1 = stage18
then
tar xvf SOURCE/$FINDUTILS
cd findutils-*
./configure --prefix=/tools
make -j $J &&
make install
fi

if test $1 = stage19
then
tar xvf SOURCE/$FILE
cd file-*
./configure --prefix=/tools
make -j $J &&
make install
fi

if test $1 = stage20
then
tar xvf SOURCE/$GAWK
cd gawk-*
./configure --prefix=/tools
make -j $J &&
make install
fi

if test $1 = stage21
then
tar xvf SOURCE/$GETTEXT
cd gettext-*/gettext-tools
EMACS="no" ./configure --prefix=/tools --disable-shared
make -C gnulib-lib
make -C intl pluralx.c
make -C src msgfmt
make -C src msgmerge
make -C src xgettext
cp -v src/{msgfmt,msgmerge,xgettext} /tools/bin
fi

if test $1 = stage22
then
tar xvf SOURCE/$GREP
cd grep-*
./configure --prefix=/tools 
make -j $J &&
make install
fi

if test $1 = stage23
then
tar xvf SOURCE/$GZIP
cd gzip-*
CFLAGS="-O3 " ./configure --prefix=/tools
make -j $J &&
make install
fi

if test $1 = stage24
then
tar xvf SOURCE/$M4
cd m4-*
./configure --prefix=/tools
make -j $J &&
make install
fi

if test $1 = stage25
then
tar xvf SOURCE/$MAKE
cd make-*
CFLAGS="-O2 " ./configure --prefix=/tools --without-guile
make -j $J &&
make install
fi

if test $1 = stage26
then
tar xvf SOURCE/$PATCH
cd patch-*
./configure --prefix=/tools
make -j $J &&
make install
fi

if test $1 = stage27
then
tar xvf SOURCE/$PERL
cd perl-*
sh Configure -des -Dprefix=/tools -Dlibs=-lm
make -j $J
cp -v perl cpan/podlators/pod2man /tools/bin
mkdir -pv /tools/lib/perl5/5.22.0
cp -Rv lib/* /tools/lib/perl5/5.22.0
fi


if test $1 = stage28
then
tar xvf SOURCE/$SED
cd sed-*
./configure --prefix=/tools
make -j $J &&
make install
fi 

if test $1 = stage29
then
tar xvf SOURCE/$TAR
cd tar-*
FORCE_UNSAFE_CONFIGURE=1 ./configure --prefix=/tools
make -j $J &&
make install
fi 

if test $1 = stage30
then
tar xvf SOURCE/$TEXINFO
cd texinfo-*
./configure --prefix=/tools
make -j $J &&
make install
fi

if test $1 = stage31
then
tar xvf SOURCE/$UTILLINUXNG
cd util-linux-*
./configure --prefix=/tools --without-python --disable-makeinstall-chown --without-systemdsystemunitdir PKG_CONFIG=""
make -j $J &&
make install
fi

if test $1 = stage32
then
tar xvf SOURCE/$XZ
cd xz-*
CFLAGS="-O2 " ./configure --prefix=/tools
make -j $J &&
make install
fi

if test $1 = stage33
then
rm -rf /tools/{,share}/{info,man,doc}
chown -R root:root /tools
rm -rf  file-* bash-* binutils-* bzip2-* coreutils-* dejagnu-* diffutils-* expect-* findutils-* gawk-* gcc-* gettext-* glibc-* grep-* gzip-* linux-* m4-* make-* ncurses-* patch-* perl-* sed-* tar-* tcl8* texinfo-* util-linux-* e2fsprog* expect* xz-*
echo "/tools erfolgreich erstellt! Es wäre klug vom tools Verzeichniss jetzt eine Kopie zu machen!"
fi


declare -x CFLAGS=$LFSCFLAGS
declare -x CXXFLAGS=$CFLAGS
export CFLAGS CXXFLAGS


if test $1 = stage34
then
mkdir -pv $LFS/{dev,proc,sys,dev/shm,dev/pts}
mknod -m 600 $LFS/dev/console c 5 1
mknod -m 666 $LFS/dev/null c 1 3
fi

if test $1 = stage35
then
#mount --bind /dev $LFS/dev
# /dev/pts wird wegen eines segfault-bug in make benoetigt
mount -vt devpts devpts $LFS/dev/pts
mount -vt tmpfs shm $LFS/dev/shm
mount -vt proc proc $LFS/proc
mount -vt sysfs sysfs $LFS/sys
fi

if test $1 = stage36
then
chroot "/lfs" /tools/bin/env -i HOME=/root TERM="$TERM" PS1='\u:\w\$ ' \
PATH=/bin:/usr/bin:/sbin:/usr/sbin:/tools/bin /tools/bin/bash --login +h
fi

declare -x PATH=/bin:/usr/bin:/sbin:/usr/sbin:/tools/bin
export PATH

if test $1 = stage37
then
cd /
chown -R 0:0 /tools
mkdir -p /{bin,boot,etc,home,lib,mnt,proc} &&
mkdir -p /{root,sbin,tmp,usr/local,var,opt} &&
mkdir /usr/{bin,etc,include,lib,sbin,share,src}
ln -s share/{man,doc,info} /usr
mkdir /usr/share/{dict,doc,info,locale,man}
mkdir /usr/share/{nls,misc,terminfo,zoneinfo}
mkdir /usr/share/man/man{1,2,3,4,5,6,7,8}
mkdir /usr/lib/locale
mkdir /var/{lock,log,mail,run,spool} &&
ln -s /tmp /var/tmp 
ln -s /tmp /usr/tmp
ln -s /lib /lib64
ln -s /usr/lib /usr/lib64 
chmod 0750 /root &&
chmod 1777 /tmp 
ln -s /tools/bin/{bash,cat,pwd,stty} /bin
ln -s /tools/bin/perl /usr/bin
ln -sv /tools/lib/libgcc_s.so{,.1} /usr/lib
ln -s bash /bin/sh
ln -s /var/run /run
touch /etc/mtab

cat > /etc/passwd << "EOF"
root:x:0:0:root:/root:/bin/bash
bin:x:1:1:bin:/bin:/bin/bash
EOF

cat > /etc/group << "EOF"
root:x:0:
bin:x:1:
sys:x:2:
kmem:x:3:
tty:x:4:
tape:x:5:
daemon:x:6:
floppy:x:7:
disk:x:8:
lp:x:9:
dialout:x:10:
audio:x:11:
video:x:12:
utmp:x:13:
usb:x:14:
cdrom:x:15:
sudo:x:27:
input:x:28:
users:x:100:
EOF
fi


if test $1 = stage38
then
cp -a /EXTRA/etc/* /etc
# /etc/profiles darf noch nicht da sein !
# erst wenn wir mit dem /tools dir fertig sind
# deshalb wird es umbenannt nach /etc/profiles.ok
mv /etc/profile /etc/profile.ok
echo "export CFLAGS=\"$LFSCFLAGS \"" >> /etc/profile.ok
echo "export CXXFLAGS=\"$CFLAGS \"" >> /etc/profile.ok
chmod -R 644 /etc/*
chown -R root:root /etc/*
chmod 744 /etc/rc.d/*

# Create enought devices to boot !
cd /dev
#mknod -m 600 console c 5 1 #gibts schon
#mknod -m 666 null c 1 3    #gibts schon
mknod -m 666 zero c 1 5
mknod -m 666 tty c 5 0
mknod -m 666 tty0 c 4 0
chown root:tty tty
chown root:tty tty0

mknod -m 660 stdin c 136 3
mknod -m 660 stdout c 136 3
mknod -m 660 stderr c 136 3

mknod -m 660 hda  b 3 0
mknod -m 660 hda1 b 3 1
mknod -m 660 hda2 b 3 2
mknod -m 660 hda3 b 3 3
mknod -m 660 hda4 b 3 4
mknod -m 660 sda  b 8 0
mknod -m 660 sda1 b 8 1
mknod -m 660 sda2 b 8 2
mknod -m 660 sda3 b 8 3
mknod -m 660 sda4 b 8 4
mknod -m 660 sdb  b 8 16
mknod -m 660 sdb1 b 8 17
mknod -m 660 sdb2 b 8 18
mknod -m 660 sdb3 b 8 19
mknod -m 660 sdb4 b 8 20
chown root:disk sd*
chown root:disk hd*
cd ..

echo "Welcome to \s \r \m gcc 5.2.0 (\l)" > /etc/issue

touch /var/run/utmp /var/log/{btmp,lastlog,wtmp} &&
chmod 644 /var/run/utmp /var/log/{btmp,lastlog,wtmp}

echo " "
echo "Start next stage39"
exec /tools/bin/bash --login +h
fi


if test $1 = stage39
then
tar xvf SOURCE/$LINUX 
cd linux-*

make mrproper
make headers_check
make INSTALL_HDR_PATH=dest headers_install
cp -rv dest/include/* /usr/include

chown -Rv root:root /usr/include/{asm,linux}
find /usr/include/{asm,linux} -type d -exec chmod -v 755 {} \;
find /usr/include/{asm,linux} -type f -exec chmod -v 644 {} \;
cd ..
mv linux-* /usr/src/
fi

#if test $1 = stage40
#then
#tar xvf SOURCE/$MANPAGES
#cd man-pages-*
#make install
#fi

if test $1 = stage41
then
tar xvfj SOURCE/$GLIBC
cd glibc-2*
mkdir -v build && cd build
touch /etc/ld.so.conf
CXX="gcc $LFSCFLAGS " CC="gcc $LFSCFLAGS "  ../configure --prefix=/usr --disable-profile --enable-kernel=2.6.32 --enable-obsolete-rpc
make -j $J && make install
localedef -i de_DE -f ISO-8859-1 de_DE
localedef -i de_DE@euro -f ISO-8859-15 de_DE@euro
localedef -i de_DE -f UTF-8 de_DE.UTF-8
localedef -i en_US -f ISO-8859-1 en_US
localedef -i en_US -f UTF-8 en_US.UTF-8
#cp --remove-destination /usr/share/zoneinfo/Europe/Berlin /etc/localtime
#cp -v ../glibc-2.22/nscd/nscd.conf /etc/nscd.conf
#mkdir -pv /var/cache/nscd
cat > /etc/ld.so.conf << "EOF"
/usr/local/lib
/usr/X11/lib
/opt/kde/install/lib
EOF
fi


if test $1 = stage42
then
# checken ob specs file richtig ist !!!
mv -v /tools/bin/{ld,ld-old}
mv -v /tools/$(gcc -dumpmachine)/bin/{ld,ld-old}
mv -v /tools/bin/{ld-new,ld}
ln -sv /tools/bin/ld /tools/$(gcc -dumpmachine)/bin/ld

gcc -dumpspecs | \
perl -p -e 's@/tools/lib/ld@/lib/ld@g;' \
     -e 's@\*startfile_prefix_spec:\n@$_/usr/lib/ @g;' > \
     `dirname $(gcc --print-libgcc-file-name)`/specs
#gcc -dumpspecs > $SPECFILE 

SPECFILE=`dirname $(gcc -print-libgcc-file-name)`/specs 
gcc -dumpspecs > $SPECFILE 
sed -i 's@:/tools/lib/ld-linux.so.2@:/lib/ld-linux-x86-64.so.2@g' $SPECFILE
sed -i 's@:/tools/lib64/ld-linux-x86-64.so.2@:/lib/ld-linux-x86-64.so.2@g' $SPECFILE
unset SPECFILE
echo ""
echo "Ausgabe sollte sein: [Requesting program interpreter: /lib/ld-linux-x86-64.so.2]"
echo 'main(){}' > dummy.c
cc dummy.c -Wl,--verbose &> dummy.log
readelf -l a.out | grep ': /lib'
fi

if test $1 = stage43
then
tar xvf SOURCE/$ZLIB
cd zlib-*
CFLAGS="$CFLAGS -fpic " ./configure --prefix=/usr --shared 
make
make install
# libz.a im tools Verzeichniss ersetzen!
cp /usr/lib/libz.a /tools/lib/libz.a
mv -v /usr/lib/libz.so.* /lib
ln -sfv ../../lib/$(readlink /usr/lib/libz.so) /usr/lib/libz.so
fi

if test $1 = stage44
then
tar xvf SOURCE/$FILE
cd file-*
./configure --prefix=/usr && make -j $J && make install
fi

if test $1 = stage45
then
tar xvf SOURCE/$BINUTILS
cd binutils-*
mkdir -v build3
cd build3
../configure --prefix=/usr --enable-shared &&
make tooldir=/usr -j $J &&
make tooldir=/usr install
fi

if test $1 = stage46
then
tar xvf SOURCE/$GCC
tar xvf SOURCE/$MPFR
tar xvf SOURCE/$GMP
tar xvf SOURCE/$MPC
cd gcc-*
mv ../mpfr-* mpfr
mv ../gmp-* gmp
mv ../mpc-* mpc

## bei >= glibc 2.6.1.
#sed -i 's/install_to_$(INSTALL_DEST) //' libiberty/Makefile.in
##sed -i 's/^XCFLAGS =$/& -fomit-frame-pointer/' gcc/Makefile.in
#sed -i 's@\./fixinc\.sh@-c true@' gcc/Makefile.in

mkdir build2
cd build2
SED=sed ../configure --prefix=/usr --enable-languages=c,c++ --disable-multilib --disable-bootstrap --with-system-zlib &&
# --enable-clocale=gnu --enable-__cxa_atexit  --enable-shared --enable-threads=posix --libexecdir=/usr/lib
make -j $J &&
make install

ln -sv gcc /usr/bin/cc

# SPECIAL Mirko ... Noch testen
# wenn das nicht da ist, dann wird default /lib64/ld-linux-x86-64.so.2 als
# 64Bit linker benutzt. Also mal ausprobieren, wer braucht noch 32Bit ?
#SPECFILE=`dirname $(gcc -print-libgcc-file-name)`/specs
#gcc -dumpspecs > $SPECFILE
#sed -i 's@:/lib64/ld-linux-x86-64.so.2@:/lib/ld-linux.so.2@g' $SPECFILE
#unset SPECFILE
# ENDE Special, deleten fals probs mit /lib linker
#echo "Ausgabe muss sein: [Requesting program interpreter: /lib/ld-linux.so.2]"

echo "Ausgabe muss sein: [Requesting program interpreter: /lib64/ld-linux-x86-64.so.2]"
echo 'main(){}' > dummy.c
cc dummy.c -Wl,--verbose &> dummy.log
readelf -l a.out | grep ': /lib'
rm -v dummy.c a.out dummy.log
fi


if test $1 = stage47
then
tar xvf  SOURCE/$GDBM
cd gdbm-*
./configure --prefix=/usr --disable-static --enable-libgdbm-compat
make && make install
fi

if test $1 = stage48
then
tar xvf SOURCE/$COREUTILS
cd coreutils-*
FORCE_UNSAFE_CONFIGURE=1 ./configure --prefix=/usr --enable-no-install-program=kill,uptime
make -j $J && make install
#hostname entfernt!
mv -v /usr/bin/{cat,touch,chgrp,chmod,chown,cp,date,dd,df,echo} /bin
mv -v /usr/bin/{false,ln,ls,mkdir,mknod,pwd,rm} /bin
mv -v /usr/bin/{rmdir,stty,sync,true,uname} /bin
mv -v /usr/bin/chroot /usr/sbin
mv -v /usr/bin/{head,sleep,mv,nice} /bin
fi

if test $1 = stage49
then
tar xvf SOURCE/$M4
cd m4-*
./configure --prefix=/usr 
make -j $J && make install
fi

if test $1 = stage50
then
tar xvf  SOURCE/$BISON
cd bison-*
./configure --prefix=/usr
make -j $J && make install
fi

if test $1 = stage51
then
tar xvf  SOURCE/$NCURSES
cd ncurses-*
sed -i s/mawk// configure
# /usr/lib/libncursesw.so.6.0
./configure --prefix=/usr --with-shared --without-debug --enable-widec --without-ada
make -j $J && make install
make clean
# /usr/lib/libncurses.so.6.0
./configure --prefix=/usr --with-shared --without-debug --without-ada
make -j $J && make install

echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
echo "JETZT stage51attr starten !!!!!"
echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
fi

if test $1 = stage51attr
then
tar xvf SOURCE/$ATTR
cd attr-*
sed -i -e 's|/@pkg_name@|&-@pkg_version@|' include/builddefs.in
sed -i -e "/SUBDIRS/s|man2||" man/Makefile
./configure --prefix=/usr --bindir=/bin --disable-static
make && make install install-dev install-lib
chmod -v 755 /usr/lib/libattr.so
mv -v /usr/lib/libattr.so.* /lib
ln -sfv ../../lib/$(readlink /usr/lib/libattr.so) /usr/lib/libattr.so
echo "weiter gehts mit stage52 ..."
fi

if test $1 = stage52
then
tar xvf  SOURCE/$PROCPS
cd procps-*
./configure --prefix=/usr --exec-prefix=  --libdir=/usr/lib  \
--disable-static 
make -j $J && make install
fi

if test $1 = stage53
then
tar xvf SOURCE/$SED
cd sed-*
./configure --prefix=/usr --bindir=/bin --enable-html
make -j $J && make install
fi

if test $1 = stage54
then
tar xvf SOURCE/$LIBTOOL
cd libtool-*
./configure --prefix=/usr
make -j $J && make install
fi

if test $1 = stage55
then
tar xvf SOURCE/$PERL
cd perl-*
echo "127.0.0.1 localhost $(hostname)" > /etc/hosts
BUILD_ZLIB=False BUILD_BZIP2=0 sh Configure -des -Dprefix=/usr \
                  -Dvendorprefix=/usr           \
                  -Dman1dir=/usr/share/man/man1 \
                  -Dman3dir=/usr/share/man/man3 \
                  -Dpager="/usr/bin/less -isR"  \
                  -Duseshrplib
make -j $J && make install
fi

if test $1 = stage56
then
tar xvfz SOURCE/$READLINE
cd readline-*
sed -i '/MV.*old/d' Makefile.in
sed -i '/{OLDSUFF}/c:' support/shlib-install
./configure --prefix=/usr --libdir=/lib
make SHLIB_LIBS=-lncurses
make install
chmod -v 755 /lib/lib{readline,history}.so*
fi

if test $1 = stage57
then
tar xvf SOURCE/$ZLIB
cd zlib-*
CC="gcc -fPIC " ./configure --prefix=/usr --shared --libdir=/lib
make && make install
rm -v /lib/libz.so
ln -sfv /lib/libz.so.1.2.8 /usr/lib/libz.so
make clean
CC="gcc -fPIC " ./configure --prefix=/usr
make && make install
chmod -v 644 /usr/lib/libz.a
fi

if test $1 = stage58
then
tar xvf SOURCE/$AUTOCONF 
cd autoconf-*
./configure --prefix=/usr
make && make install
fi

if test $1 = stage59
then
tar xvf SOURCE/$AUTOMAKE
cd automake-*
./configure --prefix=/usr
make && make install
fi

if test $1 = stage60
then
tar xvfz SOURCE/$BASH
cd bash-*
./configure --prefix=/usr --bindir=/bin --without-bash-malloc --with-installed-readline
make -j $J && make install
cd /
echo ""
echo "start stage61"
exec /bin/bash --login +h
fi

if test $1 = stage61
then
tar xvf SOURCE/$BZIP2
cd bzip2-*
make -f Makefile-libbz2_so
make clean
make
make PREFIX=/usr install
cp -v bzip2-shared /bin/bzip2
cp -av libbz2.so* /lib
ln -sv ../../lib/libbz2.so.1.0 /usr/lib/libbz2.so
rm -v /usr/bin/{bunzip2,bzcat,bzip2}
ln -sv bzip2 /bin/bunzip2
ln -sv bzip2 /bin/bzcat
fi

if test $1 = stage62
then
tar xvf SOURCE/$DIFFUTILS
cd diffutils-*
touch man/diff.1
./configure --prefix=/usr
make -j $J &&
make install
fi

if test $1 = stage63
then
tar xvfz SOURCE/$E2FSPROGS
cd e2fsprogs-*
#sed -i -e 's@/bin/rm@/tools&@' lib/blkid/test_probe.in
mkdir -v build
cd build
../configure --prefix=/usr --with-root-prefix="" \
    --bindir=/bin --enable-elf-shlibs 
make -j $J &&
make install
make install-libs
fi

#if test $1 = stage57
#then
#tar xvfz SOURCE/$FILE
#cd file-*
#./configure --prefix=/usr
#make -j $J &&
#make install
#fi

if test $1 = stage64
then
tar xvfz SOURCE/$FINDUTILS
cd findutils-*
./configure --prefix=/usr --libexecdir=/usr/lib/findutils \
    --localstatedir=/var/lib/locate
make -j $J &&
make install
fi


if test $1 = stage65
then
tar xvf SOURCE/$FLEX
cd flex-*
sed -i -e '/test-bison/d' tests/Makefile.in
./configure --prefix=/usr --docdir=/usr/share/doc/flex-2.5.39
make -j $J && make install
ln -sv flex /usr/bin/lex
fi


if test $1 = stage66
then
tar xvf SOURCE/$GAWK
cd gawk-*
./configure --prefix=/usr 
make -j $J && make install
fi


if test $1 = stage67
then
tar xvf SOURCE/$GETTEXT    
cd gettext-*
./configure --prefix=/usr
make &&
make install
fi


if test $1 = stage68
then
tar xvf SOURCE/$GREP
cd grep-*
# bugfix for 2.21
sed -i -e '/tp++/a  if (ep <= tp) break;' src/kwset.c
./configure --prefix=/usr --bindir=/bin 
make -j $J &&
make install
fi


if test $1 = stage69
then
tar xvfz SOURCE/$GROFF
cd groff-*
PAGE=A4 ./configure --prefix=/usr
make && make install
fi

if test $1 = stage70
then
tar xvf SOURCE/$GZIP
cd gzip-*
./configure --prefix=/usr --bindir=/bin
make -j $J && make install
mv -v /bin/{gzexe,uncompress,zcmp,zdiff,zegrep} /usr/bin
mv -v /bin/{zfgrep,zforce,zgrep,zless,zmore,znew} /usr/bin
fi

if test $1 = stage71
then
tar xvf SOURCE/$INETUTILS
cd inetutils-*
./configure --prefix=/usr --localstatedir=/var --disable-logger --disable-whois --disable-rcp --disable-rexec --disable-rlogin --disable-rsh --disable-servers
make -j $J && make install
mv -v /usr/bin/{hostname,ping,ping6,traceroute} /bin
mv -v /usr/bin/ifconfig /sbin
fi

if test $1 = stage72
then
tar xvf SOURCE/$IPROUTE
cd iproute*
sed -i '/^TARGETS/s@arpd@@g' misc/Makefile
sed -i /ARPD/d Makefile
sed -i 's/arpd.8//' man/man8/Makefile
make 
make DOCDIR=/usr/share/doc/iproute2-4.2.0 install
fi

if test $1 = stage73
then
tar xvf SOURCE/$PKGCONFIG
cd pkg-config*
./configure --prefix=/usr --with-internal-glib --disable-host-tool --docdir=/usr/share/doc/pkg-config-0.28
make && make install
fi

# Na Toll, kbd benötigt unbedingt PKGCONFIG und CHECK 
if test $1 = stage74
then
tar xvf SOURCE/$CHECK
cd check-*
./configure --prefix=/usr
make && make install
fi

if test $1 = stage75
then
tar xvf SOURCE/$KBD
cd kbd*
patch -Np1 -i ../SOURCE/kbd-2.0.3-backspace-1.patch
sed -i 's/\(RESIZECONS_PROGS=\)yes/\1no/g' configure
sed -i 's/resizecons.8 //' docs/man/man8/Makefile.in
PKG_CONFIG_PATH=/tools/lib/pkgconfig ./configure --prefix=/usr --disable-vlock
make 
make install
#cd src
#cp setmetamode showconsolefont showkey unicode_start unicode_stop loadkeys openvt chvt kbdinfo setfont setkeycodes dumpkeys getkeycodes loadunimap  psfxtable  /usr/bin
fi

if test $1 = stage76
then
tar xvfz  SOURCE/$LESS
cd less*
./configure --prefix=/usr --sysconfdir=/etc
make -j $J && make install
fi

if test $1 = stage77
then
tar xvfj SOURCE/$MAKE
cd make-*
./configure --prefix=/usr
make -j $J && make install
fi

if test $1 = stage78
then
tar xvf SOURCE/$LIBPIPELINE
cd libpipeline-*
./configure --prefix=/usr
make -j $J && make install
fi

if test $1 = stage79
then
tar xvf SOURCE/$MANDB
cd man-db-*
./configure --prefix=/usr             \
 --docdir=/usr/share/doc/man-db-2.7.2 \
 --sysconfdir=/etc                    \
 --disable-setuid                     \
 --with-browser=/usr/bin/lynx         \
 --with-vgrind=/usr/bin/vgrind        \
 --with-grap=/usr/bin/grap
make && make install
fi

if test $1 = stage80
then
tar xvf SOURCE/$XZ
cd xz-*
./configure --prefix=/usr
make -j $J && make install
fi

if test $1 = stage81
then
tar xvf SOURCE/$KMOD
cd kmod-*
./configure --prefix=/usr --bindir=/bin --sysconfdir=/etc --with-rootlibdir=/lib --with-xz --with-zlib
make && make install
for target in depmod insmod lsmod modinfo modprobe rmmod; do
  ln -sv /bin/kmod /bin/$target
  done
  #ln -sv kmod /bin/lsmod
fi

if test $1 = stage82
then
tar xvf SOURCE/$PATCH
cd patch-*
./configure --prefix=/usr
make -j $J
make install
fi

if test $1 = stage83
then
tar xvf SOURCE/$PSMISC
cd psmisc-*
./configure --prefix=/usr 
make -j $J && make install
mv -v /usr/bin/fuser   /bin
mv -v /usr/bin/killall /bin
fi

if test $1 = stage84
then
tar xvf SOURCE/$SHADOW
cd shadow-*
sed -i 's/groups$(EXEEXT) //' src/Makefile.in
find man -name Makefile.in -exec sed -i 's/groups\.1 / /' {} \;
sed -i -e 's@#ENCRYPT_METHOD DES@ENCRYPT_METHOD SHA512@' \
       -e 's@/var/spool/mail@/var/mail@' etc/login.defs
sed -i 's/1000/999/' etc/useradd
./configure --sysconfdir=/etc --with-group-name-max-length=32
make && make install && mv -v /usr/bin/passwd /bin
fi

if test $1 = stage85
then
pwconv
#grpconv	Lassen wir normal !
fi

if test $1 = stage86
then
tar xvfz SOURCE/$SYSKLOGD
cd sysklogd-*
sed -i '/Error loading kernel symbols/{n;n;d}' ksym_mod.c
make && make BINDIR=/sbin install
fi

if test $1 = stage87
then
tar xvf SOURCE/$SYSVINIT
cd sysvinit-*
patch -Np1 -i ../SOURCE/sysvinit-2.88dsf-consolidated-1.patch
make -C src && make -C src install
fi

if test $1 = stage88
then
tar xvf SOURCE/$TAR
cd tar-*
FORCE_UNSAFE_CONFIGURE=1 ./configure --prefix=/usr --bindir=/bin --libexecdir=/usr/sbin
make
make install
fi

if test $1 = stage89
then
tar xvf SOURCE/$TEXINFO
cd texinfo-*
./configure --prefix=/usr
make && make install
fi

#if test $1 = stage90
#then
##cp -a BOOT_TOOLS/udev /etc/
#tar xvfj SOURCE/$UDEV
#cd udev-*
#install -dv /lib/{firmware,udev/devices/{pts,shm}}
#mknod -m0666           /lib/udev/devices/null c 1 3
#mknod -m0600           /lib/udev/devices/kmsg c 1 11
#ln -sv /proc/self/fd   /lib/udev/devices/fd
#ln -sv /proc/self/fd/0 /lib/udev/devices/stdin
#ln -sv /proc/self/fd/1 /lib/udev/devices/stdout
#ln -sv /proc/self/fd/2 /lib/udev/devices/stderr
#ln -sv /proc/kcore     /lib/udev/devices/core
##./configure --prefix=/usr --exec-prefix= --sysconfdir=/etc
#./configure --prefix=/usr \
#    --sysconfdir=/etc --sbindir=/sbin \
#    --with-rootlibdir=/lib --libexecdir=/lib/udev \
#    --docdir=/usr/share/doc/udev-166 \
#    --disable-extras --disable-introspection
#make && make install
##install -m644 -v rules/packages/64-*.rules /lib/udev/rules.d/
#fi


if test $1 = stage90
then
tar xvf SOURCE/$GPERF
cd gperf-*
./configure --prefix=/usr --docdir=/usr/share/doc/gperf-3.0.4
make && make install
fi

if test $1 = stage91
then
tar xvf SOURCE/$EUDEV
cd eudev-*
sed -r -i 's|/usr(/bin/test)|\1|' test/udev-test.pl
#cat > config.cache << "EOF"
#HAVE_BLKID=1
#BLKID_LIBS="-lblkid"
#BLKID_CFLAGS="-I/tools/include"
#EOF
./configure --prefix=/usr           \
--bindir=/sbin          \
--sbindir=/sbin         \
--libdir=/usr/lib       \
--sysconfdir=/etc       \
--libexecdir=/lib       \
--with-rootprefix=      \
--with-rootlibdir=/lib  \
--with-rootrundir=/var/run  \
--enable-split-usr      \
--enable-manpages       \
--enable-hwdb           \
--disable-introspection \
--disable-gudev         \
--disable-static        \
--config-cache          \
--disable-gtk-doc-html
make
mkdir -pv /lib/udev/rules.d
mkdir -pv /etc/udev/rules.d
make install
udevadm hwdb --update
fi

if test $1 = stage92
then
tar xvf SOURCE/$UTILLINUXNG
cd util-linux-*
./configure ADJTIME_PATH=/etc/adjtime   \
--docdir=/usr/share/doc/util-linux-2.27 \
--disable-chfn-chsh  \
--disable-login      \
--disable-nologin    \
--disable-su         \
--disable-setpriv    \
--disable-runuser    \
--disable-pylibmount \
--disable-static     \
--without-python     \
--without-systemd    \
--without-systemdsystemunitdir
make && make install
fi

if test $1 = stage93
then
tar xvfj SOURCE/$VIM
cd vim*
echo '#define SYS_VIMRC_FILE "/etc/vimrc"' >> src/feature.h
./configure --prefix=/usr 
make -j $J && make install
ln -sv vim /usr/bin/vi
ln -sv vim.1 /usr/share/man/man1/vi.1
ln -sv ../vim/vim74/doc /usr/share/doc/vim-7.4
fi

if test $1 = stage94
then
tar xvfj SOURCE/$BC
cd bc-*
./configure --prefix=/usr
make -j $J && make install
fi

if test $1 = stage95
then
tar xvf SOURCE/joe-*
cd joe-*
./configure --prefix=/usr 
make -j $J && make install
fi


if test $1 = stage96
then
echo " 3 x logout ausfuehren, bis nicht mehr in chroot, dann stage100"
fi


if test $1 = stage100
then
chroot $LFS /tools/bin/env -i \
    HOME=/root TERM=$TERM PS1='\u:\w\$ ' \
    PATH=/bin:/usr/bin:/sbin:/usr/sbin \
    /tools/bin/bash --login
fi

if test $1 = stage101
then
/tools/bin/find /{,usr/}{bin,lib,sbin} -type f \
  -exec /tools/bin/strip --strip-debug '{}' ';'
fi



# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
# Ab hier neuer Einstieg in chroot fuer blfs  !
# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

if test $1 = stage102
then
mv -v etc/profile.ok etc/profile
echo "enter: logout"
echo "dann stage103"
fi

if test $1 = stage103
then
chroot "$LFS" /usr/bin/env -i \
    HOME=/root TERM="$TERM" PS1='\u:\w\$ ' \
    PATH=/bin:/usr/bin:/sbin:/usr/sbin \
    /bin/bash --login
fi

if test $1 = stage104
then
rm -rf attr-* joe-* bc-* libpipeline-* kmod-* gperf-* eudev-* check-* xz-* pkg-config-* autoconf-* automake-* bash-* binutils-* bison-* bzip2-* coreutils-* db-* diffutils-* e2fsprogs-* file-* findutils-* flex-* gawk-* gettext-* glibc-* grep-* groff-* gzip-* inetutils-* iproute2-* kbd-* less-* libtool-* m4-* make-* man-db-2* man-pages-* mktemp-* module-init-tools-* ncurses-* patch-* perl-* procps-* psmisc-* readline-* sed-* shadow-* sysklogd-* sysvinit-* tar-* texinfo-* udev-* util-linux-* vim* zlib-* gcc-* dummy.c dummy.log a.out etc/default tmp/* iproute-*   gdbm-*  linux-2.* expect*
fi

if test $1 = stage105
then
cp -a  /EXTRA/lilo_static /boot/
chown -R root:root /boot
chown root:root /
chown root:root /etc/lilo.conf
chown root:root /etc/udev -R
fi

if test $1 = stage106
then
tar xvfz SOURCE/as86-0.16.19.tar.gz
cd as*
make
cp as86 /usr/sbin/
cd /
tar xvfz SOURCE/bin86-0.16.19.tar.gz
cd bin86*
sed -i 's@catimage@ @g' ld/Makefile
make
cp ld/ld86 /usr/sbin/
cd /
#http://lilo.alioth.debian.org/ftp/sources/
tar xvf SOURCE/lilo-24.1.tar.gz
cd lilo-*
sed -i -e 's@make -C images all@ @' Makefile
make all
cp src/lilo /usr/sbin/
fi

if test $1 = stage107
then
rm -rf as86-* bin86-* lilo-*
fi


if test $1 = stage108
then
#echo "bin:x:1:1:bin:/bin:/bin/bash" >> /etc/passwd
echo "lp:x:4:7:Printing daemon:/var/spool/lpd:/bin/bash" >> /etc/passwd
pwconv
fi

if test $1 = stage109
then
ln -s /usr/src/linux-* /usr/src/linux
cp EXTRA/.config /usr/src/linux/
cd /usr/src/linux/
make -j 4
make modules
make modules_install
cp arch/x86/boot/bzImage /boot/vmlinuz
fi


if test $1 = stage110
then
sed -i 's@: ${EGREP="/tools/bin/grep -E"}@: ${EGREP="/bin/grep -E"}@g' /usr/bin/libtoolize
sed -i 's@: ${FGREP="/tools/bin/grep -F"}@: ${FGREP="/bin/grep -F"}@g' /usr/bin/libtoolize
sed -i 's@: ${GREP="/tools/bin/grep"}@: ${GREP="/bin/grep"}@g' /usr/bin/libtoolize
fi

if test $1 = stage111
then
echo ""
echo "Nicht vergessen das ROOT Passwort jetzt zu setzen !!!  (passwd)"
echo ""
echo "LFS READY ... "
fi

# Chroot für wiedereinstieg von BLFS oder XORG
# Das vollwertige /dev wird dann benötigt
if test $1 = chroot
then
mount --bind /dev dev
./lfs_stages.sh stage35
./lfs_stages.sh stage103
fi
