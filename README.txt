# aLinux
A new Linux Distribution, compiled from Scratch, completly from Source. Automated as mutch as possible.
(Based on LFS,BLFS)


Hey,

these are my build scripts to compile a completet Linux from Base System ( Kernel, gcc, glibc, ... ) 
to X11 and ending at KDE5

Everything is building from Sourcecode officielly distributet by the orginal Author. 
No unknown patches are used, no Sourcecode is manipulated.  
The resulting System is completly build up 100% on your system. No 3Hand, no security Holes.

Your System is compiled for YOUR Computer, choosing the best compiler Flags for your System. 
Resulting in maximum Performance.

To start, you need a Computer with any actual Linux Distrubution installed and a free partition to build to.
( Iam using Mint-Linux 17.2 at the Moment )

At the Moment the Scripts are very tricky, but result in a working , booting , compiling til KDE5-Plasma build from git.

Have Fun!





HOW-To-START:

# /lfs schould me mounted on a new partition or new hd, formated to ext4,
# minimum 20 GB
 
mkdir /lfs

#discard on ssd is the trim command
mount /dev/xyz /lfs -odiscard,noatime

copy -a aLinux/* /lfs/
cd /lfs
# start the script now, follow instructions

