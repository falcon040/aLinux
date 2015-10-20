
export PKG_CONFIG_PATH="/usr/X11/lib/pkgconfig:/opt/enlightment/lib/pkgconfig"
export ACLOCAL="aclocal -I /usr/X11/lib/aclocal" 
export ACLOCAL_PATH=/usr/X11/lib/aclocal
export LD_LIBRARY_PATH=/usr/X11/lib



if [ $# = 0 ]; then
        echo "Usage: $0 start"
        echo "Script starten im /BLFS/ENLIGHTMENT Verzeichnis..."
        exit
fi

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
./configure $extra --disable-static --prefix=/opt/enlightment && sleep 2 && make -j5 && make install
}


downloadliste=(
 #"https://github.com/bulletphysics/bullet3/archive/2.83.6.tar.gz"

 #"http://download.enlightenment.org/rel/libs/efl/efl-1.15.2.tar.gz"
 #"http://download.enlightenment.org/rel/libs/emotion_generic_players/emotion_generic_players-1.15.0.tar.gz"
 #"http://download.enlightenment.org/rel/libs/evas_generic_loaders/evas_generic_loaders-1.15.0.tar.gz"
 #"http://download.enlightenment.org/rel/libs/elementary/elementary-1.15.2.tar.gz"
 #"http://download.enlightenment.org/rel/bindings/python/python-efl-1.15.0.tar.gz"
 
 #"http://download.enlightenment.org/rel/apps/enlightenment/enlightenment-0.19.12.tar.gz"
 #"http://download.enlightenment.org/rel/apps/terminology/terminology-0.9.1.tar.gz"
 #"http://download.enlightenment.org/rel/apps/rage/rage-0.1.4.tar.gz"
 #"http://download.enlightenment.org/rel/apps/econnman/econnman-1.1.tar.gz"
 #"https://download.enlightenment.org/rel/apps/enlightenment/desksanity-1.0.2.tar.xz"
 #"http://download.enlightenment.org/rel/apps/epour/epour-0.6.0.tar.gz"
 "https://download.enlightenment.org/rel/apps/eflete/eflete-0.5.0.tar.gz"
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

  cd /BLFS/ENLIGHTMENT/
  test -e $filename || /usr/bin/wget --no-check-certificate -c $paket
  tar  xvf $filename
  cd   $ordnerdir
  echo  Name:  $name
  read
  set -e
  case "$name" in 
  
     epour)		python setup.py install --optimize=1
     			python3 setup.py install --optimize=1 ;;  
     python)            python setup.py install --optimize=1
                        python3 setup.py install --optimize=1 ;;
     efl)               config 
     			ln -sf /opt/enlightment/share/dbus-1/services/org.enlightenment.Ethumb.service /usr/share/dbus-1/services/org.enlightenment.Ethumb.service
     			;;
     2.83.6)            cd bullet3-*/ 
     			CFLAGS="-O2 -pipe -s -fPIC " CXXFLAGS="-O2 -pipe -s -fPIC " cmake -DCMAKE_INSTALL_PREFIX=/opt/enlightment .
     			sed -i 's@-O3@-O3 -L/usr/X11/lib @g'  examples/ExampleBrowser/CMakeFiles/App_ExampleBrowser.dir/link.txt  
     			make -j5 ; make install ; ordnerdir="bullet3-2.83.6" 
     			;;
     #efl)	;;

     *)        	config
      		;;     		
  esac
  
  cd /BLFS/ENLIGHTMENT ; rm -rf $ordnerdir   
done
fi
	