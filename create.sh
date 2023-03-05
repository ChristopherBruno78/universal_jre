#!/bin/sh

#Script creates a universal binary, from the Azul Zulu JRE, for MacOS ARM (Apple Silicon) and Intel architectures
#The resulting package is a JRE only

BASE_JDK=zulu-19.jre
TARGET=universal-19.jre

ARM_DIR=./$BASE_JDK/Contents
INTEL_DIR=x86_64/$BASE_JDK/Contents
UNI_DIR=./$TARGET/Contents

#clean
rm -rf $TARGET

#create the folder
mkdir $TARGET
mkdir $UNI_DIR
mkdir $UNI_DIR/Home
mkdir $UNI_DIR/MacOS

#copy Info.plist
cp $ARM_DIR/Info.plist $UNI_DIR

COPY() {
	cp -r $ARM_DIR/$1 $UNI_DIR/$1
}

LIPO() {
	lipo -create -output $UNI_DIR/$1 $ARM_DIR/$1 $INTEL_DIR/$1
}

#copy over these folders
COPY_FOLDERS=(Home/conf)

# shellcheck disable=SC2068
for FOLDER in ${COPY_FOLDERS[@]};
do
	COPY "$FOLDER"
done

#lipo binary in MacOS folder
LIPO "MacOS/libjli.dylib"

#lipo the needed binaries in the bin folder
mkdir $UNI_DIR/Home/bin
BIN_FILES=(java jfr jrunscript keytool rmiregistry)
# shellcheck disable=SC2068
for FILE in ${BIN_FILES[@]};
do
    LIPO "Home/bin/$FILE"
done

#lib folder
mkdir $UNI_DIR/Home/lib

#copy the non-binary files
shopt -s extglob
for FILE_PATH in $ARM_DIR/Home/lib/!(*.dylib)
do
	FILE="$(basename -- $FILE_PATH)"
    COPY "Home/lib/$FILE"
done

#lipo the binaries in the lib folder
LIPO "Home/lib/jspawnhelper"

for FILE_PATH in $ARM_DIR/Home/lib/*.dylib
do
	FILE="$(basename -- $FILE_PATH)"
    LIPO "Home/lib/$FILE"
done

for FILE_PATH in $ARM_DIR/Home/lib/server/*.dylib
do
	FILE="$(basename -- $FILE_PATH)"
    LIPO "Home/lib/server/$FILE"
done
