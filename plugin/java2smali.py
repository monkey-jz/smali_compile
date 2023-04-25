#-*-coding=utf8-*-

import subprocess
import os
import shutil
import re

def JOIN(floder,file):
    return os.path.join(floder,file)

ROOT_DIR = os.path.abspath(os.path.dirname(__file__))
TOOLS_DIR =JOIN(ROOT_DIR,"tools")
ANDROID = JOIN(TOOLS_DIR,"android.jar")
DX = JOIN(TOOLS_DIR,"dx.jar")
BACKSMALI = JOIN(TOOLS_DIR,"baksmali-2.2.2.jar")
JAVA_FILE_DIR = JOIN(ROOT_DIR,"java")
DEX_FILE_DIR = JOIN(ROOT_DIR,"dex")


def reportError(cmd, stdoutput='', erroutput=''):
    
    """
    错误日志输出
    """
    newline = '\n'
    errorOuput = newline + '==================>>>> CMD ERROR <<<<==================' + newline
    errorOuput += '[cmd]: ' + cmd + newline
    errorOuput += '[stdout]: ' + str(stdoutput) + newline
    errorOuput += '[stderr]: ' + str(erroutput) + newline
    errorOuput += '================================================='
    print(errorOuput)

def executeCommand(cmd):
    cmd = cmd.replace('\\', '/')
    cmd = re.sub('/+', '/', cmd)
    print(cmd)
    st = subprocess.STARTUPINFO
    st.dwFlags = subprocess.STARTF_USESHOWWINDOW
    st.wShowWindow = subprocess.SW_HIDE

    import shlex
    cmds = shlex.split(cmd)
    s = subprocess.Popen(cmds)
    ret = s.wait()
    if ret:
        s = subprocess.Popen(str(cmd), stdout=subprocess.PIPE, stderr=subprocess.PIPE, shell=True)
        stdoutput, erroutput = s.communicate()
        reportError(str(cmd), stdoutput, erroutput)
        cmd = 'ERROR:' + str(cmd) + ' ===>>> exec Fail <<<=== '
    else:
        cmd += ' ===>>> exec success <<<=== '
    return ret

def java2class(JAVA_FILE_DIR):

    for file in os.listdir(JAVA_FILE_DIR):
        java_file = JOIN(JAVA_FILE_DIR,file)
        if os.path.splitext(file)[-1][1:] == "java":
            command = r'javac -cp {0} {1}'.format(ANDROID,java_file)
            executeCommand(command)
            
def getPackageName(JAVA_FILE_DIR):
    packageName = None
    for file in os.listdir(JAVA_FILE_DIR):
        java_file = JOIN(JAVA_FILE_DIR,file)
        if os.path.splitext(file)[-1] == ".java":
            java_file = JOIN(JAVA_FILE_DIR,file)
            fileHandle = open(java_file,"rb")
            line = fileHandle.readline().decode("utf-8")
            package = line.split(" ")[1]
            packageName = package[0:len(package)-3]
            fileHandle.close()
            break
    return packageName

def class2dex(JAVA_FILE_DIR):

    packageName = getPackageName(JAVA_FILE_DIR)
    print(packageName)
    targetDir = os.path.join(ROOT_DIR,*packageName.split("."))

    if not os.path.exists(targetDir):
        os.makedirs(targetDir)
    if not os.path.exists(DEX_FILE_DIR):
        os.makedirs(DEX_FILE_DIR)

    if packageName is not None:
        
        for file in os.listdir(JAVA_FILE_DIR):
            if os.path.splitext(file)[-1] == ".class":
                class_file = JOIN(JAVA_FILE_DIR,file)
                targetFile = JOIN(targetDir,file) 
                shutil.move(class_file,targetDir)

                taget_dex_file = JOIN(DEX_FILE_DIR,os.path.splitext(file)[0])+ ".dex"
                abs_root_dir = os.path.abspath(os.path.dirname(__file__))
                path_array = abs_root_dir.split(os.path.sep)
                root_dir_name = path_array[len(path_array) - 1]  
                adjust_target_file = targetFile[targetFile.find(root_dir_name)+ len(root_dir_name) + 1 :]
                command = r"java -jar {0} --dex --output={1} {2}".format(DX,taget_dex_file,adjust_target_file)
                executeCommand(command)

    else:
        print("can not find packageName ... ")    


def move2smali_dir():

    out_smali_dir = JOIN(ROOT_DIR,"out")
    if not os.path.exists(out_smali_dir):
        return

    target_smali_dir = JOIN(ROOT_DIR,"smali")

    if os.path.exists(target_smali_dir):
        shutil.rmtree(target_smali_dir)
        
    os.makedirs(target_smali_dir)

    packageName = getPackageName(JAVA_FILE_DIR) 
    source_smali = os.path.join(out_smali_dir,*packageName.split("."))
    for file in os.listdir(source_smali):
        source_smali_file = JOIN(source_smali,file)
        shutil.move(source_smali_file,target_smali_dir)

    shutil.rmtree(out_smali_dir)    
    
def dex2smali(DEX_FILE_DIR):
    for file in os.listdir(DEX_FILE_DIR):
        tagerDexFile = JOIN(DEX_FILE_DIR,file)
        command = r"java -jar {0} d {1}".format(BACKSMALI,tagerDexFile)
        executeCommand(command)
        
    move2smali_dir()

def deleteTempFile(JAVA_FILE_DIR):

    packageName = getPackageName(JAVA_FILE_DIR)
    targetDir = os.path.join(ROOT_DIR,packageName.split(".")[0])

    if os.path.exists(targetDir):
        shutil.rmtree(targetDir)

    if os.path.exists(DEX_FILE_DIR):
        shutil.rmtree(DEX_FILE_DIR)

    for file in os.listdir(JAVA_FILE_DIR):
        if os.path.splitext(file)[-1] == ".class":
            os.remove(JOIN(JAVA_FILE_DIR,file))


if __name__ == "__main__":

    # java文件转class文件
    java2class(JAVA_FILE_DIR)
    # class文件转dex文件
    class2dex(JAVA_FILE_DIR)
    # dex文件转smali文件
    dex2smali(DEX_FILE_DIR)
    # 删除无用文件
    deleteTempFile(JAVA_FILE_DIR)
    