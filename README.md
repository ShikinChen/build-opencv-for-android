## 编译和导入Android库
```
 git clone https://github.com/ShikinChen/build-opencv-for-android.git --recursive
```

## 开始编译 Android so库 
设置编译环境
```
export ANDROID_HOME=sdk路径
export ANDROID_NDK_HOME=ndk路径(最小版本和最好是NDK r21)
```
开始编译
```
./build-opencv-for-android.sh
```
最后在out目录输出Android项目samples和sdk,最好在local.properties配置ndk.dir的ndk路径
