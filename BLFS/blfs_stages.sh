
if [ $# = 0 ]; then
        echo "Usage: $0 start"
        echo "!!!!!!! ../blfs_stages.sh Script starten im /BLFS/SOURCE Verzeichnis..."
        exit
fi

export LFS=/lfs
export CC="gcc -s "
export J=5

#cmake configs 
#cmake() {
#extra=$1
#mkdir -v build &&
#cd       build 
#cmake $extra ..
#make -j $J ; make install
#}

#Default configure fuer ~70% der Pakete
config () {
extra=$1
./configure $extra --disable-static --prefix=/usr && sleep 2 && make -j $J && make install
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

# Remove the # to build the SOURCE    
downloadliste=(
 #"http://ftp.gnu.org/gnu/gmp/gmp-6.0.0a.tar.xz"
 #"ftp://ftp.gnu.org/gnu/libtasn1/libtasn1-4.7.tar.gz"
 #"ftp://ftp.gnu.org/gnu/libidn/libidn-1.32.tar.gz"
 #"https://ftp.gnu.org/gnu/nettle/nettle-3.1.1.tar.gz"
 #"ftp://ftp.gnutls.org/gcrypt/gnutls/v3.4/gnutls-3.4.5.tar.xz"
 #"ftp://ftp.gnu.org/gnu/wget/wget-1.16.3.tar.gz"
 #"ftp://openssl.org/source/openssl-1.0.2d.tar.gz" 
 #"ftp://ftp.netfilter.org/pub/iptables/iptables-1.4.21.tar.bz2"
 #"ftp://ftp.gnupg.org/gcrypt/libgpg-error/libgpg-error-1.20.tar.bz2"
 #"ftp://ftp.gnupg.org/gcrypt/libgcrypt/libgcrypt-1.6.4.tar.bz2"
 #"ftp://ftp.gnupg.org/gcrypt/libassuan/libassuan-2.3.0.tar.bz2"
 #"ftp://ftp.gnupg.org/gcrypt/libksba/libksba-1.3.3.tar.bz2"
 #"ftp://ftp.gnupg.org/gcrypt/npth/npth-1.2.tar.bz2"
 #"ftp://ftp.gnupg.org/gcrypt/gnupg/gnupg-2.1.9.tar.bz2"
 #"ftp://ftp.gnu.org/pub/gnu/ed/ed-1.9.tar.gz"
 #"ftp://anduin.linuxfromscratch.org/BLFS/svn/p/popt-1.16.tar.gz"
 #"ftp://sourceware.org/pub/libffi/libffi-3.2.1.tar.gz"
 #"http://pkgs.fedoraproject.org/repo/pkgs/expat/expat-2.1.0.tar.gz/dd7dab7a5fea97d2a6a43f511449b7cd/expat-2.1.0.tar.gz"  
 #"https://www.python.org/ftp/python/3.5.0/Python-3.5.0.tar.xz"
 #"https://www.python.org/ftp/python/2.7.9/Python-2.7.9.tar.xz"
 #"ftp://xmlsoft.org/libxml2/libxml2-2.9.2.tar.gz"
 #"ftp://xmlsoft.org/libxslt/libxslt-1.1.28.tar.gz"
 #"http://ftp.acc.umu.se/pub/gnome/sources/glib/2.45/glib-2.45.8.tar.xz"
 #"ftp://ftp.gnu.org/gnu/which/which-2.21.tar.gz"
 #"https://www.kernel.org/pub/software/utils/pciutils/pciutils-3.4.0.tar.xz"
 #"ftp://ftp.x.org/pub/individual/lib/libpciaccess-0.13.4.tar.bz2"
 #"http://downloads.sourceforge.net/libusb/libusb-1.0.19.tar.bz2"
 #"http://downloads.sourceforge.net/libusb/libusb-compat-0.1.5.tar.bz2"
 #"ftp://ftp.kernel.org/pub/linux/utils/usb/usbutils/usbutils-008.tar.xz"
 #"http://curl.haxx.se/download/curl-7.45.0.tar.lzma"
 #"ftp://ftp.kernel.org/pub/software/scm/git/git-2.6.1.tar.xz"
 #"https://pypi.python.org/packages/source/s/setuptools/setuptools-17.1.1.tar.gz"
 #"https://pypi.python.org/packages/source/p/pip/pip-7.1.2.tar.gz"
 #"https://pypi.python.org/packages/source/M/MarkupSafe/MarkupSafe-0.23.tar.gz"
 #"https://pypi.python.org/packages/source/M/Mako/Mako-1.0.2.tar.gz"
 #"ftp://ftp.gnu.org/gnu/aspell/aspell-0.60.6.1.tar.gz"
 #"ftp://ftp.gnu.org/gnu/aspell/dict/de/aspell6-de-20030222-1.tar.bz2"
 #"http://downloads.sourceforge.net/hunspell/hunspell-1.3.3.tar.gz"
 #"http://www.oberhumer.com/opensource/lzo/download/lzo-2.09.tar.gz"
 #"http://ftp.osuosl.org/pub/blfs/conglomeration/unrarsrc/unrarsrc-5.3.3.tar.gz"
 #"http://www.nasm.us/pub/nasm/releasebuilds/2.11.08/nasm-2.11.08.tar.xz"
 #"http://downloads.sourceforge.net/libjpeg-turbo/libjpeg-turbo-1.4.2.tar.gz"
 #"http://downloads.sourceforge.net/libpng/libpng-1.6.18.tar.xz"
 #"ftp://ftp.remotesensing.org/libtiff/tiff-4.0.6.tar.gz"
 #"http://downloads.sourceforge.net/giflib/giflib-5.1.1.tar.bz2"
 #"http://downloads.sourceforge.net/project/lcms/lcms/2.7/lcms2-2.7.tar.gz"
 #"http://downloads.sourceforge.net/libmng/libmng-2.0.3.tar.xz"
 #"http://downloads.sourceforge.net/freetype/freetype-2.6.tar.bz2"
 #"http://www.freedesktop.org/software/fontconfig/release/fontconfig-2.11.1.tar.bz2"
 #"http://cairographics.org/releases/pixman-0.32.8.tar.gz"
 #"ftp://ftp.gnome.org/pub/gnome/sources/glib/2.46/glib-2.46.0.tar.xz"
 #"http://downloads.sourceforge.net/openjpeg.mirror/openjpeg-1.5.2.tar.gz"
 #"http://poppler.freedesktop.org/poppler-0.37.0.tar.xz"
 #"http://www.nico.schottelius.org/software/gpm/archives/gpm-1.20.7.tar.bz2"
 #"http://downloads.sourceforge.net/hdparm/hdparm-9.48.tar.gz"
 #"http://downloads.sourceforge.net/infozip/unzip60.tar.gz"
 #"ftp://ftp.info-zip.org/pub/infozip/src/zip30.tgz"
 #"ftp://ftp.gnu.org/pub/gnu/cpio/cpio-2.12.tar.bz2"
 #"http://downloads.sourceforge.net/p7zip/p7zip_9.38.1_src_all.tar.bz2"
 #"ftp://space.mit.edu/pub/davis/slang/v2.2/slang-2.2.4.tar.bz2"
 #"ftp://ftp.osuosl.org/pub/midnightcommander/mc-4.8.14.tar.xz"
 #"http://anduin.linuxfromscratch.org/files/BLFS/OpenJDK-1.8.0.51/OpenJDK-1.8.0.51-x86_64-bin.tar.xz"
 #"ftp://ftp.mirrorservice.org/sites/ftp.apache.org/apr/apr-1.5.2.tar.bz2"
 #"ftp://ftp.mirrorservice.org/sites/ftp.apache.org/apr/apr-util-1.5.4.tar.bz2" 
 #"https://www.sqlite.org/2015/sqlite-autoconf-3081101.tar.gz"
 #"http://www.apache.org/dist/subversion/subversion-1.9.2.tar.bz2"
 #"http://ftp.openbsd.org/pub/OpenBSD/LibreSSL/libressl-2.3.0.tar.gz"
 #"ftp://ftp.openbsd.org/pub/OpenBSD/OpenSSH/portable/openssh-7.0p1.tar.gz" 
 #"https://download.samba.org/pub/samba/stable/samba-4.3.0.tar.gz"
 #"http://www.hpl.hp.com/personal/Jean_Tourrilhes/Linux/wireless_tools.29.tar.gz"
 #"http://www.carisma.slowglass.com/~tgr/libnl/files/libnl-3.2.25.tar.gz"
 #"http://hostap.epitest.fi/releases/wpa_supplicant-2.4.tar.gz"
 #"http://www.linuxfromscratch.org/patches/blfs/systemd/libpcap-1.7.3-enable_bluetooth-1.patch"
 #"http://www.tcpdump.org/release/libpcap-1.7.4.tar.gz"
 #"http://www.tcpdump.org/release/tcpdump-4.7.4.tar.gz"
 #"http://www.libarchive.org/downloads/libarchive-3.1.2.tar.gz"
 #"http://www.cmake.org/files/v3.3/cmake-3.3.2.tar.gz"
 #"http://www.cpan.org/authors/id/E/ET/ETHER/URI-1.69.tar.gz"
 #"http://search.cpan.org/CPAN/authors/id/T/TO/TODDR/XML-Parser-2.44.tar.gz"
 #"http://www.freedesktop.org/software/libevdev/libevdev-1.4.4.tar.xz"
 #"ftp://ftp.gnu.org/gnu/gdb/gdb-7.10.tar.xz"
 #"X11NOW"
 #"http://cairographics.org/releases/cairo-1.14.2.tar.xz"
 #"http://www.freedesktop.org/software/harfbuzz/release/harfbuzz-1.0.4.tar.bz2"
 #"http://downloads.sourceforge.net/freetype/freetype-2.6.tar.bz2"
 #"ftp://ftp.gnome.org/pub/gnome/sources/pango/1.38/pango-1.38.0.tar.xz"
 #"ftp://ftp.gnome.org/pub/gnome/sources/atk/2.18/atk-2.18.0.tar.xz"
 #"ftp://ftp.gnome.org/pub/gnome/sources/gdk-pixbuf/2.32/gdk-pixbuf-2.32.1.tar.xz"
 #"http://icon-theme.freedesktop.org/releases/hicolor-icon-theme-0.15.tar.xz"
 #"ftp://ftp.gnome.org/pub/gnome/sources/gtk+/2.24/gtk+-2.24.28.tar.xz"
 #"http://www.tortall.net/projects/yasm/releases/yasm-1.3.0.tar.gz"
 
 #"ftp://ftp.alsa-project.org/pub/lib/alsa-lib-1.0.29.tar.bz2"
 #"ftp://downloads.xiph.org/pub/xiph/releases/ogg/libogg-1.3.2.tar.xz"
 #"http://downloads.xiph.org/releases/vorbis/libvorbis-1.3.5.tar.xz"
 #"ftp://downloads.xiph.org/pub/xiph/releases/flac/flac-1.3.1.tar.xz"
 #"http://www.mega-nerd.com/libsndfile/files/libsndfile-1.0.25.tar.gz"
 #"http://www.mega-nerd.com/SRC/libsamplerate-0.1.8.tar.gz"
 #"ftp://ftp.alsa-project.org/pub/plugins/alsa-plugins-1.0.29.tar.bz2"
 #"ftp://ftp.alsa-project.org/pub/utils/alsa-utils-1.0.29.tar.bz2"
 #"ftp://ftp.alsa-project.org/pub/oss-lib/alsa-oss-1.0.28.tar.bz2"
 #"ftp://ftp.gnome.org/pub/gnome/sources/audiofile/0.3/audiofile-0.3.6.tar.xz"
 #"http://downloads.sourceforge.net/opencore-amr/fdk-aac-0.1.4.tar.gz"
 #"http://jpj.net/~trevor/aumix/releases/aumix-2.9.1.tar.bz2"
 #"http://downloads.xiph.org/releases/theora/libtheora-1.1.1.tar.xz"
 #"http://storage.googleapis.com/downloads.webmproject.org/releases/webm/libvpx-1.4.0.tar.bz2"
 #"http://www.libsdl.org/release/SDL-1.2.15.tar.gz"
 #"https://github.com/taglib/taglib/releases/download/v1.9.1/taglib-1.9.1.tar.gz"
 #"http://download.videolan.org/pub/videolan/x264/snapshots/x264-snapshot-20150923-2245.tar.bz2"
 #"http://downloads.sourceforge.net/lame/lame-3.99.5.tar.gz"
 #"http://downloads.xiph.org/releases/ao/libao-1.2.0.tar.gz"
 #"http://downloads.xiph.org/releases/vorbis/vorbis-tools-1.4.0.tar.gz"
 #"http://download.videolan.org/libdvdcss/1.3.0/libdvdcss-1.3.0.tar.bz2"
 #"http://download.videolan.org/videolan/libdvdread/5.0.3/libdvdread-5.0.3.tar.bz2"
 #"http://download.videolan.org/videolan/libdvdnav/5.0.3/libdvdnav-5.0.3.tar.bz2"
 #"ftp://ftp.mars.org/pub/mpeg/libmad-0.15.1b.tar.gz"
 #"http://www.mpg123.de/download/mpg123-1.22.4.tar.bz2"
 #"http://dl.matroska.org/downloads/libebml/libebml-1.3.1.tar.bz2"
 #"http://dl.matroska.org/downloads/libmatroska/libmatroska-1.4.2.tar.bz2"
 ############## openssl muss neu installiert werden, danach klappt es mit qt und ruby
 #"ftp://openssl.org/source/openssl-1.0.2d.tar.gz" 
 #"http://cache.ruby-lang.org/pub/ruby/2.2/ruby-2.2.3.tar.xz"
 #"http://downloads.sourceforge.net/boost/boost_1_59_0.tar.bz2" 
 #"https://www.bunkus.org/videotools/mkvtoolnix/sources/mkvtoolnix-8.4.0.tar.xz"
 #"ftp://ftp.videolan.org/pub/videolan/libaacs/0.8.1/libaacs-0.8.1.tar.bz2"
 #"http://anduin.linuxfromscratch.org/sources/other/junit-4.11.jar"
 #"http://hamcrest.googlecode.com/files/hamcrest-1.3.tgz"
 #"https://archive.apache.org/dist/ant/source/apache-ant-1.9.6-src.tar.bz2"
 #"ftp://ftp.videolan.org/pub/videolan/libbluray/0.8.1/libbluray-0.8.1.tar.bz2"
 #"http://downloads.xvid.org/downloads/xvidcore-1.3.4.tar.gz"
 #"http://ffmpeg.org/releases/ffmpeg-snapshot-git.tar.bz2"
 #"ftp://ftp.mplayerhq.hu/MPlayer/releases/mplayer-checkout-snapshot.tar.bz2"
 #"http://linuxtv.org/downloads/legacy/linuxtv-dvb-apps-1.1.1.tar.gz"
 #"http://downloads.sourceforge.net/cdrdao/cdrdao-1.2.3.tar.bz2"
 #"http://sourceforge.net/projects/cdrtools/files/cdrtools-3.01.tar.bz2"
 #"http://fy.chalmers.se/~appro/linux/DVD+RW/tools/dvd+rw-tools-7.1.tar.gz" 
 #"http://downloads.webmproject.org/releases/webp/libwebp-0.4.3.tar.gz"
 #"http://www.linuxfromscratch.org/patches/blfs/svn/jasper-1.900.1-security_fixes-2.patch"
 #"http://www.ece.uvic.ca/~mdadams/jasper/software/jasper-1.900.1.zip"
 #"http://dbus.freedesktop.org/releases/dbus/dbus-1.10.0.tar.gz"
 #"http://download.icu-project.org/files/icu4c/55.1/icu4c-55_1-src.tgz"
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
 #"http://dbus.freedesktop.org/releases/dbus-glib/dbus-glib-0.104.tar.gz"
 #"http://libndp.org/files/libndp-1.5.tar.gz"
 #"ftp://ftp.gnome.org/pub/gnome/sources/libgudev/230/libgudev-230.tar.xz"
 #"https://ftp.mozilla.org/pub/mozilla.org/nspr/releases/v4.10.8/src/nspr-4.10.8.tar.gz"
 #"http://www.linuxfromscratch.org/patches/blfs/systemd/nss-3.20-standalone-1.patch"
 #"http://ftp.osuosl.org/pub/blfs/conglomeration/nss/nss-3.20.tar.gz"
 #"ftp://ftp.gnome.org/pub/gnome/sources/NetworkManager/1.0/NetworkManager-1.0.6.tar.xz"
 
 #"http://gstreamer.freedesktop.org/src/gstreamer/gstreamer-1.4.5.tar.xz"
 #"http://gstreamer.freedesktop.org/src/gst-plugins-base/gst-plugins-base-1.4.5.tar.xz"
 #"http://gstreamer.freedesktop.org/src/gst-plugins-good/gst-plugins-good-1.4.5.tar.xz"
 #"http://gstreamer.freedesktop.org/src/gst-plugins-bad/gst-plugins-bad-1.4.5.tar.xz"
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
 
 #"http://www.exiv2.org/exiv2-0.25.tar.gz"
 #"http://bitbucket.org/eigen/eigen/get/3.2.6.tar.bz2"
 #"http://pkgs.fedoraproject.org/repo/pkgs/libaccounts-glib/libaccounts-glib-1.18.tar.gz/fa37ebbe1cc1e8b738368ba86142c197/libaccounts-glib-1.18.tar.gz"
 ############ QT 5.5.0
 #"http://download.qt.io/archive/qt/5.5/5.5.0/single/qt-everywhere-opensource-src-5.5.0.tar.xz"
 #"https://sources.archlinux.org/other/packages/libaccounts-qt/accounts-qt-1.13.tar.bz2"
 #"http://archlinux.c3sl.ufpr.br/sources/packages/signond-8.58.tar.gz"
 ############ KDE5
 #"https://martine.github.io/ninja/ninja-1.6.tar.gz"
 #"telepathy-glib-0.24.1.tar.gz"
 #"libnice-0.1.13.tar.gz"
 #"KDENOW" 
);

if test $1 = checknew
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
     qt-everywhere-opensource-src-5.5.0)
     				export QT5PREFIX=/opt/qt5
     				mkdir /opt/qt-5.5.0
     				ln -sfnv qt-5.5.0 /opt/qt5
     				LIBRARY_PATH=/usr/X11/lib ./configure -reduce-exports -prefix /opt/qt-5.5.0 -sysconfdir /etc/xdg -confirm-license -opensource  \
     				-v -dbus-linked -openssl-linked -system-harfbuzz -system-sqlite -nomake examples -no-rpath  -optimized-qmake -skip qtwebengine -no-compile-examples
                                echo "/opt/qt5/lib" >> /etc/ld.so.conf
				LIBRARY_PATH=/usr/X11/lib make -j $J && make install
				find $QT5PREFIX/lib/pkgconfig -name "*.pc" -exec perl -pi -e "s, -L$PWD/?\S+,,g" {} \;
				find $QT5PREFIX -name qt_lib_bootstrap_private.pri -exec sed -i -e "s:$PWD/qtbase:/$QT5PREFIX/lib/:g" {} \; 
     				find $QT5PREFIX -name \*.prl -exec sed -i -e '/^QMAKE_PRL_BUILD_DIR/d' {} \; 
     				export QT5BINDIR=$QT5PREFIX/bin
     				for file in moc uic rcc qmake lconvert lrelease lupdate; do
     				  ln -sfv $QT5BINDIR/$file /usr/bin/$file-qt5
     				done
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
     ninja)        ./bootstrap.py ; cp ninja /usr/sbin/ ;;
     gdb)          config '--with-system-readline' ;;
     signon)       qmake PREFIX=/opt/qt5 LIBDIR=/opt/qt5/lib ; make -j5; make install ;;
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
                   install -v -m755 -d /usr/share/doc/openssh-7.0p1           &&
                   install -v -m644 INSTALL LICENCE OVERVIEW README* /usr/share/doc/openssh-7.0p1
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


if test $1 = cleanup
then
ls -als . | grep drwx | awk ' {print "rm -rf " $NF;}'
fi
	