

build=`pwd`
 
cd $build
curl -OL http://ftpmirror.gnu.org/autoconf/autoconf-2.69.tar.xz
tar xzf autoconf-2.69.tar.xz
cd autoconf-2.69
./configure --prefix=$HOME/macosx
make
make install
export PATH=$HOME/macosx/bin:$PATH
 
##
# Automake
# http://ftpmirror.gnu.org/automake
 
cd $build
curl -OL http://ftpmirror.gnu.org/automake/automake-1.14.tar.xz
tar xzf automake-1.14.tar.xz
cd automake-1.14
./configure --prefix=$HOME/macosx
make
make install
 
##
# Libtool
# http://ftpmirror.gnu.org/libtool
 
cd $build
curl -OL http://ftpmirror.gnu.org/libtool/libtool-2.4.2.tar.xz
tar xzf libtool-2.4.2.tar.xz
cd libtool-2.4.2
./configure --prefix=$HOME/macosx
make
make install

cd $build
curl -OL http://ftpmirror.gnu.org/help2man/help2man-1.46.1.tar.xz
tar xzf help2man-1.46.1.tar.xz
cd help2man-1.46.1
./configure --prefix=$HOME/macosx
make
make install

cd $build
curl -OL http://netcologne.dl.sourceforge.net/project/asciidoc/asciidoc/8.6.9/asciidoc-8.6.9.tar.gz
tar xzf asciidoc-8.6.9.tar.gz
cd asciidoc-8.6.9
./configure --prefix=$HOME/macosx
make install

cd $build
curl -OL https://www.oasis-open.org/docbook/xml/4.5/docbook-xml-4.5.zip
rm -rf docbook
mkdir docbook
mkdir -p $HOME/macosx/share/docbook-4.5
(cd docbook && unzip ../docbook-xml-4.5.zip && rsync -vaxH . $HOME/macosx/share/docbook-4.5)
 
echo "Installation complete."

PREFIX=$HOME/macosx/yubico

for i in \
  https://github.com/bagder/curl.git \
  https://github.com/Yubico/libykneomgr.git \
  https://github.com/Yubico/yubico-c-client.git \
  https://github.com/Yubico/yubico-c \
  https://github.com/Yubico/yubico-pam.git \
  https://github.com/Yubico/yubikey-personalization.git
do
  name=$(basename $i .git)
  if [ ! -d $name ]
  then
    git clone $i
  else
    (cd $name && git pull)
  fi
done
export A2X="a2x -L"
export PKG_CONFIG_PATH=$PREFIX/lib/pkgconfig
(cd curl && ./buildconf && ./configure --prefix=$PREFIX && make install)
(cd yubico-c && autoreconf --install && ./configure --prefix=$PREFIX && make install)
(cd yubikey-personalization && autoreconf --install && ./configure --prefix=$PREFIX && make install)
(cd yubico-c-client && autoreconf --install && ./configure --prefix=$PREFIX && make install)
(cd yubico-pam 
patch -p1 <<EOF
diff --git a/util.c b/util.c
index ecfacf6..c19ce0d 100644
--- a/util.c
+++ b/util.c
@@ -35,6 +35,9 @@
 #include <stdlib.h>
 #include <string.h>
 #include <sys/types.h>
+#include <sys/stat.h>
+#include <errno.h>
+#include <fcntl.h>
 #include <pwd.h>
 #include <unistd.h>
EOF
autoreconf --install && ./configure --prefix=$PREFIX  && make install)
 
