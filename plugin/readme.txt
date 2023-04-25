java转smali需要三步(需事先配置好java环境和拿到需要用到的工具：android.jar,dx.jar,baksmali.jar):
工具要与反编译apk时用到的工具的版本相适应
android.jar在sdk\platforms\android目录中
dx.jar在sdk\build-tools\28.0.3\lib目录中
baksmali.jar可去https://bitbucket.org/JesusFreke/smali/downloads/下载反编译apk时用到的apktool.jar相对应版本具体参照https://ibotpeaches.github.io/Apktool/changes/。

1.java转class
命令:javac -cp android.jar [-d] BTestPidCpuUsageProvider.java
class会生成在与java文件同一文件夹下,加上-d可以指定生成class的文件夹,不过会生成在指定的文件夹中生成java文件包名层级的文件夹中
2.class转dex
命令:java -jar dx.jar --dex --output=C:\Users\JerryZhu\Desktop\plugin\dex\BTestPidCpuUsageProvider.dex com\boyaa\cpu_usage\BTestPidCpuUsageProvider.class
--output可以指定生成的dex文件位置和文件名称,对于将指定class文件转成dex名称要一样,后面的class文件需要在其java文件中包名层级的文件夹中
3.dex转smali
命令:java -jar baksmali.jar d dex\BTestPidCpuUsageProvider.dex
smali文件会生成在out\目录下包名层级的文件夹下即out\com\boyaa\cpu_usage\下