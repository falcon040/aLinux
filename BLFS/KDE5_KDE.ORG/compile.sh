

#declare -x PKG_CONFIG_PATH="/usr/X11/lib/pkgconfig:/opt/qt5/lib/pkgconfig:/opt/kde/lib/pkgconfig"
#export PKG_CONFIG_PATH="/usr/X11/lib/pkgconfig:/opt/qt5/lib/pkgconfig:/opt/kde/lib/pkgconfig"
#export KDE_PREFIX="/opt/kde"
#export LD_LIBRARY_PATH="/usr/X11/lib:/opt/qt5/lib:/opt/kde/lib"
#export PATH="/bin:/usr/bin:/sbin:/usr/sbin:/usr/X11/bin:/opt/kde/bin:/opt/qt5/bin:/opt/java/bin:/opt/ant/bin"

echo ""
echo "Compiliert KDE vom immer aktuellem git-hub nach: /opt/kde !!!"
echo "Starten mit ./compile stage1, stage2, ... "
echo "<RETURN> drücken und freuen!  :-)"
hostname bladerunner.de
read


if test $1 = stage1
then
#git clone git://anongit.kde.org/qca.git
#tar cvfz qca.tar.gz qca
tar xvf qca.tar.gz
cd qca
cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/opt/qt5
make -j5 ; make install
cd ..
rm -rf qca
exit
fi

if test $1 = stage2
then
wget -c http://downloads.grantlee.org/grantlee-5.0.0.tar.gz
tar xvfz grantlee-*.tar.gz
cd grantlee-*
ldconfig
cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/opt/qt5
make -j5 ; make install
cd ..
rm -rf grantlee-*/
exit
fi

if test $1 = stage3
then

tar xvf ../EXTRA/certs.tar.gz
cp -a etc/ssl/certs/* /etc/ssl/certs/
rm -rf etc
 

cat > /root/.gitconfig << "EOF"
[url "git://anongit.kde.org/"]
   insteadOf = kde:
[url "ssh://git@git.kde.org/"]
   pushInsteadOf = kde:
EOF

cat > /etc/dbus-1/session-local.conf << "EOF"
<!DOCTYPE busconfig PUBLIC "-//freedesktop//DTD D-Bus Bus Configuration 1.0//EN"
 "http://www.freedesktop.org/standards/dbus/1.0/busconfig.dtd">
 <busconfig>
 <servicedir>/opt/kde/install/share/dbus-1/services</servicedir>
 </busconfig>
EOF

cat > /etc/dbus-1/system-local.conf << "EOF"
<!DOCTYPE busconfig PUBLIC "-//freedesktop//DTD D-Bus Bus Configuration 1.0//EN"
 "http://www.freedesktop.org/standards/dbus/1.0/busconfig.dtd">
 <busconfig>
 <servicedir>/opt/kde/install/share/dbus-1/system-services</servicedir>
 <includedir>/opt/kde/install/etc/dbus-1/system.d</includedir>
 </busconfig>
EOF

mkdir -p ~/.kde5/{local,config,cache}


cat > /root/.kdesrc-buildrc << "EOF"
global
    qtdir 	/opt/qt5
    source-dir  /opt/kde/sources
    build-dir	/opt/kde/build
    kdedir	/opt/kde/install
    log-dir	/opt/kde/logs
                    
    git-repository-base     kde-projects kde:
    branch-group            kf5-qt5
          
    # release, debug
    cmake-options -DCMAKE_BUILD_TYPE:STRING=release -GNinja
    
    #cxxflags -s -pipe -O2 -DQT_STRICT_ITERATORS -DQURL_NO_CAST_FROM_STRING -DQT_NO_HTTP -DQT_NO_FTP -Wformat -Werror=format-security -Werror=return-type -Wno-variadic-macros -Wlogical-op -Wmissing-include-dirs
    cxxflags -s -pipe -O2 -march=ivybridge 
                                      
    # If you want to use ninja instead of make (it's faster!), add -GNinja to cmake-options above
    # and uncomment the next line
    custom-build-command ninja
                                             
    # Adjust to the number of  CPU cores
    make-options -j5
                                                        
    ignore-kde-structure    true          # Downloads all modules directly into the source folder instead of subdirectories
    stop-on-failure         false         # Stop kdesrc-build when a build fails.
                                                                
end global
                                                               
include /opt/kde/sources/kdesrc-build/kf5-frameworks-build-include
include /opt/kde/sources/kdesrc-build/kf5-workspace-build-include
                                                           
#Uncomment the next two lines to build application and PIM modules
include /opt/kde/sources/kdesrc-build/kf5-applications-build-include
include /opt/kde/sources/kdesrc-build/kf5-kdepim-build-include
EOF

mkdir -p /opt/kde/{sources,build,install,logs}
mkdir -p /opt/kde/install/lib
cd /opt/kde/install
ln -sf lib lib64
chown -R root:root /opt/kde
mkdir -p ~/.kde5/{local,config,cache}  


# kgamma5 compiliert sonst nicht
ln -sf /usr/X11/lib/libXxf86vm.so /usr/lib/libXxf86vm.so
fi

## cantor findet python 3.5 nicht, modul per hand da eintragen
##joe cantor/cmake/FindPythonLibs3.cmake

if test $1 = stage4
then

##### Source updaten von git und alles neu compilieren
cd /opt/kde/sources
git clone kde:kdesrc-build
cd kdesrc-build
./kdesrc-build 

##### Den Source der bereits da ist benutzen, ohne ihn upzudaten
#./kdesrc-build --no-src

fi

if test $1 = stage5
then
cat > /opt/kde/install/bin/runplasma.sh << "EOF"
#xinit
export KF5=/opt/kde/install
export QTDIR=/opt/qt5      
export PATH=$KF5/bin:$QTDIR/bin:$PATH
export QT_PLUGIN_PATH=$KF5/lib/plugins:$QTDIR/plugins:$QT_PLUGIN_PATH
export QML2_IMPORT_PATH=$KF5/lib/qml:$QTDIR/qml
export QML_IMPORT_PATH=$QML2_IMPORT_PATH
export XDG_DATA_DIRS=$KF5/share:/usr/share
export XDG_CONFIG_DIRS=$KF5/etc/xdg:/etc/xdg
exec startkde
EOF
chmod 755 /opt/kde/install/bin/runplasma.sh

hostname bladerunner

#dbus einbinden
#for i in /opt/kde/install/etc/dbus-1/system.d/
#do
#  ln -svf $i /etc/dbus-1/system.d/
#done

#kmail auf sqlite3 stellen
sed -i 's/Driver=QMYSQL/Driver=QSQLITE3/g' .config/akonadi/akonadiserverrc

fi
