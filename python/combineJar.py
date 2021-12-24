import subprocess
import os
import shutil
import traceback

# jar命令
# 用法： jar {ctxui}[vfmOMe] [jar-file] [manifest-file] [entry-point] [-C dir] file ...
# 选项包括：
# -c 创建新的归档文件
# -t 列出归档目录
# -x 解压缩已归档的指定（或所有）文件
# -u 更新现有的归档文件
# -v 在标准输出中生存详细输出
# -f 指定归档文件名
# -m 包含指定清单文件中的清单信息
# -e 为捆绑到可执行 jar 文件的独立应用程序指定应用程序入口点
# -O 仅存储；不使用任何ZIP压缩
# -M 不创建条目的清单文件
# -i 为指定的 jar 文件生成索引信息
# -C 更改为指定的目录并包含其中的文件
# 如果有任何目录文件，则对其进行递归处理。
# 清单文件名、归档文件名和入口点名的指定顺序与”m”、”f”和”e”标志的指定顺序相同。

# 功能:将多个jar合成一个jar
# 此脚本要与存放jar文件的目录在同一级
# 配置jdk环境变量
# 需要合并的jar文件目录

parent_dir = os.path.abspath(os.path.dirname(__file__))
jar_files_dir = os.path.join(parent_dir,"jar_files")
# 临时文件夹用来存放合并前的jar
temp_jar_files_dir = os.path.join(jar_files_dir,'temp_jar_files')
# 用来存放合并后的jar
combined_jar_dir = os.path.join(parent_dir,'combined_jar')
# 合并以后jar的名称
combinedJarName = 'smali-2.5.2-dev.jar'
#入口类
main_class = 'org.jf.smali.Main'

def executeCommand(cmd) :
    print("cmd : %s" % cmd)
    p = subprocess.Popen(cmd, shell=True, stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
    for line in p.stdout.readlines():
        print(line.decode("gbk"))
    retval = p.wait()

# 在指定文件夹中删除指定类型的文件
def deleteFileWithSuffix (fileDir , suffix):
    for root,dirs,files in os.walk(fileDir) :
        for file in files :
            filePath = os.path.join(root, file)
            if os.path.splitext(filePath)[-1] == suffix :
            	print("\n 删除文件 %s ..." % (filePath))
            	os.remove(filePath)

# python读取文件,将文件中的空白行去掉

def delblankline(infile, outfile):
    infopen = open(infile, 'r',encoding="utf-8")
    outfopen = open(outfile, 'w',encoding="utf-8")
 
    lines = infopen.readlines()
    for line in lines:
        if line.split():
            outfopen.writelines(line)
        else:
            outfopen.writelines("")
    infopen.close()
    outfopen.close()

def writeMainClass(file) :
    print("写入入口类 %s." % (main_class))
    with open(file, 'a+') as f:
       f.write('Main-Class: ' + main_class + '\r\n') 

def processManifestFile() :
    MANIFEST = os.path.join(os.path.join(temp_jar_files_dir,"META-INF"),"MANIFEST.MF")
    MANIFEST_TEMP = os.path.join(os.path.join(temp_jar_files_dir,"META-INF"),"MANIFEST_TEMP.MF")
    # 删除空白行
    delblankline(MANIFEST,MANIFEST_TEMP)
    os.remove(MANIFEST)
    os.rename(MANIFEST_TEMP,MANIFEST)
    # 向META-INF文件中写入入口类
    writeMainClass(MANIFEST)

def startProcessJarFile () :
    
    # 创建临时文件夹
    if os.path.exists(temp_jar_files_dir) :
        shutil.rmtree(temp_jar_files_dir)

    # 把jar文件拷贝到临时目录
    print('拷贝 "%s" 目录中的jar文件到临时目录 "%s" 中 ... ' % (jar_files_dir,temp_jar_files_dir))
    shutil.copytree(jar_files_dir, temp_jar_files_dir)
   
    cmd_command = []
    file_path = []
    # 添加命令
    for root,dirs,files in os.walk(temp_jar_files_dir) :
        for file in files :
            filePath = os.path.join(root, file)
            if os.path.splitext(filePath)[-1] == '.jar' :
                cmd = 'jar -xvf "%s"' % (filePath)
                cmd_command.append(cmd)
                file_path.append(filePath)
    os.chdir(temp_jar_files_dir)
    # 执行解压jar文件命令
    for cmd in cmd_command:
        executeCommand(cmd)
    print('临时目录 "%s" 中所有jar文件已经解压完成. \n 处理MANIFEST.MF ...' % (temp_jar_files_dir))
    # 处理MANIFEST.MF
    processManifestFile()

def zipClass2Jar () :
   
    deleteFileWithSuffix(temp_jar_files_dir,".jar")  
    os.chdir(temp_jar_files_dir)
    cmd = 'jar -cvfM %s .' % (combinedJarName) 
    # 合并jar
    executeCommand(cmd)
    print("》》》》》》》》》》》》》》》》合并成功.《《《《《《《《《《《《《《 \n 拷贝到目标目录 ...")
    if os.path.exists(combined_jar_dir) :
        shutil.rmtree(combined_jar_dir)
    os.mkdir(combined_jar_dir)
    srcJar = os.path.join(temp_jar_files_dir,combinedJarName)
    dstJar = os.path.join(combined_jar_dir,combinedJarName)
    shutil.copyfile(srcJar,dstJar)
    # 删除生成的临时文件
    print("拷贝文件完成. \n 删除临时文件夹 %s ..." % (temp_jar_files_dir))
    os.chdir(parent_dir)
    shutil.rmtree(temp_jar_files_dir)
    
if __name__ == "__main__":

    try:
        # 处理jar文件
        startProcessJarFile()
        # 将处理后文件合并成一个jar文件
        zipClass2Jar()
    except Exception as e:
        error_info = traceback.format_exc()
        print('error:' + error_info)
        input("press enter to exit")
    
   

