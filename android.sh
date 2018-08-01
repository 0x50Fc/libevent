#!/bin/bash

NDK_PATH=/Users/hailong11/Library/Android/sdk/ndk-bundle/ #换成你自己的ndk path
SHELL_FOLDER=$(cd "$(dirname "$0")";pwd)

BUILD_PATH=$SHELL_FOLDER/android_build/
echo $BUILD_PATH
if [ -x "$BUILD_PATH" ]; then
		rm -rf $BUILD_PATH
fi
mkdir $BUILD_PATH
mkdir $BUILD_PATH/out


for abi in armeabi armeabi-v7a arm64-v8a x86 x86_64
do

  #cmake      
  MakePath=./cmake/build-$abi
  echo $MakePath
	if [ -x "$MakePath" ]; then
		rm -rf $MakePath
	fi
	mkdir $MakePath
	
	OUTPUT_PATH=$BUILD_PATH/out/$abi/
	echo $OUTPUT_PATH
	if [ -x "$OUTPUT_PATH" ]; then
		rm -rf $OUTPUT_PATH
	fi
	mkdir $OUTPUT_PATH
	
	cd $MakePath
	
    # DCMAKE_INSTALL_PREFIX 最后install的路径 这里是 android_build/$abi
    # DCMAKE_TOOLCHAIN_FILE 这个的路劲在android studio中创建一个带有ndk的项目，编译一下，然后
    # 在.externalNativeBuild/cmake/***/cmake_build_command.txt中找到
    # stl 我们使用c++_static
	cmake -DCMAKE_TOOLCHAIN_FILE=$NDK_PATH/build/cmake/android.toolchain.cmake \
    -DANDROID_NDK=$NDK_PATH                      \
    -DCMAKE_BUILD_TYPE=Release                     \
    -DANDROID_ABI=$abi          \
    -DANDROID_NATIVE_API_LEVEL=16                  \
    -DANDROID_STL=c++_static \
    -DCMAKE_CXX_FLAGS=-frtti -fexceptions --std=c++1z \
    -DCMAKE_INSTALL_PREFIX=$OUTPUT_PATH \
    ../..
	
	make -j4
	make install
	
	cd ../..
	
done
