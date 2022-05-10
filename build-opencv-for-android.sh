#!/bin/bash
NDK_ROOT="${1:-${ANDROID_NDK_HOME}}"
SHELL_PATH=$(pwd)

echo $NDK_ROOT

### ABIs setup
declare -a ANDROID_ABI_LIST=("armeabi-v7a" "arm64-v8a" "x86" "x86_64")

### path setup
INSTALL_DIR="${SHELL_PATH}/android_opencv"
rm -rf "${INSTALL_DIR}/opencv"

### Make each ABI target iteratly and sequentially
API_LEVEL=21
for i in "${ANDROID_ABI_LIST[@]}"
do
    ANDROID_ABI="${i}"
    echo "Start building ${ANDROID_ABI} version"

    TEMP_BUILD_DIR="${SHELL_PATH}/build/android_${ANDROID_ABI}"
    # ### Remove the build folder first, and create it
    rm -rf "${TEMP_BUILD_DIR}"
    mkdir -p "${TEMP_BUILD_DIR}"
    cd "${TEMP_BUILD_DIR}"

    OPENCV_PATH="${SHELL_PATH}/opencv"
    OPENCV_CONTRIB_PATH="${SHELL_PATH}/opencv_contrib"
    INSTALL_PATH=${SHELL_PATH}/out/
    mkdir -p "${INSTALL_PATH}"

    cmake -DCMAKE_BUILD_WITH_INSTALL_RPATH=ON \
          -DCMAKE_TOOLCHAIN_FILE="${NDK_ROOT}/build/cmake/android.toolchain.cmake" \
          -DANDROID_TOOLCHAIN=clang++ \
          -DANDROID_NDK="${NDK_ROOT}" \
          -DANDROID_NATIVE_API_LEVEL=${API_LEVEL} \
          -DANDROID_ABI="${ANDROID_ABI}" \
          -DOPENCV_EXTRA_MODULES_PATH=${OPENCV_CONTRIB_PATH}/modules \
          -DCMAKE_INSTALL_PREFIX=${INSTALL_PATH} \
          -D WITH_CUDA=OFF \
          -D WITH_MATLAB=OFF \
          -D BUILD_ANDROID_EXAMPLES=ON \
          -D BUILD_DOCS=OFF \
          -D BUILD_PERF_TESTS=OFF \
          -D BUILD_TESTS=OFF \
          ${OPENCV_PATH}
    # # Build it
    make -j4
    # # Install it
    make install/strip
    # ### Remove temp build folder
    cd "${SHELL_PATH}"
    # rm -rf "${TEMP_BUILD_DIR}"
    echo "end building ${INSTALL_PATH} version"
done