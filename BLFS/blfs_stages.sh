
if [ $# = 0 ]; then
        echo "Usage: $0 start"
        echo "!!!!!!! ../blfs_stages.sh Script starten im /BLFS/SOURCE Verzeichnis..."
        exit
fi

export LFS=/lfs
export CC="gcc -s "
export J=5


config_cmake() { 
extra=$1
mkdir -v build &&
cd       build 
cmake $extra ..
make -j $J ; make install
}

#Default configure fuer ~70% der Pakete
config () {
extra=$1
./configure $extra --disable-static --prefix=/usr && sleep 2 && make -j $J && make install
}
config1 () {
extra=$1
./configure $extra --disable-static --prefix=/usr && make && make install
}
configopt () {
folder=$1
./configure --disable-static --prefix=/opt/$folder && sleep 2 && make -j $J && make install
}



# Chroot fals Neueinstieg
if test $1 = chroot
then
mount -vt proc proc $LFS/proc
mount -vt sysfs sysfs $LFS/sys
mount --bind /dev $LFS/dev
echo ""
echo "!!!!!!! BLFS_stages.sh Script starten im /BLFS/SOURCE Verzeichnis..."
/usr/sbin/chroot "$LFS" /usr/bin/env -i \
    HOME=/root TERM="$TERM" PS1='\u:\w\$ ' \
    PATH=/bin:/usr/bin:/sbin:/usr/sbin \
    /bin/bash --login
exit
fi


configdocbook() {
install -v -d -m755 /usr/share/xml/docbook/xml-dtd-4.5 &&
install -v -d -m755 /etc/xml &&
chown -R root:root . &&
cp -v -af docbook.cat *.dtd ent/ *.mod \
    /usr/share/xml/docbook/xml-dtd-4.5
if [ ! -e /etc/xml/docbook ]; then
    xmlcatalog --noout --create /etc/xml/docbook
    fi &&
    xmlcatalog --noout --add "public" \
    "-//OASIS//DTD DocBook XML V4.5//EN" \
    "http://www.oasis-open.org/docbook/xml/4.5/docbookx.dtd" \
    /etc/xml/docbook &&
    xmlcatalog --noout --add "public" \
    "-//OASIS//DTD DocBook XML CALS Table Model V4.5//EN" \
    "file:///usr/share/xml/docbook/xml-dtd-4.5/calstblx.dtd" \
    /etc/xml/docbook &&
    xmlcatalog --noout --add "public" \
    "-//OASIS//DTD XML Exchange Table Model 19990315//EN" \
    "file:///usr/share/xml/docbook/xml-dtd-4.5/soextblx.dtd" \
    /etc/xml/docbook &&
    xmlcatalog --noout --add "public" \
    "-//OASIS//ELEMENTS DocBook XML Information Pool V4.5//EN" \
    "file:///usr/share/xml/docbook/xml-dtd-4.5/dbpoolx.mod" \
    /etc/xml/docbook &&
    xmlcatalog --noout --add "public" \
    "-//OASIS//ELEMENTS DocBook XML Document Hierarchy V4.5//EN" \
    "file:///usr/share/xml/docbook/xml-dtd-4.5/dbhierx.mod" \
    /etc/xml/docbook &&
    xmlcatalog --noout --add "public" \
    "-//OASIS//ELEMENTS DocBook XML HTML Tables V4.5//EN" \
    "file:///usr/share/xml/docbook/xml-dtd-4.5/htmltblx.mod" \
    /etc/xml/docbook &&
    xmlcatalog --noout --add "public" \
    "-//OASIS//ENTITIES DocBook XML Notations V4.5//EN" \
    "file:///usr/share/xml/docbook/xml-dtd-4.5/dbnotnx.mod" \
    /etc/xml/docbook &&
    xmlcatalog --noout --add "public" \
    "-//OASIS//ENTITIES DocBook XML Character Entities V4.5//EN" \
    "file:///usr/share/xml/docbook/xml-dtd-4.5/dbcentx.mod" \
    /etc/xml/docbook &&
    xmlcatalog --noout --add "public" \
    "-//OASIS//ENTITIES DocBook XML Additional General Entities V4.5//EN" \
    "file:///usr/share/xml/docbook/xml-dtd-4.5/dbgenent.mod" \
    /etc/xml/docbook &&
    xmlcatalog --noout --add "rewriteSystem" \
    "http://www.oasis-open.org/docbook/xml/4.5" \
    "file:///usr/share/xml/docbook/xml-dtd-4.5" \
    /etc/xml/docbook &&
    xmlcatalog --noout --add "rewriteURI" \
    "http://www.oasis-open.org/docbook/xml/4.5" \
    "file:///usr/share/xml/docbook/xml-dtd-4.5" \
    /etc/xml/docbook

    if [ ! -e /etc/xml/catalog ]; then
    xmlcatalog --noout --create /etc/xml/catalog
    fi &&
    xmlcatalog --noout --add "delegatePublic" \
    "-//OASIS//ENTITIES DocBook XML" \
    "file:///etc/xml/docbook" \
    /etc/xml/catalog &&
    xmlcatalog --noout --add "delegatePublic" \
    "-//OASIS//DTD DocBook XML" \
    "file:///etc/xml/docbook" \
    /etc/xml/catalog &&
    xmlcatalog --noout --add "delegateSystem" \
    "http://www.oasis-open.org/docbook/" \
    "file:///etc/xml/docbook" \
    /etc/xml/catalog &&
    xmlcatalog --noout --add "delegateURI" \
    "http://www.oasis-open.org/docbook/" \
    "file:///etc/xml/docbook" \
    /etc/xml/catalog

   for DTDVERSION in 4.1.2 4.2 4.3 4.4
   do
   xmlcatalog --noout --add "public" \
   "-//OASIS//DTD DocBook XML V$DTDVERSION//EN" \
   "http://www.oasis-open.org/docbook/xml/$DTDVERSION/docbookx.dtd" \
   /etc/xml/docbook
   xmlcatalog --noout --add "rewriteSystem" \
   "http://www.oasis-open.org/docbook/xml/$DTDVERSION" \
   "file:///usr/share/xml/docbook/xml-dtd-4.5" \
   /etc/xml/docbook
   xmlcatalog --noout --add "rewriteURI" \
   "http://www.oasis-open.org/docbook/xml/$DTDVERSION" \
   "file:///usr/share/xml/docbook/xml-dtd-4.5" \
   /etc/xml/docbook
   xmlcatalog --noout --add "delegateSystem" \
   "http://www.oasis-open.org/docbook/xml/$DTDVERSION/" \
   "file:///etc/xml/docbook" \
   /etc/xml/catalog
   xmlcatalog --noout --add "delegateURI" \
   "http://www.oasis-open.org/docbook/xml/$DTDVERSION/" \
   "file:///etc/xml/docbook" \
   /etc/xml/catalog
   done
}


docbookxslconfig() {

install -v -m755 -d /usr/share/xml/docbook/xsl-stylesheets-1.78.1 
cp -v -R VERSION common eclipse epub extensions fo highlighting html \
         htmlhelp images javahelp lib manpages params profiling \
                  roundtrip slides template tests tools webhelp website \
                           xhtml xhtml-1_1 \
                               /usr/share/xml/docbook/xsl-stylesheets-1.78.1
ln -s VERSION /usr/share/xml/docbook/xsl-stylesheets-1.78.1/VERSION.xsl
install -v -m644 -D README \
                    /usr/share/doc/docbook-xsl-1.78.1/README.txt &&
                    install -v -m644    RELEASE-NOTES* NEWS* \
                                        /usr/share/doc/docbook-xsl-1.78.1
if [ ! -d /etc/xml ]; then install -v -m755 -d /etc/xml; fi &&
if [ ! -f /etc/xml/catalog ]; then
    xmlcatalog --noout --create /etc/xml/catalog
    fi &&

xmlcatalog --noout --add "rewriteSystem" \
           "http://docbook.sourceforge.net/release/xsl/1.78.1" \
                      "/usr/share/xml/docbook/xsl-stylesheets-1.78.1" \
                          /etc/xml/catalog &&
xmlcatalog --noout --add "rewriteURI" \
           "http://docbook.sourceforge.net/release/xsl/1.78.1" \
                      "/usr/share/xml/docbook/xsl-stylesheets-1.78.1" \
                          /etc/xml/catalog &&
xmlcatalog --noout --add "rewriteSystem" \
           "http://docbook.sourceforge.net/release/xsl/current" \
                      "/usr/share/xml/docbook/xsl-stylesheets-1.78.1" \
                          /etc/xml/catalog &&
xmlcatalog --noout --add "rewriteURI" \
           "http://docbook.sourceforge.net/release/xsl/current" \
                      "/usr/share/xml/docbook/xsl-stylesheets-1.78.1" \
                          /etc/xml/catalog
xmlcatalog --noout --add "rewriteSystem" \
           "http://docbook.sourceforge.net/release/xsl/<version>" \
                      "/usr/share/xml/docbook/xsl-stylesheets-<version>" \
                          /etc/xml/catalog &&
xmlcatalog --noout --add "rewriteURI" \
             "http://docbook.sourceforge.net/release/xsl/<version>" \
                        "/usr/share/xml/docbook/xsl-stylesheets-<version>" \
                            /etc/xml/catalog
}
    
downloadliste=(
 "http://www.bennewitz.com/bluefish/stable/source/bluefish-2.2.7.tar.bz2"
 "http://ftp.gnu.org/gnu/gmp/gmp-6.0.0a.tar.xz"
 "ftp://ftp.gnu.org/gnu/libtasn1/libtasn1-4.7.tar.gz"
 "ftp://ftp.gnu.org/gnu/libidn/libidn-1.32.tar.gz"
 "https://ftp.gnu.org/gnu/nettle/nettle-3.1.1.tar.gz"
 "ftp://ftp.gnutls.org/gcrypt/gnutls/v3.4/gnutls-3.4.6.tar.xz"
 "ftp://ftp.gnu.org/gnu/wget/wget-1.16.3.tar.gz"
 "ftp://openssl.org/source/openssl-1.0.2d.tar.gz" 
 "ftp://ftp.netfilter.org/pub/iptables/iptables-1.4.21.tar.bz2"
 "ftp://ftp.gnupg.org/gcrypt/libgpg-error/libgpg-error-1.20.tar.bz2"
 "ftp://ftp.gnupg.org/gcrypt/libgcrypt/libgcrypt-1.6.4.tar.bz2"
 "ftp://ftp.gnupg.org/gcrypt/libassuan/libassuan-2.3.0.tar.bz2"
 "ftp://ftp.gnupg.org/gcrypt/libksba/libksba-1.3.3.tar.bz2"
 "ftp://ftp.gnupg.org/gcrypt/npth/npth-1.2.tar.bz2"
 "ftp://ftp.gnupg.org/gcrypt/gnupg/gnupg-2.1.9.tar.bz2"
 "ftp://ftp.gnu.org/pub/gnu/ed/ed-1.9.tar.gz"
 "ftp://anduin.linuxfromscratch.org/BLFS/svn/p/popt-1.16.tar.gz"
 "ftp://sourceware.org/pub/libffi/libffi-3.2.1.tar.gz"
 "http://pkgs.fedoraproject.org/repo/pkgs/expat/expat-2.1.0.tar.gz/dd7dab7a5fea97d2a6a43f511449b7cd/expat-2.1.0.tar.gz"  
 "https://www.python.org/ftp/python/3.5.0/Python-3.5.0.tar.xz"
 "https://www.python.org/ftp/python/2.7.9/Python-2.7.9.tar.xz"
 "ftp://xmlsoft.org/libxml2/libxml2-2.9.2.tar.gz"
 "ftp://xmlsoft.org/libxslt/libxslt-1.1.28.tar.gz"
 "http://ftp.acc.umu.se/pub/gnome/sources/glib/2.46/glib-2.46.1.tar.xz"
 "ftp://ftp.gnome.org/pub/gnome/sources/libcroco/0.6/libcroco-0.6.8.tar.xz"
 "ftp://ftp.gnu.org/gnu/which/which-2.21.tar.gz"
 "https://www.kernel.org/pub/software/utils/pciutils/pciutils-3.4.0.tar.xz"
 "ftp://ftp.x.org/pub/individual/lib/libpciaccess-0.13.4.tar.bz2"
 "http://downloads.sourceforge.net/project/libusb/libusb-1.0/libusb-1.0.20/libusb-1.0.20.tar.bz2"
 "http://downloads.sourceforge.net/libusb/libusb-compat-0.1.5.tar.bz2"
 "ftp://ftp.kernel.org/pub/linux/utils/usb/usbutils/usbutils-008.tar.xz"
 "http://curl.haxx.se/download/curl-7.45.0.tar.lzma"
 "ftp://ftp.kernel.org/pub/software/scm/git/git-2.6.2.tar.xz"
 "https://pypi.python.org/packages/source/s/setuptools/setuptools-17.1.1.tar.gz"
 "https://pypi.python.org/packages/source/p/pip/pip-7.1.2.tar.gz"
 "https://pypi.python.org/packages/source/M/MarkupSafe/MarkupSafe-0.23.tar.gz"
 "https://pypi.python.org/packages/source/M/Mako/Mako-1.0.2.tar.gz"
 "ftp://ftp.gnu.org/gnu/aspell/aspell-0.60.6.1.tar.gz"
 "ftp://ftp.gnu.org/gnu/aspell/dict/de/aspell6-de-20030222-1.tar.bz2"
 "http://downloads.sourceforge.net/hunspell/hunspell-1.3.3.tar.gz"
 "http://www.oberhumer.com/opensource/lzo/download/lzo-2.09.tar.gz"
 "http://ftp.osuosl.org/pub/blfs/conglomeration/unrarsrc/unrarsrc-5.3.3.tar.gz"
 "http://www.nasm.us/pub/nasm/releasebuilds/2.11.08/nasm-2.11.08.tar.xz"
 "http://downloads.sourceforge.net/libjpeg-turbo/libjpeg-turbo-1.4.2.tar.gz"
 "http://downloads.sourceforge.net/libpng-apng/libpng-1.6.18-apng.patch.gz"
 "http://downloads.sourceforge.net/libpng/libpng-1.6.18.tar.xz"
 "ftp://ftp.remotesensing.org/libtiff/tiff-4.0.6.tar.gz"
 "http://downloads.sourceforge.net/giflib/giflib-5.1.1.tar.bz2"
 "http://downloads.sourceforge.net/project/lcms/lcms/2.7/lcms2-2.7.tar.gz"
 "http://downloads.sourceforge.net/libmng/libmng-2.0.3.tar.xz"
 "http://downloads.sourceforge.net/freetype/freetype-2.6.tar.bz2"
 "http://www.freedesktop.org/software/fontconfig/release/fontconfig-2.11.1.tar.bz2"
 "http://cairographics.org/releases/pixman-0.32.8.tar.gz"
 "ftp://ftp.gnome.org/pub/gnome/sources/glib/2.46/glib-2.46.1.tar.xz"
 "http://downloads.sourceforge.net/openjpeg.mirror/openjpeg-1.5.2.tar.gz"
 "http://poppler.freedesktop.org/poppler-0.37.0.tar.xz"
 "http://www.nico.schottelius.org/software/gpm/archives/gpm-1.20.7.tar.bz2"
 "http://downloads.sourceforge.net/hdparm/hdparm-9.48.tar.gz"
 "http://downloads.sourceforge.net/infozip/unzip60.tar.gz"
 "ftp://ftp.info-zip.org/pub/infozip/src/zip30.tgz"
 "ftp://ftp.gnu.org/pub/gnu/cpio/cpio-2.12.tar.bz2"
 "http://downloads.sourceforge.net/p7zip/p7zip_9.38.1_src_all.tar.bz2"
 "ftp://space.mit.edu/pub/davis/slang/v2.2/slang-2.2.4.tar.bz2"
 "ftp://ftp.osuosl.org/pub/midnightcommander/mc-4.8.14.tar.xz"
 "http://anduin.linuxfromscratch.org/files/BLFS/OpenJDK-1.8.0.51/OpenJDK-1.8.0.51-x86_64-bin.tar.xz"
 "ftp://ftp.mirrorservice.org/sites/ftp.apache.org/apr/apr-1.5.2.tar.bz2"
 "ftp://ftp.mirrorservice.org/sites/ftp.apache.org/apr/apr-util-1.5.4.tar.bz2" 
 "https://www.sqlite.org/2015/sqlite-autoconf-3081101.tar.gz"
 "http://www.apache.org/dist/subversion/subversion-1.9.2.tar.bz2"
 "http://ftp.openbsd.org/pub/OpenBSD/LibreSSL/libressl-2.3.0.tar.gz"
 "ftp://ftp.openbsd.org/pub/OpenBSD/OpenSSH/portable/openssh-7.1p1.tar.gz" 
 "https://download.samba.org/pub/samba/stable/samba-4.3.1.tar.gz"
 "http://www.hpl.hp.com/personal/Jean_Tourrilhes/Linux/wireless_tools.29.tar.gz"
 "http://www.carisma.slowglass.com/~tgr/libnl/files/libnl-3.2.25.tar.gz"
 "http://hostap.epitest.fi/releases/wpa_supplicant-2.4.tar.gz"
 "http://www.linuxfromscratch.org/patches/blfs/systemd/libpcap-1.7.3-enable_bluetooth-1.patch"
 "http://www.tcpdump.org/release/libpcap-1.7.4.tar.gz"
 "http://www.tcpdump.org/release/tcpdump-4.7.4.tar.gz"
 "http://www.libarchive.org/downloads/libarchive-3.1.2.tar.gz"
 "http://www.cmake.org/files/v3.3/cmake-3.3.2.tar.gz"
 "http://www.cpan.org/authors/id/E/ET/ETHER/URI-1.69.tar.gz"
 "http://search.cpan.org/CPAN/authors/id/T/TO/TODDR/XML-Parser-2.44.tar.gz"
 "http://www.freedesktop.org/software/libevdev/libevdev-1.4.4.tar.xz"
 "ftp://ftp.gnu.org/gnu/gdb/gdb-7.10.tar.xz"
 "X11NOW"
);

downloadliste2=(
 "http://cairographics.org/releases/cairo-1.14.2.tar.xz"
 "http://www.freedesktop.org/software/harfbuzz/release/harfbuzz-1.0.5.tar.bz2"
 "http://downloads.sourceforge.net/freetype/freetype-2.6.tar.bz2"
 "ftp://ftp.gnome.org/pub/gnome/sources/pango/1.38/pango-1.38.1.tar.xz"
 "ftp://ftp.gnome.org/pub/gnome/sources/atk/2.18/atk-2.18.0.tar.xz"
 "ftp://ftp.gnome.org/pub/gnome/sources/gdk-pixbuf/2.32/gdk-pixbuf-2.32.1.tar.xz"
 "ftp://ftp.gnome.org/pub/gnome/sources/librsvg/2.40/librsvg-2.40.11.tar.xz"
 "http://icon-theme.freedesktop.org/releases/hicolor-icon-theme-0.15.tar.xz"
 "ftp://ftp.gnome.org/pub/gnome/sources/gtk+/2.24/gtk+-2.24.28.tar.xz"
 "http://www.tortall.net/projects/yasm/releases/yasm-1.3.0.tar.gz"
 "ftp://ftp.alsa-project.org/pub/lib/alsa-lib-1.0.29.tar.bz2"
 "ftp://downloads.xiph.org/pub/xiph/releases/ogg/libogg-1.3.2.tar.xz"
 "http://downloads.xiph.org/releases/vorbis/libvorbis-1.3.5.tar.xz"
 "ftp://downloads.xiph.org/pub/xiph/releases/flac/flac-1.3.1.tar.xz"
 "http://www.mega-nerd.com/libsndfile/files/libsndfile-1.0.25.tar.gz"
 "http://www.mega-nerd.com/SRC/libsamplerate-0.1.8.tar.gz"
 "ftp://ftp.alsa-project.org/pub/plugins/alsa-plugins-1.0.29.tar.bz2"
 "ftp://ftp.alsa-project.org/pub/utils/alsa-utils-1.0.29.tar.bz2"
 "ftp://ftp.alsa-project.org/pub/oss-lib/alsa-oss-1.0.28.tar.bz2"
 "ftp://ftp.gnome.org/pub/gnome/sources/audiofile/0.3/audiofile-0.3.6.tar.xz"
 "http://downloads.sourceforge.net/opencore-amr/fdk-aac-0.1.4.tar.gz"
 "http://jpj.net/~trevor/aumix/releases/aumix-2.9.1.tar.bz2"
 "http://downloads.xiph.org/releases/theora/libtheora-1.1.1.tar.xz"
 "http://storage.googleapis.com/downloads.webmproject.org/releases/webm/libvpx-1.4.0.tar.bz2"
 "http://www.libsdl.org/release/SDL-1.2.15.tar.gz"
 "https://github.com/taglib/taglib/releases/download/v1.9.1/taglib-1.9.1.tar.gz"
 "http://download.videolan.org/pub/videolan/x264/snapshots/x264-snapshot-20150923-2245.tar.bz2"
 "http://downloads.sourceforge.net/lame/lame-3.99.5.tar.gz"
 "http://downloads.xiph.org/releases/ao/libao-1.2.0.tar.gz"
 "http://downloads.xiph.org/releases/vorbis/vorbis-tools-1.4.0.tar.gz"
 "http://download.videolan.org/libdvdcss/1.3.0/libdvdcss-1.3.0.tar.bz2"
 "http://download.videolan.org/videolan/libdvdread/5.0.3/libdvdread-5.0.3.tar.bz2"
 "http://download.videolan.org/videolan/libdvdnav/5.0.3/libdvdnav-5.0.3.tar.bz2"
 "ftp://ftp.mars.org/pub/mpeg/libmad-0.15.1b.tar.gz"
 "http://www.mpg123.de/download/mpg123-1.22.4.tar.bz2"
 "http://dl.matroska.org/downloads/libebml/libebml-1.3.1.tar.bz2"
 "http://dl.matroska.org/downloads/libmatroska/libmatroska-1.4.2.tar.bz2"
 ############# openssl muss neu installiert werden, danach klappt es mit qt und ruby
 "ftp://openssl.org/source/openssl-1.0.2d.tar.gz" 
 "http://cache.ruby-lang.org/pub/ruby/2.2/ruby-2.2.3.tar.xz"
 "http://downloads.sourceforge.net/boost/boost_1_59_0.tar.bz2" 
 "https://www.bunkus.org/videotools/mkvtoolnix/sources/mkvtoolnix-8.4.0.tar.xz"
 "ftp://ftp.videolan.org/pub/videolan/libaacs/0.8.1/libaacs-0.8.1.tar.bz2"
 "http://anduin.linuxfromscratch.org/sources/other/junit-4.11.jar"
 "http://hamcrest.googlecode.com/files/hamcrest-1.3.tgz"
 "https://archive.apache.org/dist/ant/source/apache-ant-1.9.6-src.tar.bz2"
 "ftp://ftp.videolan.org/pub/videolan/libbluray/0.9.0/libbluray-0.9.0.tar.bz2"
 "http://downloads.xvid.org/downloads/xvidcore-1.3.4.tar.gz"
 "http://ffmpeg.org/releases/ffmpeg-snapshot-git.tar.bz2"
 "ftp://ftp.mplayerhq.hu/MPlayer/releases/mplayer-checkout-snapshot.tar.bz2"
 "http://linuxtv.org/downloads/legacy/linuxtv-dvb-apps-1.1.1.tar.gz"
 "http://downloads.sourceforge.net/cdrdao/cdrdao-1.2.3.tar.bz2"
 "http://sourceforge.net/projects/cdrtools/files/cdrtools-3.01.tar.bz2"
 "http://fy.chalmers.se/~appro/linux/DVD+RW/tools/dvd+rw-tools-7.1.tar.gz" 
);

downloadliste3=(
 # FIREFOX 41.0.1
 #"http://downloads.sourceforge.net/levent/libevent-2.0.22-stable.tar.gz"
 #"http://download.icu-project.org/files/icu4c/55.1/icu4c-55_1-src.tgz"
 #"http://dbus.freedesktop.org/releases/dbus/dbus-1.10.0.tar.gz"
 #"http://dbus.freedesktop.org/releases/dbus-glib/dbus-glib-0.104.tar.gz"
 #"http://gstreamer.freedesktop.org/src/gstreamer/gstreamer-1.4.5.tar.xz"
 #"http://gstreamer.freedesktop.org/src/gst-plugins-base/gst-plugins-base-1.4.5.tar.xz"
 #"http://gstreamer.freedesktop.org/src/gst-plugins-good/gst-plugins-good-1.4.5.tar.xz"
 #"http://gstreamer.freedesktop.org/src/gst-plugins-bad/gst-plugins-bad-1.4.5.tar.xz"  
 #"http://gstreamer.freedesktop.org/src/gst-libav/gst-libav-1.4.5.tar.xz"
 #"https://ftp.mozilla.org/pub/mozilla.org/nspr/releases/v4.10.8/src/nspr-4.10.8.tar.gz"
 #"http://www.linuxfromscratch.org/patches/blfs/systemd/nss-3.20-standalone-1.patch"
 #"http://ftp.osuosl.org/pub/blfs/conglomeration/nss/nss-3.20.tar.gz" 
 #"https://ftp.mozilla.org/pub/firefox/releases/41.0.1/source/firefox-41.0.1.source.tar.xz"
 
 
 #"http://downloads.webmproject.org/releases/webp/libwebp-0.4.3.tar.gz"
 #"http://www.linuxfromscratch.org/patches/blfs/svn/jasper-1.900.1-security_fixes-2.patch"
 #"http://www.ece.uvic.ca/~mdadams/jasper/software/jasper-1.900.1.zip"
 ############"http://dbus.freedesktop.org/releases/dbus/dbus-1.10.0.tar.gz"
 
 #"http://freedesktop.org/~hadess/shared-mime-info-1.5.tar.xz"
 #"http://www.linuxfromscratch.org/patches/blfs/svn/sgml-common-0.6.3-manpage-1.patch"
 #"ftp://sources.redhat.com/pub/docbook-tools/new-trials/SOURCES/sgml-common-0.6.3.tgz"
 #"http://www.docbook.org/xml/4.5/docbook-xml-4.5.zip"
 #"http://downloads.sourceforge.net/docbook/docbook-xsl-1.78.1.tar.bz2"
 #"ftp://ftp.gnupg.org/gcrypt/gpgme/gpgme-1.6.0.tar.bz2"
 #"http://download.oracle.com/berkeley-db/db-6.1.26.tar.gz"
 #"http://www.linuxfromscratch.org/patches/blfs/svn/openldap-2.4.42-consolidated-1.patch"
 #"ftp://ftp.openldap.org/pub/OpenLDAP/openldap-release/openldap-2.4.42.tgz"
 #"http://www.linuxfromscratch.org/patches/blfs/svn/pcre-8.37-upstream_fixes-1.patch"
 #"ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/pcre-8.37.tar.bz2"
 ##############"http://dbus.freedesktop.org/releases/dbus-glib/dbus-glib-0.104.tar.gz"
 #"http://libndp.org/files/libndp-1.5.tar.gz"
 #"ftp://ftp.gnome.org/pub/gnome/sources/libgudev/230/libgudev-230.tar.xz"
 #################"https://ftp.mozilla.org/pub/mozilla.org/nspr/releases/v4.10.8/src/nspr-4.10.8.tar.gz"
 #################"http://www.linuxfromscratch.org/patches/blfs/systemd/nss-3.20-standalone-1.patch"
 #################"http://ftp.osuosl.org/pub/blfs/conglomeration/nss/nss-3.20.tar.gz"
 #"ftp://ftp.gnome.org/pub/gnome/sources/NetworkManager/1.0/NetworkManager-1.0.6.tar.xz"
 
 ##############"http://gstreamer.freedesktop.org/src/gstreamer/gstreamer-1.4.5.tar.xz"
 ##############"http://gstreamer.freedesktop.org/src/gst-plugins-base/gst-plugins-base-1.4.5.tar.xz"
 ##############"http://gstreamer.freedesktop.org/src/gst-plugins-good/gst-plugins-good-1.4.5.tar.xz"
 ##############"http://gstreamer.freedesktop.org/src/gst-plugins-bad/gst-plugins-bad-1.4.5.tar.xz"
 #"http://download.videolan.org/vlc/2.2.1/vlc-2.2.1.tar.xz"
 #"http://kcat.strangesoft.net/openal-releases/openal-soft-1.16.0.tar.bz2" 
 #"http://ftp.mozilla.org/pub/mozilla.org/js/mozjs17.0.0.tar.gz"
 #"http://linux-pam.org/library/Linux-PAM-1.2.1.tar.bz2"
 #"http://www.freedesktop.org/software/polkit/releases/polkit-0.113.tar.gz"
 #"http://downloads.us.xiph.org/releases/speex/speex-1.2rc2.tar.gz"
 #"http://downloads.us.xiph.org/releases/speex/speexdsp-1.2rc3.tar.gz"
 #"https://s3.amazonaws.com/json-c_releases/releases/json-c-0.12.tar.gz"
 #"http://search.cpan.org/CPAN/authors/id/M/MA/MAKAMAKA/JSON-2.90.tar.gz"
 #"https://launchpad.net/bzr/2.6/2.6.0/+download/bzr-2.6.0.tar.gz"
 #"http://freedesktop.org/software/pulseaudio/releases/pulseaudio-6.0.tar.xz"
 #"http://ftp.stack.nl/pub/doxygen/doxygen-1.8.10.src.tar.gz"
 #"http://downloads.sourceforge.net/project/fontforge/fontforge-source/fontforge_full-20120731-b.tar.bz2"
 #"https://github.com/cracklib/cracklib/releases/download/cracklib-2.9.6/cracklib-2.9.6.tar.gz"
 #"http://sourceforge.net/projects/cracklib/files/cracklib-words/2008-05-07/cracklib-words-20080507.gz"
 #"https://fedorahosted.org/releases/l/i/libpwquality/libpwquality-1.3.0.tar.bz2"
 #"https://github.com/LibVNC/libvncserver/archive/LibVNCServer-0.9.10.tar.gz"
 #"http://www.linuxfromscratch.org/patches/blfs/svn/cyrus-sasl-2.1.26-fixes-3.patch"
 #"ftp://ftp.cyrusimap.org/cyrus-sasl/cyrus-sasl-2.1.26.tar.gz"
 #"http://sourceforge.net/projects/freeassociation/files/libical/libical-0.48/libical-0.48.tar.gz"
 #"http://oligarchy.co.uk/xapian/1.2.21/xapian-core-1.2.21.tar.xz"

 ##### Da haben einige Pakete Kreisfoermige Abhaengigkeiten
 #"ftp://ftp.gnome.org/pub/gnome/sources/atk/2.18/atk-2.18.0.tar.xz"
 #"ftp://ftp.gnome.org/pub/gnome/sources/at-spi2-core/2.18/at-spi2-core-2.18.0.tar.xz"
 #"ftp://ftp.gnome.org/pub/gnome/sources/at-spi2-atk/2.18/at-spi2-atk-2.18.0.tar.xz"
 #"ftp://ftp.gnome.org/pub/gnome/sources/gobject-introspection/1.46/gobject-introspection-1.46.0.tar.xz"
 #"ftp://ftp.gnome.org/pub/gnome/sources/pango/1.38/pango-1.38.0.tar.xz"
 #"ftp://ftp.gnome.org/pub/gnome/sources/gdk-pixbuf/2.32/gdk-pixbuf-2.32.1.tar.xz"
 #"ftp://ftp.gnome.org/pub/gnome/sources/atk/2.18/atk-2.18.0.tar.xz"
 #"ftp://ftp.gnome.org/pub/gnome/sources/gtk+/3.18/gtk+-3.18.1.tar.xz"
 
 # gnome icons + BluefishEditor
 #"ftp://ftp.gnome.org/pub/gnome/sources/adwaita-icon-theme/3.18/adwaita-icon-theme-3.18.0.tar.xz" 
 "http://www.bennewitz.com/bluefish/stable/source/bluefish-2.2.7.tar.bz2"
  
 #"http://www.exiv2.org/exiv2-0.25.tar.gz"
 #"http://bitbucket.org/eigen/eigen/get/3.2.6.tar.bz2"
 #"http://pkgs.fedoraproject.org/repo/pkgs/libaccounts-glib/libaccounts-glib-1.18.tar.gz/fa37ebbe1cc1e8b738368ba86142c197/libaccounts-glib-1.18.tar.gz"
 #"http://luajit.org/download/LuaJIT-2.0.4.tar.gz"
 #"http://fribidi.org/download/fribidi-0.19.7.tar.bz2"
 #"http://dbus.freedesktop.org/releases/dbus-python/dbus-python-1.2.0.tar.gz"
 
 ############ QT 5.5.0
 #"http://download.qt.io/archive/qt/5.5/5.5.1/single/qt-everywhere-opensource-src-5.5.1.tar.xz"
 #"http://download.qt.io/official_releases/qtcreator/3.5/3.5.1/qt-creator-opensource-src-3.5.1.tar.gz"
 #"https://sources.archlinux.org/other/packages/libaccounts-qt/accounts-qt-1.13.tar.bz2"
 #"http://archlinux.c3sl.ufpr.br/sources/packages/signond-8.58.tar.gz"
 ############ KDE5
 #"https://martine.github.io/ninja/ninja-1.6.tar.gz"
 #"telepathy-glib-0.24.1.tar.gz"
 #"libnice-0.1.13.tar.gz"
 #"KDENOW" 
);

if test $1 = check
then
for((i=0;i<${#downloadliste[*]};i++)); do
  set +e
  paket=$(echo ${downloadliste[$i]} )
  # wwwpfad enthaellt die url ohne dateiname
  wwwpfad=${paket%/*}
  rm index.txt
  wget -O index.txt -c --no-check-certificate $wwwpfad/
  # dateiname ist der Dateiname von der url
  dateiname=$(echo ${paket##*/})
  # name ist der projektname ohne .tar.xyz
  name=$(echo $dateiname | awk '{ split($0,a,"."); print a[1] }')
  
  paket_liste_von_index=$(cat index.txt | sed 's@.diff@\n@g' | sed 's@.asc@@g' |sed 's@<@\n@g' | sed 's@>@\n @g'  \
   | sed 's@.sig@\n@g' | sed 's@.sha1@\n@g' |sed 's@"@\n@g' | awk '/ '$name'/' | sort --version-sort | uniq )  
  echo "" 
  echo $wwwpfad
  echo $dateiname
  echo $name
  echo $suffix
  echo ""
  
  for lauf in ${paket_liste_von_index=[@]}
  do
    echo $lauf
  done
  echo "" ; echo "In Liste:" $dateiname ; echo "" ;
  
  read
done
fi


if test $1 = start
then
for((i=0;i<${#downloadliste[*]};i++)); do
  set +e 
  paket=$(echo ${downloadliste[$i]} )   
  filename=$(echo $paket | sed 's@/@ @g' | awk ' {print $NF;}')
  ordnerdir=$(echo $filename | sed 's/.tar.lzma//' | sed 's/.tgz//' | sed 's/.tar.xz//' | sed 's/.tar.bz2//' | sed 's/.src.tar.gz//'  | sed 's/.tar.lz//'  | sed 's/.tar.gz//' | sed 's/.src.tgz//' )
  name=$(echo $ordnerdir | awk '{ split($0,a,"-"); print a[1] }')
  patch=$(echo $paket | grep "\.patch" )  
  cd /BLFS/SOURCE/
  if [ -n "$patch" ]
  then
  echo "Downloading Patch: " $filename
  test -e $filename || /usr/bin/wget --no-check-certificate -c $paket 
  sleep 5
  continue
  else
  test -e $filename || /usr/bin/wget --no-check-certificate -c $paket
  tar xvf $filename
  cd $ordnerdir
  test -e ../$name-*.patch &&  patch -Np1 -i ../$name-*.patch
  fi
  unset patch
  set -e

  case "$ordnerdir" in
     dbus-python-1.2.0)         name="dbus-python" ;;
     3.2.6)                     cd eigen-eigen-c58038c56923; mkdir build ; cd build ; cmake -DCMAKE_INSTALL_PREFIX=/usr .. ; make ; make install 
     				cd /BLFS/SOURCE ; rm -rf eigen-eigen-c58038c56923 ; continue  ;; 
     JSON-2.90)			perl Makefile.PL ; make ; make install 
     				cd /BLFS/SOURCE ; rm -rf $ordnerdir ; continue ;;
     Linux-PAM-1.2.1)		./configure --prefix=/usr --sysconfdir=/etc --libdir=/usr/lib --enable-securedir=/lib/security 
				make -j 5 ; make install ; cd /BLFS/SOURCE ; rm -rf $ordnerdir ; continue ;;                                                     
     mozjs17.0.0)		cd js/src ; sed -i 's/(defined\((@TEMPLATE_FILE)\))/\1/' config/milestone.pl ; ./configure --prefix=/usr --enable-readline  --enable-threadsafe  --with-system-ffi  --with-system-nspr
				make -j 5 ; make install ; cd /BLFS/SOURCE ; rm -rf $ordnerdir ; continue ;;                                                     
     dbus-glib-0.104)           ./configure --prefix=/usr --sysconfdir=/etc --disable-static ; make ; make install  ;;
     docbook-xsl-1.78.1)	docbookxslconfig ; cd /BLFS/SOURCE ; rm -rf $ordnerdir ; continue ;;
     qt-creator-opensource-src-*)
     				qmake -r
     				make -j6 ; make install INSTALL_ROOT=/opt/$ordnerdir
     				cd /BLFS/SOURCE ; rm -rf $ordnerdir ; continue
				;;
     qt-everywhere-opensource-src-*)
     				export QT5PREFIX=/opt/qt5
     				LIBRARY_PATH=/usr/X11/lib ./configure -reduce-exports -prefix /opt/qt5 -sysconfdir /etc/xdg -confirm-license -opensource  \
     				-v -dbus-linked -openssl-linked -system-harfbuzz -system-sqlite -nomake examples -no-rpath  -optimized-qmake -skip qtwebengine -no-compile-examples
                                echo "/opt/qt5/lib" >> /etc/ld.so.conf
				LIBRARY_PATH=/usr/X11/lib make -j $J && make install
				find $QT5PREFIX/lib/pkgconfig -name "*.pc" -exec perl -pi -e "s, -L$PWD/?\S+,,g" {} \;
				find $QT5PREFIX -name qt_lib_bootstrap_private.pri -exec sed -i -e "s:$PWD/qtbase:/$QT5PREFIX/lib/:g" {} \; 
     				find $QT5PREFIX -name \*.prl -exec sed -i -e '/^QMAKE_PRL_BUILD_DIR/d' {} \; 
     				#export QT5BINDIR=$QT5PREFIX/bin
     				#for file in moc uic rcc qmake lconvert lrelease lupdate; do
     				#  ln -sfv $QT5BINDIR/$file /usr/bin/$file-qt5
     				#done
     				cd /BLFS/SOURCE ; rm -rf $ordnerdir ; continue
     				;;
     apache-ant-1.9.6-src)   	cd apache-ant-*/
     				tar -xvf ../hamcrest-1.3.tgz
     				cp -v ../junit-4.11.jar  hamcrest-1.3/hamcrest-core-1.3.jar lib/optional
     				JAVA_HOME=/opt/java ./build.sh -Ddist.dir=/opt/ant-1.9.6 dist 
     				ln -v -sfn ant-1.9.6 /opt/ant
     				cd /BLFS/SOURCE ; rm -rf apache-ant-1.9.6 ; continue ;;
     boost_1_59_0)		sed -e '1 i#ifndef Q_MOC_RUN' -e '$ a#endif' -i boost/type_traits/detail/has_binary_operator.hpp
     				./bootstrap.sh --prefix=/usr &&
     				./b2 stage threading=multi link=shared
     				./b2 install threading=multi link=shared
     				cd /BLFS/SOURCE ; rm -rf $ordnerdir ; continue ;;
     SDL-1.2.15)		sed -e '/_XData32/s:register long:register _Xconst long:' -i src/video/x11/SDL_x11sym.h ;;
     libtheora-1.1.1)		sed -i 's/png_\(sizeof\)/\1/g' examples/png2theora.c ;;
     alsa-utils-1.0.29)		./configure --prefix=/usr ; sed -i 's@xmlto man $?@#xmlto man $?@g' alsactl/Makefile
     				touch alsactl/alsactl_init.7
  				make && make install ; cd /BLFS/SOURCE ; rm -rf $ordnerdir ; continue;;
     cracklib-words-20080507.gz) cp -a cracklib-words-20080507.gz /usr/share/dict/cracklib-words.gz
     				gunzip -v  /usr/share/dict/cracklib-words.gz
     				ln -v -sf cracklib-words /usr/share/dict/words
     				create-cracklib-dict     /usr/share/dict/cracklib-words
     				continue ;;
  esac
  
  case "$name" in 
     bluefish)     configopt $ordnerdir ;;
     LuaJIT)       sed -i 's@export PREFIX= /usr/local@export PREFIX= /usr@g' Makefile ; make ; make install;;
     firefox)	   cd mozilla-* ; mkdir build2 ; cd build2 
                   CXXFLAGS="-O3 -march=ivybridge -pipe " SHELL=/bin/sh ../configure --prefix=/opt/firefox --disable-optimize --with-system-zlib --with-system-jpeg --enable-svg --disable-tests --disable-installer --disable-accessibility --enable-xinerama --enable-application=browser --disable-crashreporter --disable-gconf --disable-pulseaudio --disable-necko-wifi --enable-gstreamer=1.0 --enable-system-hunspell --enable-system-sqlite --with-system-libevent --with-system-libvpx --with-system-nspr --with-system-nss --with-system-icu --disable-updater --enable-optimize --enable-official-branding --enable-safe-browsing --enable-url-classifier --enable-system-ffi --enable-system-pixman --with-system-bz2 --with-system-jpeg --with-system-png --with-system-zlib
                   SHELL=/bin/sh make -j 6 ; SHELL=/bin/sh make install
                   ln -s /opt/firefox/bin/firefox /usr/bin/
                   ;;
     libpng)       gzip -cd ../libpng-1.6.18-apng.patch.gz | patch -p1 ; config ;;
     ninja)        ./bootstrap.py ; cp ninja /usr/sbin/ ;;
     gdb)          config '--with-system-readline' ;;
     signond)      qmake PREFIX=/opt/qt5 LIBDIR=/opt/qt5/lib ; make -j5; make install ;;
     accounts)     qmake PREFIX=/opt/qt5 LIBDIR=/opt/qt5/lib ; make -j5; make install ;;
     exiv2)	   config '--enable-video --enable-webready  --without-ssh ' ;; 
     cyrus)        autoreconf -fi ; config '--sysconfdir=/etc --enable-auth-sasldb --with-dbpath=/var/lib/sasl/sasldb2 -with-saslauthd=/var/run/saslauthd '  ;;
     LibVNCServer) cd libvncserver-*/ ; ./autogen.sh ; config ;;
     openal)	   cmake -DCMAKE_INSTALL_PREFIX=/usr ; make ; make install ;;
     libpwquality) config '--disable-python-bindings --with-securedir=/lib/security' ;;
     fontforge_full) cd fontforge-20120731-b ; config ;;
     doxygen)      cmake -G "Unix Makefiles" -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr ; make -j 5; make install  ;;
     json)         sed -i s/-Werror// Makefile.in    ; ./configure --prefix=/usr --disable-static ; make ; make install ;;
     pulseaudio)   config '--sysconfdir=/etc --localstatedir=/var --without-caps --disable-bluez4 --disable-rpath ' ;;
     polkit)       config '--sysconfdir=/etc --localstatedir=/var' ;;
     vlc)          config '--disable-lua --disable-avcodec --disable-swscale --disable-a52' ;;
     nss)          cd nss ; make BUILD_OPT=1 NSPR_INCLUDE_DIR=/usr/include/nspr USE_SYSTEM_ZLIB=1 ZLIB_LIBS=-lz  $([ $(uname -m) = x86_64 ] && echo USE_64=1)  $([ -f /usr/include/sqlite3.h ] && echo NSS_USE_SYSTEM_SQLITE=1) -j1
                   cd ../dist                                                       &&
                   install -v -m755 Linux*/lib/*.so              /usr/lib           &&
                   install -v -m644 Linux*/lib/{*.chk,libcrmf.a} /usr/lib           &&
                   install -v -m755 -d                           /usr/include/nss   &&
                   cp -v -RL {public,private}/nss/*              /usr/include/nss   &&
                   chmod -v 644                                  /usr/include/nss/* &&
                   install -v -m755 Linux*/bin/{certutil,nss-config,pk12util} /usr/bin &&
                   install -v -m644 Linux*/lib/pkgconfig/nss.pc  /usr/lib/pkgconfig
                   ;;
     nspr)         cd nspr ; sed -ri 's#^(RELEASE_BINS =).*#\1#' pr/src/misc/Makefile.in
     		   sed -i 's#$(LIBRARY) ##' config/rules.mk   
     		   ./configure --prefix=/usr --with-mozilla --with-pthreads $([ $(uname -m) = x86_64 ] && echo --enable-64bit)
     		   make ; make install ;;
     NetworkManager) config '--sysconfdir=/etc --localstatedir=/var --disable-ppp ' ;;
     pcre)         config '--docdir=/usr/share/doc/pcre --enable-unicode-properties --enable-pcre16 --enable-pcre32 --enable-pcregrep-libz --enable-pcregrep-libbz2  --enable-pcretest-libreadline' ;;
     db)	   cd build_unix  && ../dist/configure --prefix=/usr --enable-compat185 --enable-dbm --disable-static --enable-cxx &&
		   make ; make docdir=/usr/share/doc/db-6.1.26 install 
		   chown -v -R root:root  /usr/bin/db_* /usr/include/db{,_185,_cxx}.h  /usr/lib/libdb*.{so,la} ;;                
     openldap)     autoconf ; ./configure --prefix=/usr --sysconfdir=/etc --disable-static --enable-dynamic --disable-debug --disable-slapd 
                   make depend && make -j 4; make install 
                   cd libraries/liblmdb ;  sed -i 's@/usr/local@/usr@g' Makefile ; make ; make install
                   sleep 5;;
     docbook) 	   unzip docbook-xml-4.5.zip -d docbook ; cd docbook ; name=docbook ; configdocbook ;;
     sgml)         autoreconf -f -i ; ./configure --prefix=/usr --sysconfdir=/etc ; make ; make docdir=/usr/share/doc install 
                   install-catalog --add /etc/sgml/sgml-ent.cat /usr/share/sgml/sgml-iso-entities-8879.1986/catalog  
                   install-catalog --add /etc/sgml/sgml-docbook.cat /etc/sgml/sgml-ent.cat
                   ;;
     shared)       ./configure --prefix=/usr ; make ; make install ;;
     KDENOW)       echo "";echo "Jetzt KDE5 installieren!!!!!!" ; exit ;;
     icu4c)	   cd icu/source ; config ;;
     dbus)         groupadd -g 18 messagebus && useradd -c "D-Bus Message Daemon User" -d /var/run/dbus -u 18 -g messagebus -s /bin/false messagebus
		   ./configure --prefix=/usr --disable-static  -sysconfdir=/etc  --localstatedir=/var --disable-doxygen-docs --disable-xml-docs  --disable-systemd --without-systemdsystemunitdir --with-console-auth-dir=/run/console/ --docdir=/usr/share/doc/dbus-1.10.0 
		   make -j 4 ; make install
		   chown -v root:messagebus /usr/libexec/dbus-daemon-launch-helper &&
		   chmod -v      4750       /usr/libexec/dbus-daemon-launch-helper
		   dbus-uuidgen --ensure  
		   ;;
     jasper)	   unzip jasper-1.900.1.zip && cd jasper-1.900.1
     		   patch -Np1 -i ../jasper-1.900.1-security_fixes-2.patch
     		   config '-enable-shared -mandir=/usr/share/man'
     		   ;;
     dvd+rw)	   sed -i 's@#include <sys/time.h>@#include <sys/time.h>\n#include <limits.h>@g' transport.hxx
     		   make all
     		   make prefix=/usr install ;;
     cdrtools)     make INS_BASE=/usr DEFINSUSR=root DEFINSGRP=root
                   make INS_BASE=/usr DEFINSUSR=root DEFINSGRP=root install
                   ;;
     xvidcore)     mv xvidcore $ordnerdir ; cd $ordnerdir/build/generic ; config ;
          	   chmod -v 755 /usr/lib/libxvidcore.so.*
     		   ln -v -sf libxvidcore.so.4.3 /usr/lib/libxvidcore.so.4
     		   ln -v -sf libxvidcore.so.4 /usr/lib/libxvidcore.so
     		   ;;
     libbluray)    PATH="/bin:/usr/bin:/sbin:/usr/sbin:/usr/X11/bin:/opt/java/bin:/opt/ant/bin"  JDK_HOME=/opt/java ANT_HOME=/opt/ant ./configure --prefix=/usr --enable-udf ; make ; make install ;;
     junit)        continue ;;
     hamcrest)	   ;;
     cdrdao)	   sed -i '/ioctl/a #include <sys/stat.h>' dao/ScsiIf-linux.cc ; config ;;
     linuxtv)      sed -i 's@$(MAKE) -C test $(MAKECMDGOALS)@@g' Makefile
     		   make
     		   cp util/szap/czap /usr/sbin
     		   cp util/szap/szap /usr/sbin
     		   cp util/szap/tzap /usr/sbin ;;
     mkvtoolnix)   ./configure --prefix=/usr ; ./drake ; ./drake install ;;
     ffmpeg)	   ;;
     mplayer)      cd mplayer-checkout-*/
     		   mv ../ffmpeg .
     		   ln -s /usr/X11/include/vdpau /usr/include/vdpau
     		   ./configure --prefix=/usr && make -j 8 && make install   ;;
     libmad)	   echo 'prefix=/usr'                        > /usr/lib/pkgconfig/mad.pc
     		   echo 'exec_prefix=${prefix}'             >> /usr/lib/pkgconfig/mad.pc
     		   echo 'libdir=${exec_prefix}/lib'         >> /usr/lib/pkgconfig/mad.pc
     		   echo 'includedir=${prefix}/include'      >> /usr/lib/pkgconfig/mad.pc
     		   echo ''                                  >> /usr/lib/pkgconfig/mad.pc
     		   echo 'Name: mad'                         >> /usr/lib/pkgconfig/mad.pc
     		   echo 'Description: MPEG audio decoder'   >> /usr/lib/pkgconfig/mad.pc
     		   echo 'Requires:'                         >> /usr/lib/pkgconfig/mad.pc
     		   echo 'Version: 0.15.1b'                  >> /usr/lib/pkgconfig/mad.pc
     		   echo 'Libs: -L${libdir} -lmad'           >> /usr/lib/pkgconfig/mad.pc
                   echo 'Cflags: -I${includedir}'           >> /usr/lib/pkgconfig/mad.pc
                   ./configure --prefix=/usr && sed -i 's@-fforce-mem@ -O2 @g' Makefile ; make ; make install ;;
     x264)         ./configure --prefix=/usr --enable-shared --disable-cli ; make -j 4; make install ;;
     taglib)       cmake -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_BUILD_TYPE=Release ; make ; make install ;;
     libvpx)       config '--enable-shared' ;;
     X11NOW)       echo "";echo "Jetzt X11 installieren!!!!!!" ; exit ;;
     cairo)        config '--enable-tee' ;;
     cmake)        ./bootstrap --prefix=/usr --system-libs --mandir=/share/man --no-system-jsoncpp --docdir=/share/doc/cmake
                   make -j 4 && make install 
                   ;;
     libnl)        config '--sysconfdir=/etc ' ;;
     wpa_supplicant) 
                   cp ../../EXTRA/wpa_supplicant.config wpa_supplicant/.config 
                   sed -e "s@wpa_supplicant -u@& -s -O /var/run/wpa_supplicant@g" -i wpa_supplicant/dbus/*.service.in &&
                   sed -e "s@wpa_supplicant -u@& -s -O /var/run/wpa_supplicant@g" -i wpa_supplicant/systemd/wpa_supplicant.service.in
                   cd wpa_supplicant 
                   make BINDIR=/sbin LIBDIR=/lib
                   install -v -m755 wpa_{cli,passphrase,supplicant} /sbin/ &&
                   install -v -m644 doc/docbook/wpa_supplicant.conf.5 /usr/share/man/man5/ &&
                   install -v -m644 doc/docbook/wpa_{cli,passphrase,supplicant}.8 /usr/share/man/man8/
                   ;;
     wireless_tools.29) 
                   make ; make PREFIX=/usr INSTALL_MAN=/usr/share/man install 
                   ;;
     samba)        ./configure --without-ads --without-ldap --prefix=/usr --sysconfdir=/etc --localstatedir=/var --with-piddir=/var/run/samba --with-pammodulesdir=/lib/security --enable-fhs --without-acl-support && make -j 4 && make install
                   echo "[global]"                        >/etc/samba/smb.conf 
                   echo "   workgroup = MYGROUP"         >>/etc/samba/smb.conf
                   echo "   dos charset = cp850"         >>/etc/samba/smb.conf
                   echo "   unix charset = ISO-8859-1"   >>/etc/samba/smb.conf
                   ;;
     openssh)      install -v -m700 -d /var/lib/sshd && chown -v root:sys /var/lib/sshd 
                   config '--sysconfdir=/etc/ssh --with-md5-passwords  --with-privsep-path=/var/lib/sshd'
                   install -v -m755 contrib/ssh-copy-id /usr/bin &&
                   install -v -m644 contrib/ssh-copy-id.1 /usr/share/man/man1 &&
                   install -v -m755 -d /usr/share/doc/openssh           &&
                   install -v -m644 INSTALL LICENCE OVERVIEW README* /usr/share/doc/openssh
                   ;;
     sqlite)       ./configure --prefix=/usr --disable-static CFLAGS=" $CFLAGS  -DSQLITE_ENABLE_FTS3=1 -DSQLITE_ENABLE_COLUMN_METADATA=1  -DSQLITE_ENABLE_UNLOCK_NOTIFY=1  -DSQLITE_SECURE_DELETE=1   -DSQLITE_ENABLE_DBSTAT_VTAB=1"
     		   make -j 4 && make install
     		   ;;
     apr)          config ' --with-apr=/usr --with-gdbm=/usr  --with-openssl=/usr --with-crypto --with-installbuilddir=/usr/share/apr-1/build' ;;
     OpenJDK)      cd .. ; chmod 740 OpenJDK-*-x86_64-bin
     		   mv OpenJDK-*-x86_64-bin /opt/
     		   ln -s /opt/OpenJDK-*-x86_64-bin /opt/java    
                   ;;
     mc)           config '--enable-charset' ; cp -v doc/keybind-migration.txt /usr/share/mc ;;
     slang)        ./configure --prefix=/usr --sysconfdir=/etc --with-readline=gnu ; make ; make install-all ; chmod -v 755 /usr/lib/libslang.so.2.2.4 /usr/lib/slang/v2/modules/*.so 
                   ;;
     p7zip_9.38.1_src_all) cd p7zip_9.38.1 ; sed -i -e 's/chmod 555/chmod 755/' -e 's/chmod 444/chmod 644/' install.sh && make all3 
                   make DEST_HOME=/usr DEST_MAN=/usr/share/man DEST_SHARE_DOC=/usr/share/doc/p7zip-9.38.1 install  
                   ordnerdir="p7zip_9.38.1" ;;
     cpio)         sed -i -e '/gets is a/d' gnu/stdio.in.h ; config '--bindir=/bin --enable-mt --with-rmt=/usr/libexec/rmt' 
                   ;;     
     zip30)        make -f unix/Makefile generic_gcc ; make prefix=/usr MANDIR=/usr/share/man/man1 -f unix/Makefile install 
                   ;;
     unzip60)      make -f unix/Makefile generic ; make prefix=/usr MANDIR=/usr/share/man/man1 -f unix/Makefile install 
                   ;;
     hdparm)       make ; make install ;;
     gpm)          ./autogen.sh ; config '--sysconfdir=/etc' 
                   ;;
     openjpeg)     autoreconf -f -i ; config 
     	           ;;   
     dlib)         config '--with-pcre=system'
                   ;;
     fontconfig)   config '-sysconfdir=/etc  --localstatedir=/var --disable-docs --docdir=/usr/share/doc/fontconfig-2.11.1' 
                   ;;      
     freetype)	   sed -i  -e "/AUX.*.gxvalid/s@^# @@" -e "/AUX.*.otvalid/s@^# @@" modules.cfg 
                   sed -ri -e 's:.*(#.*SUBPIXEL.*) .*:\1:' include/config/ftoption.h 
                   config 
                   ;;              	   
     libjpeg)      sed -i -e '/^docdir/ s:$:/libjpeg-turbo-1.4.2:' Makefile.in ;
     		   config '--mandir=/usr/share/man --with-jpeg8' 
                   ;;  
     unrarsrc)     cd unrar; sed -i 's@CXXFLAGS=-O2@@g' makefile ; make && cp unrar /usr/sbin 
     		   ordnerdir="unrar" ;;
     lzo)	   config '--enable-shared --docdir=/usr/share/doc/lzo-2.09'
     		   mv -v /usr/lib/liblzo2.so.* /lib
                   ln -sfv ../../lib/$(readlink /usr/lib/liblzo2.so) /usr/lib/liblzo2.so
                   ;;
     aspell)       config
                   ln -sfvn aspell-0.60 /usr/lib/aspell &&
                   install -v -m755 -d /usr/share/doc/aspell-0.60.6.1/aspell{,-dev}.html &&
                   install -v -m644 manual/aspell.html/* /usr/share/doc/aspell-0.60.6.1/aspell.html &&
                   install -v -m644 manual/aspell-dev.html/* /usr/share/doc/aspell-0.60.6.1/aspell-dev.html
                   install -v -m 755 scripts/ispell /usr/bin/
                   install -v -m 755 scripts/spell /usr/bin/
                   ;;
     aspell6)	   ./configure ; make ; make install 
                   ;;
     hunspell)     ln -sf /usr/lib/aspell /usr/share/myspell ; config ;;
     #PERL Modules
     URI)	   perl Makefile.PL ; make ; make install ;;
     XML)          perl Makefile.PL ; make ; make install ;;
     #Python2/3 Modules 
     dbus-python)  mkdir python2 ; pushd python2 ; PYTHON=/usr/bin/python  ../configure --prefix=/usr ; make ; popd 
                   mkdir python3 ; pushd python3 ; PYTHON=/usr/bin/python3 ../configure --prefix=/usr ; make ; popd
                   make -C python2 install ; make -C python3 install ;;
     bzr)          python setup.py install --optimize=1 ;;
     setuptools)   python setup.py install --optimize=1 ; python3 setup.py install --optimize=1 ;;
     pip)          python setup.py install --optimize=1 ; python3 setup.py install --optimize=1 ;;
     MarkupSafe)   python setup.py build && python setup.py install --optimize=1 ; python3 setup.py build && python3 setup.py install --optimize=1 ;;
     Mako)         sed -i "s:mako-render:&3:g" setup.py ; python setup.py install --optimize=1 ; python3 setup.py install --optimize=1 ;; 
     #Python2/3 Modules Ende
     
     gmp)	cd gmp-6.0.0 &&	./configure --prefix=/usr --disable-static --docdir=/usr/share/doc/gmp-6.0.0a && make && make install
     		ordnerdir="gmp-6.0.0" ;;
     nettle)	config
     		chmod   -v   755 /usr/lib/lib{hogweed,nettle}.so &&
     		install -v -m755 -d /usr/share/doc/nettle-3.1.1  &&
     		install -v -m644 nettle.html /usr/share/doc/nettle-3.1.1
     		;;
     gnutls)	./configure --without-p11-kit --prefix=/usr --with-default-trust-store-file=/etc/ssl/ca-bundle.crt && make && make install
     		make -C doc/reference install-data-local
     		;;
     wget)	./configure --prefix=/usr --sysconfdir=/etc && make && make install
     		;;
     openssl)	CC="gcc $CFLAGS" ./config --prefix=/usr --openssldir=/etc/ssl --libdir=lib shared zlib-dynamic && make 
     		sed -i 's# libcrypto.a##;s# libssl.a##' Makefile
     		make MANDIR=/usr/share/man MANSUFFIX=ssl install &&
     		install -dv -m755 /usr/share/doc/openssl-1.0.2d  &&
     		cp -vfr doc/*     /usr/share/doc/openssl-1.0.2d 
     		;;
     iptables)  ./configure --prefix=/usr --sbindir=/sbin --enable-libipq --with-xtlibdir=/lib/xtables && make
     		make install && ln -sfv ../../sbin/xtables-multi /usr/bin/iptables-xml &&
     		for file in ip4tc ip6tc ipq iptc xtables
     		do
     		  mv -v /usr/lib/lib${file}.so.* /lib &&
     		  ln -sfv ../../lib/$(readlink /usr/lib/lib${file}.so) /usr/lib/lib${file}.so
     		done
		;;
     libgcrypt) config '--enable-random=linux'
     		;;
     gnupg)	./configure --prefix=/usr --enable-symcryptrun --docdir=/usr/share/doc/gnupg-2.1.7 && make
     	        make install && 
     	        install -v -m755 -d /usr/share/doc/gnupg-2.1.7/html && 
     	        install -v -m644    doc/gnupg_nochunks.html  /usr/share/doc/gnupg-2.1.7/html/gnupg.html &&
                install -v -m644    doc/*.texi doc/gnupg.txt /usr/share/doc/gnupg-2.1.7
		;;     		
     libffi)	sed -e '/^includesdir/ s/$(libdir).*$/$(includedir)/' -i include/Makefile.in &&
         	sed -e '/^includedir/ s/=.*$/=@includedir@/' -e 's/^Cflags: -I${includedir}/Cflags:/' -i libffi.pc.in        
                config
                ;;		
     Python)	config '--enable-shared --with-system-expat --with-system-ffi --without-ensurepip'
     		;;
     libxml2)	sed -e /xmlInitializeCatalog/d -e 's/((ent->checked =.*&&/(((ent->checked == 0) || ((ent->children == NULL) \&\& (ctxt->options \& XML_PARSE_NOENT))) \&\&/' -i parser.c
		config '--with-history'
		;;
     pciutils)  make PREFIX=/usr SHAREDIR=/usr/share/misc SHARED=yes
     		make PREFIX=/usr SHAREDIR=/usr/share/misc SHARED=yes install install-lib
     		chmod -v 755 /usr/lib/libpci.so
     		;;
     libusb)    config1  ;;
     usbutils)  sed -i '/^usbids/ s:usb.ids:misc/&:' lsusb.py 
     		config '--datadir=/usr/share/misc'
     		/usr/bin/wget http://www.linux-usb.org/usb.ids -O /usr/share/misc/usb.ids
     		;;
     #libdrm)	patch < ../libdrm-*.patch
     #		config '--enable-udev --disable-valgrind'
     #		;;
     curl)	config '--enable-threaded-resolver'
		;;
     git)	config '--with-gitconfig=/etc/gitconfig'
     		;;

     *)        	config
      		;;     		
  esac
  
  cd /BLFS/SOURCE ; rm -rf $ordnerdir   
done
fi


# Wayland 
if test $1 = wayland
then
export WLD=/opt/wayland
export LD_LIBRARY_PATH=$WLD/lib
export PKG_CONFIG_PATH=$WLD/lib/pkgconfig/:$WLD/share/pkgconfig/
export PATH=$WLD/bin:$PATH
export ACLOCAL_PATH=$WLD/share/aclocal
export ACLOCAL="aclocal -I $ACLOCAL_PATH"
mkdir -p $WLD/share/aclocal # needed by autotools

#git clone git://anongit.freedesktop.org/wayland/wayland
#cd wayland
#./autogen.sh --prefix=$WLD --disable-documentation
#make -j 4 && make install
#cd ..

#/usr/bin/wget http://pkgs.fedoraproject.org/repo/pkgs/xorg-x11-util-macros/util-macros-1.19.0.tar.bz2/1cf984125e75f8204938d998a8b6c1e1/util-macros-1.19.0.tar.bz2
#tar xvf util-macros-1.19.0.tar.bz2
#cd util-macros-1.19.0
#./configure --prefix=$WLD
#make 
#make install
#cd ..

#git clone git://anongit.freedesktop.org/xorg/proto/glproto
#cd glproto
#./autogen.sh --prefix=$WLD --disable-documentation
#make -j 4 && make install
#cd ..

#git clone git://anongit.freedesktop.org/xorg/proto/dri2proto
#cd dri2proto
#./autogen.sh --prefix=$WLD --disable-documentation
#make -j 4 && make install
#cd ..

#git clone  git://anongit.freedesktop.org/xcb/proto
#cd proto
#./autogen.sh --prefix=$WLD --disable-documentation
#make -j 4 && make install
#cd ..

#git clone git://anongit.freedesktop.org/xcb/libxcb
#cd libxcb
#patch < ../libdrm-2.4.64.patch
#./autogen.sh --prefix=$WLD --disable-dri3 --disable-documentation
#make -j 4 && make install
#cd ..


#git clone git://anongit.freedesktop.org/mesa/mesa
#cd mesa
#./autogen.sh --prefix=$WLD --disable-dri3 --disable-gles1 --enable-gles2 --disable-gallium-egl --with-egl-platforms=wayland,drm --enable-gbm --with-gallium-drivers=nouveau
#make -j 4 && make install
#cd ..
    
#git clone git://anongit.freedesktop.org/wayland/libinput
#cd libinput
#./autogen.sh --prefix=$WLD
#make && make install
#cd ..    
#    
#git clone git://anongit.freedesktop.org/wayland/weston
#cd weston
#./autogen.sh --prefix=$WLD --disable-libunwind
#make -j 4 && make install
#cd ..
fi



############## XORG SOLLTE AB HIER INSTALLIERT SEIN !!! #####################

if test $1 = stage50
then
wget http://cairographics.org/releases/cairo-1.10.2.tar.gz
./configure --prefix=/usr --with-x 
make -j 8 && make install
fi

if test $1 = stage51
then
wget http://ftp.gnome.org/pub/gnome/sources/pango/1.28/pango-1.28.3.tar.bz2
./configure --prefix=/usr --sysconfdir=/etc --with-x
make && make install
fi

if test $1 = stage52
then
wget http://ftp.acc.umu.se/pub/gnome/sources/atk/1.33/atk-1.33.6.tar.gz
config
fi

if test $1 = stage53
then
wget http://www.ece.uvic.ca/~mdadams/jasper/software/jasper-1.900.1.zip
unzip jasper-1.900.1.zip
cd jasper-1.900.1
./configure --enable-shared --prefix=/usr && make && make install
fi


if test $1 = stage53a
then
wget http://archive.ubuntu.com/ubuntu/pool/main/g/gdk-pixbuf/gdk-pixbuf_2.23.1.orig.tar.gz
cd gdk-pixbuf-2.23.1
config
fi

if test $1 = stage54
then
wget ftp://ftp.gtk.org/pub/gtk/2.24/gtk+-2.24.1.tar.bz2
./configure --prefix=/usr --sysconfdir=/etc
make && make install
fi

if test $1 = stage55
then
wget ftp://ftp.gnome.org/pub/gnome/sources/startup-notification/0.9/startup-notification-0.9.tar.bz2
config
fi

#if test $1 = stage55
#then
#echo "QT3 ist nicht mehr noetig !!!!"
#echo "Noch testen..."
#sleep 10
###/usr/bin/wget ftp://ftp.trolltech.com/qt/source/qt-x11-free-3.3.8b.tar.bz2
#wget ftp://ftp.trolltech.com/qt/source/qt-x11-free-3.3.8b.tar.gz
###tar xvf qt-x11-free-3.3.8b.tar.bz2
#cd ..
#mv qt-x11-free-3.3.8b /usr/lib/
#ln -s /usr/lib/qt-x11-free-3.3.8b /usr/lib/qt
#cd /usr/lib/qt
#./configure -prefix /usr/lib/qt -sysconfdir /etc/qt -qt-gif -system-zlib -system-libpng \
#             -system-libjpeg -system-libmng -plugin-imgfmt-png -plugin-imgfmt-jpeg \
#            -plugin-imgfmt-mng -no-exceptions -thread -tablet -xinerama  -xft
#cd qmake
#make clean
#rm qmake
#sed -i 's@-pipe@-O2 -s -fomit-frame-pointer@g' Makefile
#make
#cd ..
#make -j 4
#ln -s /usr/lib/qt/lib/libqt-mt.so /usr/lib/qt/lib/libqt.so
#cd ..
#fi
	
if test $1 = stage56
then
wget ftp://ftp.alsa-project.org/pub/lib/alsa-lib-1.0.24.1.tar.bz2
config
fi

if test $1 = stage57
then
wget ftp://ftp.alsa-project.org/pub/utils/alsa-utils-1.0.24.2.tar.bz2
./configure --prefix=/usr
sed -i 's@xmlto man $?@#xmlto man $?@g' alsactl/Makefile
touch alsactl/alsactl_init.7
make && make install
fi

if test $1 = stage58
then
wget ftp://ftp.alsa-project.org/pub/oss-lib/alsa-oss-1.0.17.tar.bz2
config
fi

if test $1 = stage59
then
wget http://bent.latency.net/bent/git/aumix-2.8/src/aumix-2.8.tar.bz2
config
fi

if test $1 = stage60
then
wget http://www.68k.org/~michael/audiofile/audiofile-0.2.7.tar.gz
config
fi

if test $1 = stage61
then
wget http://www.libsdl.org/release/SDL-1.2.14.tar.gz
config
fi

if test $1 = stage62
then
wget http://downloads.xiph.org/releases/ao/libao-1.1.0.tar.gz
config
fi

if test $1 = stage63
then
wget http://downloads.xiph.org/releases/ogg/libogg-1.2.2.tar.gz
config
fi

if test $1 = stage64
then
wget http://downloads.xiph.org/releases/vorbis/libvorbis-1.3.2.tar.gz
config
fi

if test $1 = stage65
then
wget http://downloads.sourceforge.net/heroines/libmpeg3-1.8-src.tar.bz2
cd libmpeg3-1.8
#wget http://www.linuxfromscratch.org/patches/blfs/svn/libmpeg3-1.7-makefile_mods-1.patch
config
fi

if test $1 = stage66
then
wget ftp://ftp.mars.org/pub/mpeg/libmad-0.15.1b.tar.gz
cat > /usr/lib/pkgconfig/mad.pc << "EOF"
prefix=/usr
exec_prefix=${prefix}
libdir=${exec_prefix}/lib
includedir=${prefix}/include

Name: mad
Description: MPEG audio decoder
Requires:
Version: 0.15.1b
Libs: -L${libdir} -lmad
Cflags: -I${includedir}
EOF
./configure --prefix=/usr 
sed -i 's@-fforce-mem@ @g' Makefile
make && make install
fi

if test $1 = stage67
then
wget http://heanet.dl.sourceforge.net/sourceforge/easytag/id3lib-3.8.3-2.tar.gz
cd id3lib-3.8.3
wget http://www.linuxfromscratch.org/patches/blfs/svn/id3lib-3.8.3-gcc43-1.patch
wget http://www.linuxfromscratch.org/patches/blfs/svn/id3lib-3.8.3-test_suite-1.patch
#wget http://ftp.debian.org/debian/pool/main/e/easytag/easytag_2.1.6.orig.tar.gz
#cd easytag-2.1.6
config
fi



if test $1 = stage68
then
wget http://downloads.xiph.org/releases/flac/flac-1.2.1.tar.gz
#wget http://www.linuxfromscratch.org/patches/blfs/svn/flac-1.2.1-gcc43-1.patch
sed -i 's/#include <stdio.h>/&\n#include <string.h>/' \
    examples/cpp/encode/file/main.cpp &&
./configure --prefix=/usr --disable-thorough-tests &&
make && make install
fi

if test $1 = stage69
then
wget http://www.videolan.org/pub/libdvdcss/1.2.10/libdvdcss-1.2.10.tar.bz2
config
fi

if test $1 = stage70
then
wget http://www.dtek.chalmers.se/groups/dvd/dist/libdvdread-0.9.7.tar.gz
config
fi

if test $1 = stage71
then
wget http://liba52.sourceforge.net/files/a52dec-0.7.4.tar.gz
config
fi

if test $1 = stage72
then
wget http://www.tortall.net/projects/yasm/releases/yasm-1.1.0.tar.gz
config
fi

if test $1 = stage73
then
wget http://downloads.xvid.org/downloads/xvidcore-1.3.0.tar.gz
cd xvidcore/build/generic
config
echo "Configuring XVID libs..."
chmod -v 755 /usr/lib/libxvidcore.so.4.3
ln -v -sf libxvidcore.so.4.2 /usr/lib/libxvidcore.so.4
ln -v -sf libxvidcore.so.4 /usr/lib/libxvidcore.so
fi

if test $1 = stage74
then
wget http://surfnet.dl.sourceforge.net/sourceforge/mikmod/libmikmod-3.1.12.tar.gz
config
fi

if test $1 = stage75
then
#wget http://surfnet.dl.sourceforge.net/sourceforge/mpg123/mpg123-1.5.1.tar.bz2
wget http://switch.dl.sourceforge.net/sourceforge/mpg123/mpg123-1.13.2.tar.bz2
config
fi

if test $1 = stage76
then
wget http://downloads.xiph.org/releases/vorbis/vorbis-tools-1.2.0.tar.gz
config
fi

if test $1 = stage77
then
wget http://kent.dl.sourceforge.net/sourceforge/lame/lame-3.98.4.tar.gz
cd lame-3.98
config
fi

if test $1 = stage78
then
wget http://downloads.xiph.org/releases/cdparanoia/cdparanoia-III-10.2.src.tgz
wget http://www.linuxfromscratch.org/patches/blfs/svn/cdparanoia-III-10.2-gcc_fixes-1.patch
sed -i 's@ac_cv_type_int16_t=no@ac_cv_type_int16_t=yes@g' configure
sed -i 's@ac_cv_type_int32_t=no@ac_cv_type_int32_t=yes@g' configure
./configure --prefix=/usr
#sed -i 's@OPT=-O $(FLAGS)@OPT=-O2 -fpic $(FLAGS)@g' Makefile
make && make install
fi


if test $1 = stage79
then
#wget ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/pcre-7.6.tar.bz2
#wget http://www.linuxfromscratch.org/patches/blfs/svn/pcre-7.6-abi_breakage-1.patch
wget ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/pcre-8.12.tar.bz2
./configure --prefix=/usr --docdir=/usr/share/doc/pcre-8.12 \
--enable-utf8 --enable-unicode-properties --enable-pcregrep-libz \
--enable-pcregrep-libbz2
make && make install
fi

if test $1 = stage80
then
wget ftp://ftp.gnome.org/pub/gnome/sources/libart_lgpl/2.3/libart_lgpl-2.3.21.tar.bz2
config
fi

if test $1 = stage81
then
wget http://downloads.sourceforge.net/cdrdao/cdrdao-1.2.2.tar.bz2
wget http://www.linuxfromscratch.org/patches/blfs/svn/cdrdao-1.2.2-glibc210_fixes-1.patch
wget http://www.linuxfromscratch.org/patches/blfs/svn/cdrdao-1.2.2-gcc43_fixes-2.patch
config
fi

if test $1 = stage82
then
wget ftp://ftp.berlios.de/pub/cdrecord/ProDVD/recent/cdrtools-3.01a03.tar.gz
cd cdrtools-3.01
make INS_BASE=/usr DEFINSUSR=root DEFINSGRP=root
make INS_BASE=/usr DEFINSUSR=root DEFINSGRP=root install
fi

if test $1 = stage83
then
wget http://fy.chalmers.se/~appro/linux/DVD+RW/tools/dvd+rw-tools-7.1.tar.gz
sed -i 's@#include <sys/time.h>@#include <sys/time.h>\n#include <limits.h>@g' transport.hxx
make all
make prefix=/usr install
fi

if test $1 = stage84
then
wget http://www.mega-nerd.com/libsndfile/files/libsndfile-1.0.23.tar.gz
./configure --prefix=/usr --disable-flac
make && make install
fi

if test $1 = stage85
then
wget http://heanet.dl.sourceforge.net/sourceforge/ghostscript/ghostscript-9.01.tar.bz2
CXXFLAGS="-O2 -fpic" CFLAGS="-O2 -fpic" CC="" CXX="" ./configure --prefix=/usr
make -j 8
make install
make -j 8 so
make soinstall
install -v -d -m755 /usr/include/ps 
#install -v -m644 src/*.h /usr/include/ps 
#ln -v -s ps /usr/include/ghostscript
fi

if test $1 = stage86
then
test -e ghostscript-fonts-std-8.11.tar.gz || \
/usr/bin/wget -c http://heanet.dl.sourceforge.net/sourceforge/ghostscript/ghostscript-fonts-std-8.11.tar.gz
test -e gnu-gs-fonts-other-6.0.tar.gz || \
/usr/bin/wget -c http://heanet.dl.sourceforge.net/sourceforge/ghostscript/ghostscript-fonts-std-6.0.tar.gz
tar -xvf ghostscript-fonts-std-8.11.tar.gz -C /usr/share/ghostscript
tar -xvf ghostscript-fonts-std-6.0.tar.gz  -C /usr/share/ghostscript
fi


if test $1 = stage87
then
wget ftp://ftp.gnu.org/gnu/a2ps/a2ps-4.14.tar.gz
sed -i 's/+0 -1/-k 1,2/' afm/make_fonts_map.sh &&
sed -i "s|/usr/local/share|/usr/share|" configure &&
./configure --prefix=/usr --sysconfdir=/etc/a2ps \
--enable-shared --with-medium=letter
make &&
make install
fi

if test $1 = stage88
then
wget ftp://ftp.enst.fr/pub/unix/a2ps/i18n-fonts-0.1.tar.gz
cp -v fonts/* /usr/share/a2ps/fonts
cp -v afm/* /usr/share/a2ps/afm
cd /usr/share/a2ps/afm
sed -i 's/for file in $files/for file in $(ls *.afm)/' make_fonts_map.sh
./make_fonts_map.sh
mv fonts.map.new fonts.map
fi

if test $1 = stage89
then
wget http://download.uni-hd.de/ftp/pub/gnu/enscript/enscript-1.6.5.2.tar.gz
#wget http://www.linuxfromscratch.org/patches/blfs/svn/enscript-1.6.4-security_fixes-1.patch
CC="" ./configure --prefix=/usr --sysconfdir=/etc/enscript --localstatedir=/var --with-media=A4 
make && make install
fi

if test $1 = stage90
then
wget http://gd.tuwien.ac.at/publishing/tex/tex-utils/psutils/psutils-p17.tar.gz
cd psutils
sed 's@/usr/local@/usr@g' Makefile.unix > Makefile
make && make install
fi

if test $1 = stage91
then
#wget ftp://ftp2.sane-project.org/pub/sane/old-versions/sane-backends-1.0.19/sane-backends-1.0.19.tar.gz
wget ftp://ftp2.sane-project.org/pub/sane/sane-backends-1.0.22/sane-backends-1.0.22.tar.gz
./configure --prefix=/usr --sysconfdir=/etc && make && make install
fi

if test $1 = stage92
then
#wget ftp://ftp2.sane-project.org/pub/sane/sane-frontends-1.0.14/sane-frontends-1.0.14.tar.gz
wget ftp://ftp2.sane-project.org/pub/sane/xsane/xsane-0.998.tar.gz
config
fi

if test $1 = stage93
then
adir=$(pwd)
#cd /usr/X11/lib/X11/fonts
cd /usr/X11/lib/fonts/X11 &&
tar xvf $adir/../EXTRA/windows_fonts.tar.gz
tar xvf $adir/../EXTRA/amiga_fonts.tar.gz
fi

if test $1 = stage94
then
wget http://developer.kde.org/~wheeler/files/src/taglib-1.6.3.tar.gz
config
fi

if test $1 = stage95
then
wget http://downloads.sourceforge.net/enlightenment/imlib2-1.4.4.tar.gz
#wget http://www.linuxfromscratch.org/patches/blfs/svn/imlib2-1.4.2-CVE-2008-5187.patch
#wget ftp://ftp.gnome.org/pub/gnome/sources/imlib/1.9/imlib-1.9.15.tar.bz2
./configure --prefix=/usr --sysconfdir=/etc/imlib && make && make install
fi

if test $1 = stage96
then
wget ftp://ftp.andrew.cmu.edu/pub/cyrus-mail/cyrus-sasl-2.1.23.tar.gz
CXXFLAGS="-O2 -fpic" CFLAGS="-O2 -fpic" CC="gcc336" CXX="gcc336" \
./configure --prefix=/usr --sysconfdir=/etc --with-dbpath=/var/lib/sasl/sasldb2 --with-saslauthd=/var/run/saslauthd
cd saslauthd
CXXFLAGS="-O2 -fpic" CFLAGS="-O2 -fpic" CC="gcc336" CXX="gcc336" \
./configure --prefix=/usr --sysconfdir=/etc --with-dbpath=/var/lib/sasl/sasldb2 --with-saslauthd=/var/run/saslauthd
cd ..                        
make && make install
fi

if test $1 = stage97
then
wget ftp://ftp.gnu.org/gnu/gmp/gmp-4.3.2.tar.bz2
config
fi

if test $1 = stage98
then
wget http://downloads.sourceforge.net/project/mad/libid3tag/0.15.1b/libid3tag-0.15.1b.tar.gz
config 
cd ..
wget http://ftp.debian.org/debian/pool/main/e/easytag/easytag_2.1.6.orig.tar.gz
cd easytag-2.1.6
config
fi

if test $1 = stage99
then
wget ftp://ftp.gnome.org/pub/gnome/sources/librsvg/2.32/librsvg-2.32.1.tar.bz2
./configure --prefix=/usr --sysconfdir=/etc --disable-mozilla-plugin
make && make install
fi

if test $1 = stage100
then
wget ftp://ftp.gnupg.org/gcrypt/libgpg-error/libgpg-error-1.9.tar.bz2
config
fi

if test $1 = stage101
then
wget ftp://ftp.gnupg.org/gcrypt/gpgme/gpgme-1.2.0.tar.bz2
config
fi

if test $1 = stage102
then
wget ftp://ftp.gnome.org/pub/gnome/sources/libglade/2.6/libglade-2.6.4.tar.bz2
config
fi


#if test $1 = stage103
#then
#echo "ToDo: nfs,kvm-qemu,sdlmame,gimp,avidemux,licq,xchat,sweep,tvtime,blender,..."
#fi




# --- FIREFOX --- #
FVERSION=3.6.15

if test $1 = stage105
then
wget http://ftp.gnome.org/pub/gnome/sources/libIDL/0.8/libIDL-0.8.14.tar.bz2
./configure --prefix=/opt/firefox-$FVERSION && make && make install
ln -s /opt/firefox-$FVERSION /opt/firefox
echo "/opt/firefox/lib" >> /etc/ld.so.conf
ldconfig
fi

if test $1 = stage106
then
wget http://download.gnome.org/sources/libnotify/0.5/libnotify-0.5.0.tar.bz2
./configure --prefix=/opt/firefox-$FVERSION && make && make install
ldconfig
fi

if test $1 = stage107
then
wget ftp://ftp.mozilla.org/pub/mozilla.org/firefox/releases/$FVERSION/source/firefox-$FVERSION.source.tar.bz2
cd mozilla-*
PKG_CONFIG_PATH="/usr/X11/lib/pkgconfig:/opt/firefox-$FVERSION/lib/pkgconfig" \
./configure --prefix=/opt/firefox-$FVERSION --with-system-zlib --with-system-jpeg --enable-system-cairo  \
  --enable-svg --enable-strip --disable-tests --disable-installer --disable-accessibility --enable-xinerama \
  --enable-application=browser --disable-crashreporter
sed -i 's@$(LIBS_DIR)@$(LIBS_DIR) -L/usr/X11R6/lib -lXrender -lX11@g' layout/build/Makefile
make -j $J
make install
fi


# --- MPLAYER --- #
if test $1 = stage110
then
#wget ftp://ftp.videolan.org/pub/videolan/x264/snapshots/x264-snapshot-20090407-2245.tar.bz2
#wget ftp://ftp.videolan.org/pub/videolan/x264/snapshots/x264-snapshot-20091124-2245.tar.bz2
wget ftp://ftp.videolan.org/pub/videolan/x264/snapshots/x264-snapshot-20110309-2245.tar.bz2
./configure --prefix=/usr && make && make install
fi

if test $1 = stage111
then
wget http://dl.matroska.org/downloads/libebml/libebml-1.2.0.tar.bz2
cd make/linux
sed -i 's@prefix=/usr/local@prefix=/usr@g' Makefile
make && make install
fi

if test $1 = stage112
then
wget http://dl.matroska.org/downloads/libmatroska/libmatroska-1.1.0.tar.bz2
cd make/linux
sed -i 's@prefix=/usr/local@prefix=/usr@g' Makefile
make && make install
#echo ""
#echo "start stage112boost"
fi

# boost wird von KDE4 und mkvtoolnix genutzt
# klappt nicht hier im script !?!? Erstellt bjam nicht
# ansonsten copy&paste auf die konsole 
if test $1 = stage113
then
wget http://downloads.sourceforge.net/project/boost/boost/1.46.0/boost_1_46_0.tar.bz2
cd boost_1_46_0
./bootstrap.sh --prefix=/usr
./bjam --layout=versioned
./bjam install --prefix=/usr --layout=versioned
ln -s /usr/include/boost-1_46/boost /usr/include/boost
fi

# ruby wird fuer mkvtoolnix-4.5.0 benoetigt
if test $1 = stage114
then
wget ftp://ftp.ruby-lang.org:21//pub/ruby/1.9/ruby-1.9.2-p180.tar.gz
CFLAGS="-O2 -s -pipe -fpic -fPIC " CC="gcc -s -fpic -fPIC " config
fi

if test $1 = stage115
then
#wget http://www.bunkus.org/videotools/mkvtoolnix/sources/mkvtoolnix-2.9.8.tar.bz2
wget http://www.bunkus.org/videotools/mkvtoolnix/sources/mkvtoolnix-4.6.0.tar.bz2
config
./drake
./drake install
fi

if test $1 = stage116
then
echo ""
echo ""
echo "Damit der mplayer VDPAU Unterstuetzung hat (h264 Hardwarebeschleunigung) muss"
echo "JETZT der Nvidia Treiber installiert werden !!!"
echo "Ansonsten weiter bei stage116"
echo ""
fi


if test $1 = stage117
then
wget ftp://ftp.mplayerhq.hu/MPlayer/releases/mplayer-checkout-snapshot.tar.bz2
wget http://ffmpeg.org/releases/ffmpeg-snapshot-git.tar.bz2
cd mplayer-checkout-*
mv ../ffmpeg-*.git ffmpeg
./configure --prefix=/usr &&
make -j 8 && make install 
fi

if test $1 = stage118
then
wget http://linuxtv.org/downloads/linuxtv-dvb-apps-1.1.1.tar.gz
make
cp util/szap/czap /usr/sbin
cp util/szap/szap /usr/sbin
cp util/szap/tzap /usr/sbin
fi




# !------------- weitere media libs ---------------!
if test $1 = stage120
then
wget http://www.mega-nerd.com/SRC/libsamplerate-0.1.7.tar.gz
config
fi

if test $1 = stage121
then
wget http://garr.dl.sourceforge.net/sourceforge/gtkpod/libgpod-0.7.0.tar.gz
./configure --prefix=/usr
sed -i 's@SUBDIRS = src tools tests po m4 docs bindings@SUBDIRS = src tools po m4 docs bindings@g' Makefile
make -j 8 && make install
fi

if test $1 = stage123
then
wget http://switch.dl.sourceforge.net/sourceforge/gtkpod/gtkpod-1.0.0.tar.gz
config
fi
# !------------------------------------------------!




if test $1 = stage129
then
echo ""
echo "Weiter gehts mit KDE4 !!!"
echo "Dann stage130"
echo ""
fi


# --- Audacious --- # DER! XMMS replacer
if test $1 = stage130
then
wget http://home.arcor.de/ms2002sep/bak/libsidplay-1.36.59.tar.bz2
CXXFLAGS="-O2 " CXX="/opt/gcc336/bin/g++" ./configure --prefix=/opt/audacious && make && make install
fi

#if test $1 = stage131
#then
#wget http://ftp.gnome.org/pub/GNOME/sources/libglade/2.4/libglade-2.4.2.tar.gz
#./configure --prefix=/opt/audacious && make && make install
#echo "/opt/audacious/lib" >> /etc/ld.so.conf
#ldconfig
#fi

if test $1 = stage132
then
wget http://distfiles.atheme.org/libmowgli-0.7.0.tgz
#wget http://contrib.pardus.org.tr/archives/libmowgli-0.7.0.tgz
cd libmowgli-0.7.0
./configure --prefix=/opt/audacious && make && make install
fi

if test $1 = stage133
then
wget http://distfiles.atheme.org/libmcs-0.7.1.tgz
cd libmcs-0.7.1
PKG_CONFIG_PATH="/usr/X11/lib/pkgconfig:/opt/audacious/lib/pkgconfig" ./configure --prefix=/opt/audacious && make && make install
fi

#if test $1 = stage134
#then
#wget http://www.mega-nerd.com/SRC/libsamplerate-0.1.3.tar.gz
#./configure --prefix=/opt/audacious && make && make install
#fi

if test $1 = stage135
then
wget http://distfiles.atheme.org/audacious-2.2.tgz
cd audacious-2.2
PKG_CONFIG_PATH="/usr/X11/lib/pkgconfig:/opt/audacious/lib/pkgconfig" \
PATH="/bin:/usr/bin:/sbin:/usr/sbin:/usr/X11/bin:/opt/kde4/bin:/opt/audacious/bin" \
CFLAGS="-L/opt/audacious/lib -O2 -s " \
./configure --prefix=/opt/audacious --enable-one-plugin-dir --enable-samplerate 
sed -i 's@LDFLAGS += ${PROG_IMPLIB_LDFLAGS}@LDFLAGS += ${PROG_IMPLIB_LDFLAGS} -lgthread-2.0 @g' src/audacious/Makefile
make && make install
fi

if test $1 = stage136
then
wget http://www.webdav.org/neon/neon-0.29.0.tar.gz
CFLAGS="-O2 -fPIC" ./configure --prefix=/opt/audacious && make && make install
fi

if test $1 = stage137
then
wget http://distfiles.atheme.org/audacious-plugins-2.2.tgz
cd audacious-plugins-2.2
PKG_CONFIG_PATH="/usr/X11/lib/pkgconfig:/opt/audacious/lib/pkgconfig" \
PATH="/bin:/usr/bin:/sbin:/usr/sbin:/usr/X11/bin:/opt/kde4/bin:/opt/audacious/bin" \
CFLAGS="-L/opt/audacious/lib -O2 -s " \
./configure --prefix=/opt/audacious --disable-dbus --disable-arts --disable-gnomeshortcuts --with-sidplay1=/opt/audacious
make && make install
fi


if test $1 = stage138
then
wget http://zakalwe.fi/uade/uade2/uade-2.13.tar.bz2
sed -i 's@.get_song_info = uade_get_song_info,@//.get_song_info = uade_get_song_info,@g' src/frontends/audacious/plugin.c
PKG_CONFIG_PATH="/usr/X11/lib/pkgconfig:/opt/audacious/lib/pkgconfig" \
PATH="/bin:/usr/bin:/sbin:/usr/sbin:/usr/X11/bin:/opt/kde4/bin:/usr/lib/qt/bin:/opt/audacious/bin" \
./configure --prefix=/opt/audacious && make && make install
fi

if test $1 = stage139
then
cd /opt/audacious/lib/audacious/Plugins
ln -s /opt/audacious/lib/audacious/Container/* . 
ln -s /opt/audacious/lib/audacious/Effect/* .
ln -s /opt/audacious/lib/audacious/General/* .
ln -s /opt/audacious/lib/audacious/Input/* .
ln -s /opt/audacious/lib/audacious/Output/* .
ln -s /opt/audacious/lib/audacious/Transport/* .
ln -s /opt/audacious/lib/audacious/Visualization/* .
fi


# --- Gimp --- #
if test $1 = stage140
then
wget http://ftp.gnome.org/pub/GNOME/sources/pygobject/2.20/pygobject-2.20.0.tar.bz2
config
fi

if test $1 = stage142
then
wget http://ftp.gnome.org/pub/GNOME/sources/pygtk/2.16/pygtk-2.16.0.tar.bz2
config
fi

if test $1 = stage141
then
wget http://www.cairographics.org/releases/pycairo-1.8.8.tar.gz
config
fi

if test $1 = stage143
then
wget ftp://ftp.gtk.org/pub/babl/0.1/babl-0.1.0.tar.bz2
PKG_CONFIG_PATH="/usr/X11/lib/pkgconfig:/opt/gimp/lib/pkgconfig" \
PATH="/bin:/usr/bin:/sbin:/usr/sbin:/usr/X11/bin:/opt/kde4/bin:/opt/gimp/bin" \
CFLAGS="-L/opt/gimp/lib -O2 -s " \
./configure --prefix=/opt/gimp
make && make install
fi

if test $1 = stage144
then
wget ftp://ftp.gimp.org/pub/gegl/0.1/gegl-0.1.0.tar.bz2
PKG_CONFIG_PATH="/usr/X11/lib/pkgconfig:/opt/gimp/lib/pkgconfig" \
PATH="/bin:/usr/bin:/sbin:/usr/sbin:/usr/X11/bin:/opt/kde4/bin:/opt/gimp/bin" \
CFLAGS="-L/opt/gimp/lib -O2 -s " \
./configure --prefix=/opt/gimp
make && make install
fi

if test $1 = stage145
then
wget ftp://ftp.gimp.org/pub/gimp/v2.6/gimp-2.6.7.tar.bz2
PKG_CONFIG_PATH="/usr/X11/lib/pkgconfig:/opt/gimp/lib/pkgconfig" \
PATH="/bin:/usr/bin:/sbin:/usr/sbin:/usr/X11/bin:/opt/kde4/bin:/opt/gimp/bin" \
CFLAGS="-L/opt/gimp/lib -O2 -s " \
./configure --prefix=/opt/gimp
make -j 8 && make install
fi




# ! ---- Exaile Audio Player ---- ! #

# Das fehlt noch:
#  Python 2.4 or Python 2.5 
#  python-gtk2 ( >= 2.10) 
#  python-glade2 
#  gstreamer0.10, gstreamer0.10-plugins-good 
#  python-gst0.10 or python-gstreamer0.10 
#  python-dbus 
#  python-mutagen
#  python-cddb (for audio CD playback) - you may need to install python-eyed3 as well 
#  python-gpod (for iPod support) 
#  gstreamer0.10-plugins-ugly (for MP3 support) 
#  gstreamer0.10-gnomevfs (for SHOUTcast support) 
#  gstreamer0.10-plugins-bad >= 0.10.5 (for Equalizer support) (Feisty packages available here) 
#  python-sexy or sexy-python (to add a clear button to filters) 
#  python-gnome2-extras or some similarly-named package (for lyrics, better tray icon, etc.)


# Exaile oder Rhythmbox - was ist besser als Amarok ? 
# kommt noch :)
#
# braucht 20+ python pakete :(
#if test $1 = stage125
#then
#wget http://www.exaile.org/files/exaile_0.2.14.tar.gz
#cd "exaile-0.2.14/"
#./configure --prefix=/opt/exaile &&
#make -j 8 && make install
#fi

# braucht 15+ gnome pakete :(
#if test $1 = stage124
#then
#wget http://ftp.gnome.org/pub/gnome/sources/rhythmbox/0.12/rhythmbox-0.12.0.tar.bz2
#./configure --prefix=/opt/rhythmbox && make -j 8 && make install
#fi








if test $1 = personal_first_startup
then
echo "copy: xorg.conf xmodmap.map"
cp -a ../EXTRA/Mirko/xorg.conf      /etc/X11/
cp -a ../EXTRA/Mirko/xmodmap.map    /etc/X11/

echo "copy: .xinitrc .bash_profile .bashrc .icons"
cp -a ../EXTRA/Mirko/.xinitrc       /root/
cp -a ../EXTRA/Mirko/.bash_profile  /root/
cp -a ../EXTRA/Mirko/.bashrc        /root/
cp -a ../EXTRA/Mirko/.icons         /root/

echo "copy: rc.d "
cp -a ../EXTRA/Mirko/rc.d/*         /etc/rc.d/

echo "copy: .mplayer"
cp -a ../EXTRA/Mirko/.mplayer       /root/

echo "copy: .licq"
cp -a ../EXTRA/Mirko/.licq          /root/
fi

if test $1 = cleanup
then
ls -als . | grep drwx | awk ' {print "rm -rf " $NF;}'
fi
	