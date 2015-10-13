#****************************************************************************
#
#  Filename: xorg_compiler.sh  v7.0 2015-OKT
#
#  (C) 2008,2009,2010,2011,2015 Mirko Roller
#
#  Description:
#     This file provides all necessary steps to build XORG 7.6
#
#  This program is free software; you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation; either version 2 of the License, or
#  (at your option) any later version.
#
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with this program; if not, write to the Free Software
#  Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
#
#****************************************************************************/

 
echo ""
echo "UNBEDINGT im XORG ausfuehren mit ../xorg_compiler.sh !!!"
echo "mit download, stage1, stage2, stage3, stage4 "
echo 
echo "Um die Quellen downzuloaden das script mit download starten !"
echo 
echo CFLAGS=$CFLAGS
echo 
echo "Press anyKey ! ;)"
read

# Bei jedem Fehler anhalten.
set -e


declare -x PKG_CONFIG_PATH="/usr/X11/lib/pkgconfig"
xorgversion=X11R7.7


# !!!!!!!!!!!!!! X11 !!!!!!!!!!!!!! #
export XORG_PREFIX="/usr/X11"
export XORG_CONFIG="--prefix=$XORG_PREFIX --sysconfdir=/etc --localstatedir=/var --datadir=$XORG_PREFIX/lib --mandir=$XORG_PREFIX/share/man"
export PKG_CONFIG_PATH="/usr/X11/lib/pkgconfig"
export ACLOCAL="aclocal -I /usr/X11/lib/aclocal" 
export ACLOCAL_PATH=/usr/X11/lib/aclocal
export LD_LIBRARY_PATH=/usr/X11/lib
# !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! #

if [ -z "$1" ]; then 
    echo "Bitte mit download,stage1,stage2,stage3... starten"
    exit
fi

# Downloaden aller X11 Paketindexe + Pakete die nicht von x.org kommen
if test $1 = download
then

test -e liste.txt || (
wget http://www.x.org/releases/$xorgversion/src/everything/
wget http://www.x.org/releases/individual/app/
wget http://www.x.org/releases/individual/data/
wget http://www.x.org/releases/individual/doc/
wget http://www.x.org/releases/individual/font/
wget http://www.x.org/releases/individual/lib/
wget http://www.x.org/releases/individual/proto/
wget http://www.x.org/releases/individual/util/
wget http://www.x.org/releases/individual/driver/
wget http://www.x.org/releases/individual/xserver/
cat index.html index.html.1 index.html.2 index.html.3 index.html.4 index.html.5 index.html.6 index.html.7 index.html.8 index.html.9   > liste.txt 
rm index*
)

wget -c http://xcb.freedesktop.org/dist/libxcb-1.11.1.tar.bz2
wget -c http://xcb.freedesktop.org/dist/xcb-proto-1.11.tar.bz2
test -e xcb-base-0.4.0.tar.bz2 || (wget -c http://xcb.freedesktop.org/dist/xcb-util-0.4.0.tar.bz2
mv xcb-util-0.4.0.tar.bz2 xcb-base-0.4.0.tar.bz2)
wget -c http://xcb.freedesktop.org/dist/xcb-util-image-0.4.0.tar.bz2
wget -c http://xcb.freedesktop.org/dist/xcb-util-keysyms-0.4.0.tar.bz2
wget -c http://xcb.freedesktop.org/dist/xcb-util-renderutil-0.3.9.tar.bz2
wget -c http://xcb.freedesktop.org/dist/xcb-util-wm-0.4.1.tar.bz2
wget -c http://xcb.freedesktop.org/dist/xcb-util-cursor-0.1.2.tar.gz
wget -c http://dri.freedesktop.org/libdrm/libdrm-2.4.65.tar.bz2
wget -c ftp://ftp.freedesktop.org/pub/mesa/10.6.9/mesa-10.6.9.tar.xz
wget -c ftp://ftp.freedesktop.org/pub/mesa/glu/glu-9.0.0.tar.bz2
wget -c http://downloads.sourceforge.net/freeglut/freeglut-3.0.0.tar.gz
test -e libva-base-1.6.1.tar.bz2 || (wget -c http://www.freedesktop.org/software/vaapi/releases/libva/libva-1.6.1.tar.bz2
mv libva-1.6.1.tar.bz2 libva-base-1.6.1.tar.bz2)
wget -c http://www.freedesktop.org/software/vaapi/releases/libva-intel-driver/libva-intel-driver-1.6.1.tar.bz2
wget -c http://www.freedesktop.org/software/vaapi/releases/libva-vdpau-driver/libva-vdpau-driver-0.7.4.tar.bz2

wget -c http://wayland.freedesktop.org/releases/wayland-1.9.0.tar.xz
wget -c http://bitmath.org/code/mtdev/mtdev-1.1.5.tar.bz2
wget -c http://www.freedesktop.org/software/libinput/libinput-1.0.1.tar.xz
wget -c http://xkbcommon.org/download/libxkbcommon-0.5.0.tar.xz

wget -c http://people.freedesktop.org/~aplattner/vdpau/libvdpau-1.1.1.tar.bz2
#wget -c --no-check-certificate https://github.com/i-rinat/libvdpau-va-gl/releases/download/v0.3.4/libvdpau-va-gl-0.3.4.tar.gz
wget -c ftp://ftp.x.org/pub/individual/data/xbitmaps-1.1.1.tar.bz2
wget -c --no-check-certificate https://launchpad.net/intltool/trunk/0.51.0/+download/intltool-0.51.0.tar.gz
test -e xterm-320.tar.gz ||  (wget -c ftp://invisible-island.net/xterm/xterm-320.tgz ; mv xterm-320.tgz xterm-320.tar.gz)
test -e glamor-git.tar.gz || (git clone git://anongit.freedesktop.org/git/xorg/driver/glamor ; tar cvfz glamor-git.tar.gz glamor ; rm -rf glamor/ )
wget --no-check-certificate -c https://github.com/anholt/libepoxy/releases/download/v1.3.1/libepoxy-1.3.1.tar.bz2
wget -c http://www.x.org/releases/individual/driver/xf86-video-intel-2.99.917.tar.bz2
exit
fi

# Suche nach dem aktuellstem Paket !
# Das letzte in der Liste ist das neuste, dank "sort --version-sort"
wget () {
set +e
pa=$1
dl=$(grep .tar.bz2 liste.txt | sed 's@"@ @g' | awk ' {print $12;}' | sed /.99./d | sed 's@.sig@@g' | grep ^$pa- | sort --version-sort)
for pack in ${dl[@]}
do
  echo $pack
done
echo "Angefordert:" $pa
echo "Downloaden :" $pack
sleep 5
test -e $pack || /usr/bin/wget -c http://www.x.org/releases/$xorgversion/src/everything/$pack
test -e $pack || /usr/bin/wget -c http://www.x.org/releases/individual/app/$pack
test -e $pack || /usr/bin/wget -c http://www.x.org/releases/individual/data/$pack
test -e $pack || /usr/bin/wget -c http://www.x.org/releases/individual/doc/$pack
test -e $pack || /usr/bin/wget -c http://www.x.org/releases/individual/font/$pack
test -e $pack || /usr/bin/wget -c http://www.x.org/releases/individual/lib/$pack
test -e $pack || /usr/bin/wget -c http://www.x.org/releases/individual/proto/$pack
test -e $pack || /usr/bin/wget -c http://www.x.org/releases/individual/util/$pack
test -e $pack || /usr/bin/wget -c http://www.x.org/releases/individual/driver/$pack
test -e $pack || /usr/bin/wget -c http://www.x.org/releases/individual/xserver/$pack
set -e
unset pa
unset pack
}



if test $1 = stage1
then
mkdir $XORG_PREFIX
mkdir $XORG_PREFIX/lib
ln -s $XORG_PREFIX/lib $XORG_PREFIX/lib64
ln -s $XORG_PREFIX /usr/X11R6
echo ""
echo "/etc/ld.so.conf anpassen fuer Xorg path."
echo "/etc/profile    anpassen fuer Xorg path."
exit
fi

plist1=(
util-macros
bigreqsproto
compositeproto
damageproto
dmxproto
dri2proto
dri3proto
fixesproto
fontcacheproto
fontsproto
glproto
inputproto
kbproto
presentproto
randrproto
recordproto
renderproto
resourceproto
scrnsaverproto
videoproto
xcmiscproto
xextproto
xf86bigfontproto
xf86dgaproto
xf86driproto
xf86vidmodeproto
xineramaproto
xproto
)

plist2=(
libXau
libXdmcp
xcb-proto
libxcb
xtrans
libX11
libXext
libFS
libICE
libSM
libXScrnSaver
libXt
libXmu
libXpm
libXaw
libXfixes
libXcomposite
libXrender
libXcursor
libXdamage
libfontenc
libXfont
libXft
libXi
libXinerama
libXrandr
libXres
libXtst
libXv
libXvMC
libXxf86dga
libXxf86vm
libdmx
libxkbfile
libxshmfence
xcb-base
xcb-util-image
xcb-util-keysyms
xcb-util-renderutil
xcb-util-wm
xcb-util-cursor
wayland
libvdpau
libdrm
libva-base
mesa
libva-base
libva-intel-driver
glu
freeglut
#########libvdpau-* braucht ffmpeg, also später installieren!
#########libvdpau-va-gl
#########libva-vdpau-driver
xbitmaps
bdftopcf
iceauth
luit
mkfontdir
mkfontscale
sessreg
setxkbmap
smproxy
x11perf
xauth
xbacklight
xcmsdb
xcursorgen
xdpyinfo
xdriinfo
xev
xgamma
xhost
xinput
xkbcomp
xkbevd
xkbutils
xkill
xlsatoms
xlsclients
xmessage
xmodmap
xpr
xprop
xrandr
xrdb
xrefresh
xset
xsetroot
xvinfo
xwd
xwininfo
xwud
xcursor-themes
#Font
font-util
encodings
font-adobe-100dpi
font-adobe-75dpi
font-adobe-utopia-100dpi
font-adobe-utopia-75dpi
font-adobe-utopia-type1
font-alias
font-arabic-misc
font-bh-100dpi
font-bh-75dpi
font-bh-lucidatypewriter-100dpi
font-bh-lucidatypewriter-75dpi
font-bh-ttf
font-bh-type1
font-bitstream-100dpi
font-bitstream-75dpi
font-bitstream-speedo
font-bitstream-type1
font-cronyx-cyrillic
font-cursor-misc
font-daewoo-misc
font-dec-misc
font-ibm-type1
font-isas-misc
font-jis-misc
font-micro-misc
font-misc-cyrillic
font-misc-ethiopic
font-misc-meltho
font-misc-misc
font-mutt-misc
font-schumacher-misc
font-screen-cyrillic
font-sony-misc
font-sun-misc
font-winitzki-cyrillic
font-xfree86-type1
intltool
xkeyboard-config
libxkbcommon
mtdev
libinput
FONTCONFIG
libepoxy
xorg-server
glamor
xf86-input-evdev
xf86-input-synaptics
xf86-input-vmmouse
xf86-video-ati
xf86-video-fbdev
xf86-video-intel
xf86-video-nouveau
xf86-video-vesa
xf86-video-vmware
xterm
CONFIG
)

plist3=(
twm
xinit
)


if test $1 = stage2
then
liste=${plist1[@]}
fi

if test $1 = stage3
then
liste=${plist2[@]}
fi

if test $1 = stage4
then
liste=${plist3[@]} 
fi


for paket in ${liste[@]}
  do
  set +e 
  config=$XORG_CONFIG
  cd /BLFS/XORG
  test -e $paket-*.tar.* || wget $paket
  tar xvf $paket-*.tar.* &&  cd $paket*/ && test -e ../$paket*.patch && patch -p1 < ../$paket*.patch 
  set -e

  case $paket in
  CONFIG)		mkdir /etc/X11
  			ln -s /usr/X11/include/X11 /usr/include/X11
  			cp -a /usr/include/GL/* /usr/X11/include/GL/
  			rm -rf /usr/include/GL
  			ln -s /usr/X11/include/GL /usr/include/GL  			
  			#ln -svt /etc/X11 $XORG_PREFIX/lib/X11/{fs,lbxproxy,proxymngr,rstart}   
     			#ln -svt /etc/X11 $XORG_PREFIX/lib/X11/{app-defaults,xkb}
     			#ln -svt /etc/X11 $XORG_PREFIX/lib/X11/{xdm,xinit,xserver,xsm}
     			cp ../EXTRA/xorg.conf    /etc/X11/
  			cp ../EXTRA/xmodmap.map  /etc/X11/
			cp ../EXTRA/xinitrc /etc/X11/xinit/xinitrc

  			# wegen pulseaudio 6.0
  			ln -s /usr/X11/include/xcb /usr/include/xcb
  			
  			ln -s /etc/bashrc /root/.bashrc

  			#ln -s /usr/X11/share/X11/xkb /usr/X11/lib/X11/xkb
  			ln -s /usr/X11/lib/fonts/X11  /usr/X11/lib/X11/fonts
  			cp -a /usr/share/fonts/* /usr/X11/lib/X11/fonts/
  			rm -rf /usr/share/fonts
  			ln -s /usr/X11/lib/X11/fonts /usr/share/fonts
  			tar xvf ../EXTRA/amiga_fonts.tar.gz
  			mv Amiga /usr/X11/lib/fonts/X11/
  			tar xvf ../EXTRA/windows_fonts.tar.gz
  			mv windows /usr/X11/lib/fonts/X11/
  			mkfontdir /usr/share/fonts
  			fc-cache -v	
  			;;
  xf86-video-intel)	sed -i "/#include <errno.h>/a #include <sys/stat.h>" src/uxa/intel_driver.c &&
  			sed -i "/#include <errno.h>/a #include <sys/stat.h>" src/sna/sna_driver.c &&
  			config="$XORG_CONFIG --enable-kms-only" ;;
  twm)			sed -i -e '/^rcdir =/s,^\(rcdir = \).*,\1/etc/X11/app-defaults,' src/Makefile.in ;;
  xf86-input-vmmouse) 	sed -i -e '/__i386__/a iopl(3);' tools/vmmouse_detect.c 
  			config="$XORG_CONFIG -without-hal-callouts-dir --without-hal-fdi-dir" ;;
  glamor)       	./autogen.sh --prefix=/usr/X11 ;;
  xorg-server)		config="$XORG_CONFIG --enable-glamor --enable-suid-wrapper --with-xkb-output=/var/lib/xkb" ;;
  FONTCONFIG)   	install -v -d -m755 /usr/share/fonts
                	ln -svn $XORG_PREFIX/lib/fonts/X11/OTF /usr/share/fonts/X11-OTF
                	ln -svn $XORG_PREFIX/lib/fonts/X11/TTF /usr/share/fonts/X11-TTF
                	continue ;;
  xkeyboard-config) 	config="$XORG_CONFIG --with-xkb-rules-symlink=xorg --disable-runtime-deps"   ;;
  luit)         	./configure $config ;  sed -i 's@CWARNFLAGS =@#CWARNFLAGS =@g' Makefile ;make && make install; cd .. ; rm -rf $paket*/  ;continue ;;
  freeglut)     	mkdir build && cd build && cmake -DCMAKE_INSTALL_PREFIX=/usr/X11 -DCMAKE_BUILD_TYPE=Release -DFREEGLUT_BUILD_DEMOS=OFF -DFREEGLUT_BUILD_STATIC_LIBS=OFF ..
                	make -j 5 && make install ; cd ../.. ; rm -rf $paket*/ ; continue  ;;
  #libvdpau-va-gl) 	cmake -DCMAKE_INSTALL_PREFIX=/usr/X11 -DCMAKE_BUILD_TYPE=Release && make && make install ;;
  libva-base)   	cd libva*/ ; paket=libva ;;
  xcb-base)     	cd xcb-util-*/ ; paket=xcb-util ;;
  wayland)      	config="$XORG_CONFIG --disable-documentation" ;;
  mesa)         	config="--prefix=/usr --sysconfdir=/etc --enable-texture-float --enable-gles1 --enable-gles2 --enable-xa  --enable-glx-tls --enable-osmesa  --with-egl-platforms=drm,x11,wayland --with-gallium-drivers=nouveau,svga,swrast,i915,r600" ;;
  libdrm)       	sed -e "/pthread-stubs/d" -i configure.ac &&
                	ACLOCAL="aclocal -I /usr/X11/lib/aclocal" ACLOCAL_PATH=/usr/X11/lib/aclocal PKG_CONFIG_PATH="/usr/X11/lib/pkgconfig" LD_LIBRARY_PATH=/usr/X11/lib autoreconf -fi 
                	config="$XORG_CONFIG --disable-valgrind" ;;
  libxcb)       	sed -i "s/pthread-stubs//" configure &&
                	config="$XORG_CONFIG --enable-xinput" ;;
  esac
   ldconfig
   echo "Config : $config "
   ./configure $config
   echo ""
   echo "Paket  : $paket  "
   echo "Config : $config "
   echo ""     
   sleep 3     
   make -j 5 && make install
   cd ..
   rm -rf $paket*/
done

