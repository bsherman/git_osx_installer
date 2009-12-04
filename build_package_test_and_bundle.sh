#!/bin/bash

DISK_IMAGE="Disk Image"
# remove old installers
rm *.dmg
if [ -d "$DISK_IMAGE" ]; then
     rm "$DISK_IMAGE/*.pkg"
else 
     mkdir "$DISK_IMAGE"
fi

./build.sh

GIT_VERSION=$(git --version | sed 's/git version //')
PACKAGE_NAME="git-$GIT_VERSION-intel-leopard"
IMAGE_FILENAME="$PACKAGE_NAME.dmg" 

#cleanup post-build
sudo rm -fr git_build/git-$GIT_VERSION

echo $PACKAGE_NAME | pbcopy
echo "Git version is $GIT_VERSION"

/Developer/Applications/Utilities/PackageMaker.app/Contents/MacOS/PackageMaker --doc Git\ Installer.pmdoc/ -o "$DISK_IMAGE/$PACKAGE_NAME.pkg" --title "Git $GIT_VERSION"

echo "Testing the installer..."

./test_installer.sh

printf "$GIT_VERSION" | pbcopy

UNCOMPRESSED_IMAGE_FILENAME="$PACKAGE_NAME.uncompressed.dmg"
hdiutil create $UNCOMPRESSED_IMAGE_FILENAME -srcfolder "$DISK_IMAGE" -volname "Git $GIT_VERSION Intel Leopard" -ov
hdiutil convert -format UDZO -o $IMAGE_FILENAME $UNCOMPRESSED_IMAGE_FILENAME
rm $UNCOMPRESSED_IMAGE_FILENAME

echo "Git Installer $GIT_VERSION - OS X - Leopard - Intel" | pbcopy
open "http://code.google.com/p/git-osx-installer/downloads/entry"
sleep 1
open "./"
