# smali_compile

## 背景
  python打包脚本中有一步是需要把所有的smali文件转成一个dex文件,使用官方提供的smali.jar[smali下载地址](https://bitbucket.org/JesusFreke/smali/downloads/)在执行转换操作的时候会报出错误,意思是smali中的文件中的方法数超过的65535,报错如下:

    
    Exception in thread "main" org.jf.util.ExceptionWithContext: Exception occurred while writing code_item for method LMTT/ThirdAppInfoNew;-><init>()V
	at org.jf.dexlib2.writer.DexWriter.writeDebugAndCodeItems(DexWriter.java:1046)
	at org.jf.dexlib2.writer.DexWriter.writeTo(DexWriter.java:345)
	at org.jf.dexlib2.writer.DexWriter.writeTo(DexWriter.java:300)
	at org.jf.smali.Smali.assemble(Smali.java:131)
	at org.jf.smali.AssembleCommand.run(AssembleCommand.java:96)
	at org.jf.smali.Main.main(Main.java:100)
    Caused by: org.jf.util.ExceptionWithContext: Error while writing instruction at code offset 0x0
	at org.jf.dexlib2.writer.DexWriter.writeCodeItem(DexWriter.java:1319)
	at org.jf.dexlib2.writer.DexWriter.writeDebugAndCodeItems(DexWriter.java:1042)
	... 5 more
    Caused by: org.jf.util.ExceptionWithContext: Unsigned short value out of range: 115886
	at org.jf.dexlib2.writer.DexDataWriter.writeUshort(DexDataWriter.java:116)
	at org.jf.dexlib2.writer.InstructionWriter.write(InstructionWriter.java:356)
	at org.jf.dexlib2.writer.DexWriter.writeCodeItem(DexWriter.java:1279)

追踪抛出的异常发现出错的地方在DexDataWriter.java中的writeShort方法:

     public void writeUshort(int value) throws IOException {
        if (value < 0 || value > 0xFFFF) {
            //throw new ExceptionWithContext("Unsigned short value out of range: %d", value);
        }
        write(value);
        write(value >> 8);
    }
使用smali.jar把smali转成dex文件这一步目的是统计出dex文件中的方法数和字段数,所以我们可以无视这个异常,就是把抛出异常的这句代码注释掉就行了,这样的话我们就需要拿到smali的源码去改,然后再编译成jar,当然我们也可以做其他额外操作,这里我们只需注释掉这一行代码就行了.本文档的就是来讲如何将smali项目编译成jar文件.

因为这是个java项目所以网上都是使用IDEA来编译smali,自己常用的是androidstudio,安装IDEA嫌麻烦,所以这里只是讲如何使用as来编译smali.

#### 下载smali源码,这里以2.4.0版本为例

    git clone https://github.com/JesusFreke/smali.git

   项目有四个module分别是baksmali,dexlibs,smali,util目录如下:


  ![](https://i.postimg.cc/VL5hCysv/smali-2-4-0.png)

  ![](https://i.postimg.cc/mkZSP3rx/smali-dep.png)

其中我们需要的源码为smali模块,通过as右侧gradle我们可以看到smali依赖了util和dexlib2模块和其它第三方的库(由此我们知道项目smali模块的源码只是官方发布的jar的一部分),baksmali[新版本](https://mvnrepository.com/artifact/com.android.tools.smali/smali-baksmali/3.0.3)是将dex转为smali我们这里用不到它,而根据我们打包报的错误我们发现异常最终是在dexlib2的DexDataWriter.java中的writeShort方法跑抛出的,所以我们只要注释掉dexlib2的DexDataWriter.java类的writeShort中抛出异常的代码即可.异常的问题解决了,但是如何将smali,dexlib2,util和smali依赖的其它第三方库打成一个jar是个问题,本文档也是主要讨论这个问题.

由于这个项目是java项目不符合as项目目录结构所以查看代码的时候会有很多找不到类的报错,我们需要用as新建一空的个android项目然后把smali,dexlib2和util中的java代码连同各自的包目录原封不动的拷贝到这新建的项目中的,然后将依赖库的jar放到libs文件夹中在build.gradle文件中添加依赖即可,依赖库的jar文件可以通过如下方式查找到

![](https://i.postimg.cc/pdPnZWDx/dep-jar.png)

之后会发现依然有很多报错,在smali模块中有smaliParser,smaliTreeWalker,smaliLexer三个类找不到,查看smali模块的文件目录发现有smaliParser.g,smaliTreeWalker.g,smaliLexer.jflex这三个文件,所以只要我们将这三个文件转换成java文件即可,通过查找.g文件需要[ANTLR](https://zh.wikipedia.org/wiki/ANTLR)(全名：ANother Tool for Language Recognition)工具转换成java文件,ANTLR是一个强大的解析器生成器，用于读取、处理、执行或翻译结构化文本或二进制文件,[ANTLR下载地址](https://www.antlr3.org/download.html)

![](https://i.postimg.cc/vmMQdZzK/antlr.png)

图中1下载的jar可以将.g文件转成.java文件,命令格式(需要配置java环境):

    #生成的java文件与.g文件在同一目录
    java -jar antlr-3.5.2-complete-no-st3.jar xxx.g 



图中2下载的jar是smali模块中依赖的库

.jflex文件是通过JFlex转换为java文件的,[JFlex下载地址](https://www.onworks.net/zh-CN/software/windows/app-jflex),JFlex是一个用于Java的词法分析器生成器(也称为scanner生成器).[github地址](https://github.com/jflex-de/jflex)

 ![](https://i.postimg.cc/Fz5tj9Rv/jflex.png)

转换命令:

    #生成的java文件与.jflex文件在同一目录
    java -jar \jflex-1.6.1\lib\jflex-1.6.1.jar \jflex-1.6.1\smaliLexer.jflex

至此所有需要的java文件都已经齐全,我们只需要把这些java打成一个jar然后再与这三个模块依赖的所有jar文件打成同一个jar就可以得到想要的smali-2.4.0.jar了,关于如何使用as将java文件打成jar文件和如何合并多个jar文件为一个jar文件后面会有介绍.

### 编译dexlib2

前面提到smali转dex报错的是dexlib2中的代码,所有我们只需要修改编译这个模块的代码就行了,然后将之与smali,util和依赖的其它的库一起打成一个jar就行了.依赖的jar我们都有了,如果我们有smali.jar和util.jar就好了.[这里有](https://jar-download.com/artifacts/org.smali/smali)smali[新版本](https://mvnrepository.com/artifact/com.android.tools.smali/smali/3.0.3)各个版本的jar以及它所依赖的所有jar,这里我们需要下载2.4.0版本的jar,这是一个zip包里面包含了所有需要的jar文件.

  ![](https://i.postimg.cc/mgz5SPcH/smali-dep-download.png)

之前我们知道smali模块中有smaliParser.g,smaliTreeWalker.g,smaliLexer.jflex这个三个格式的文件,我们下载的smali-2.4.jar中是包含了这三个java文件的,这样我们就省去了转换这三个文件的步骤.

  ![](https://i.postimg.cc/C5wQSJxy/smali-dep-module-jar.png)

我们看到这里面包含了这三个模块的jar文件以及他们所依赖的所有jar文件.现在我们只需删除dexlib2-2.4.0.jar然后把源码中dexlib2中的代码拷贝到as中的java文件夹下(源码目录不要修改)修改后再打成jar,最后再把这些jar合并成一个jar即可.

 ![](https://i.postimg.cc/52v98Lw7/dexlib2-dep.png)

只需要将图中这些依赖的jar文件手动拷贝到新建的项目中的libs文件夹下,再进行依赖即可.项目的目录结构应该是这样的.

![](https://i.postimg.cc/NMH0B0tV/dexlib2-compile.png)

修改完后接下来就要把dexlib2的java代码打成jar包,在app模块的build.gradle文件中添加构建命令:

    android {
      ...
      android {
            //将abortOnError置为false,让lint时的错误不会中止我们的编译
            lintOptions {
                abortOnError false
            }
        }
       ...
     }

    dependencies {
        //对第三方jar文件进行依赖
        implementation fileTree(dir: 'libs', include: ["*.jar"])
    }

    task deleteOldJar(type: Delete) {
        //删除存在的
        delete 'build/libs/dexlib2-2.4.0-dev.jar'
    }

    task makeJar(type: Jar) {
        //指定生成的jar名
        baseName 'dexlib2-2.4.0-dev'
        //设置拷贝的文件
        from('build/intermediates/javac/release/classes/')
        //去掉不需要打包的目录和文件
        exclude('com')
        //去掉R$开头的文件
        exclude { it.name.startsWith('R$'); }
    }
    //构建dexlib2-2.4.0-dev.jar
    makeJar.dependsOn(deleteOldJar, build)

然后再使用as内置的Terminal执行gradlew makeJar即可,gradlew需要配置环境变量,makeJar是声明的构建任务

![](https://i.postimg.cc/GmRrsQCX/gradle-makejar.png)

构建完成后会在build目录的libs下生成dexlib2-2.4.0-dev.jar

![](https://i.postimg.cc/WbTTd8jX/output-dexlib2.png)

### 合并jar文件

jdk中提供了jar工具来合并jar文件,合并jar文件分两步.
第一步解压jar文件,命令:

     jar -xvf xxx.jar
我们需要将所有进行合并的jar文件放到同一个目录并分别对每个jar执行这个命令.

第二步合并,命令:

    jar -cvfM combined.jar .

默认生成的combined.jar和进行合并的jar文件在同一个目录

   
       jar命令 用法: jar {ctxui}[vfmOMe] [jar-file] [manifest-file] [entry-point] [-C dir] file ...
       选项包括：
       -c 创建新的归档文件
       -t 列出归档目录
       -x 解压缩已归档的指定（或所有）文件
       -u 更新现有的归档文件
       -v 在标准输出中生存详细输出
       -f 指定归档文件名
       -m 包含指定清单文件中的清单信息
       -e 为捆绑到可执行 jar 文件的独立应用程序指定应用程序入口点
       -O 仅存储；不使用任何ZIP压缩
       -M 不创建条目的清单文件
       -i 为指定的 jar 文件生成索引信息
       -C 更改为指定的目录并包含其中的文件
          如果有任何目录文件，则对其进行递归处理。
          清单文件名、归档文件名和入口点名的指定顺序与”m”、”f”和”e”标志的指定顺序相同。


合并完成在对其测试的时候,即执行java -jar combined.jar的时候会提示
combined.jar中没有主清单属性,解压后发现原来在MANIFEST.MF中没有指Main-Class即执行jar文件时的入口类,结合之前打包时的报错日志,查看代码发现入口方法是org.jf.smali.Main.main,所以在解压jar后我们需要将Main-Class:org.jf.smali.Main这句代码加到MANIFEST.MF后面并在最后加上换行符和回车符.

![](https://i.postimg.cc/pVfyckZt/Manifest-no-main.png)

经过以上步骤我们得到的jar就可以打包了.

### 脚本
为了合并jar这一步更快捷,这里我准备了一个python脚本和bat文件:
 ![](https://i.postimg.cc/wxJKzGy7/python-bat.png)

这个目录结构不要更改,只需要把所有要进行合并的jar文件放在jar_files目录中然后双击combineJar.bat就会执行jar的解压,修改MANIFEST.MF文件,合并jar文件这三个步骤,合并后的jar会在combined_jar文件夹中.其中合并以后jar的名称,和入口类可以自己在combineJar.py脚本中指定.
  
[github地址](https://github.com/monkey-jz/smali_compile). 
