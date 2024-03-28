import sys
import os
import yaml

class YamlQuery:
  rootPath = None
  prefixPath = None
  yamlData = None

  def __getValue(self, yamlData, key):
      if yamlData is None:
          return None
      if key in yamlData.keys():
          return yamlData[key]
      return None
      
  def __getValueByPath(self, yamlData, path):
      index = path.find('.')
      if index < 0:
        return self.__getValue(yamlData, path)
      fkey = path[0: index]
      rpath = path[index + 1: len(path)]
      return self.__getValueByPath(self.__getValue(yamlData, fkey), rpath)
        
  def getValueByPath(self, path):
      if not self.rootPath is None:
          if path.startswith(self.rootPath):
              path = path[len(self.rootPath):]
              if not self.prefixPath is None:
                  path = self.prefixPath + path
      return self.__getValueByPath(self.yamlData, path)
                                        
def __getValueByPath(yamlQueryArray, path):
    for yamlQuery in yamlQueryArray:
        value = yamlQuery.getValueByPath(path)
        if not value is None:
            return value
    print("Cannot find path value: " + path)
    return None

def __processString(yamlQueryArray, str, nameTag = "", valueTag = ""):
    eindex = str.find(']%')
    if eindex < 0:
        return str
    index = str.find('%[')
    while index >= 0 and index < eindex:
        sindex = index
        index = str.find('%[', sindex + 1)
    if sindex < 0:
        return str
    
    name = str[sindex + 2: eindex]
    if name == "NAME":
        value = nameTag
    elif name == "VALUE":
        value = valueTag
    else:
        value = __getValueByPath(yamlQueryArray, name)
    if value is None:
        value = ""
    nString = str[0: sindex] + value + str[eindex + 2: len(str)]
    return __processString(yamlQueryArray, nString, nameTag, valueTag)

def __processLine(wf, yamlQueryArray, line, nameTag = "", valueTag = ""):
    nLine = __processString(yamlQueryArray, line, nameTag, valueTag)
    wf.write(nLine + "\n")

def __processBlock(wf, yamlQueryArray, blockName, block):
    print("processBlock " + blockName)
    iyamlData = __getValueByPath(yamlQueryArray, blockName)
    if iyamlData is None:
        return

    for k in iyamlData.keys():
        v = iyamlData[k]
        print("k: " + k + ", v: " + v)
        for line in block:
            __processLine(wf, yamlQueryArray, line, nameTag = "NAME", valueTag = v)
                
        
def __processingTemplateFile(yamlQueryArray, inFile, outFile):
    with open(inFile, 'r') as rf:
        with open(outFile, 'w') as wf:
            lines = rf.readlines()
            blockName = ""
            block = []
            for line in lines:
                if line.endswith('\n'):
                    line = line[0: len(line) - 1]
                if line.endswith('\r'):
                    line = line[0: len(line) - 1]
                rline = line.strip()
                if not blockName == "":
                    if rline.startswith('%%[END]%%'):
                        __processBlock(wf, yamlQueryArray, blockName, block)
                    else:
                        block.append(line)
                elif rline.startswith('%%[START:') and rline.endswith(']%%'):
                    blockName = __processString(yamlQueryArray, rline[9 : len(rline) - 3])
                else:
                    __processLine(wf, yamlQueryArray, line)

def processingTemplate(yamlQueryArray, path):
    if os.path.isfile(path):
        if path.endswith(".template"):
            outFile = path[0 : len(path) - 9]
            print("replace template to " + outFile)
            __processingTemplateFile(yamlQueryArray, path, outFile)
    else:
        for filename in os.listdir(path):
            processingTemplate(yamlQueryArray, os.path.join(path, filename))
               
if __name__ == "__main__":
    print("main")
    iArgs = len(sys.argv)
    if iArgs < 5:
        print("Args: -c <configFile> -t <template directory>")
        exit(1)
    argv = sys.argv
    yamlQueryArray = []
    inputType = None
    for i in range(1, len(argv)):
        if argv[i] == "-c":
            inputType = "-c"
        elif inputType == "-c":
            print("input config file: " + argv[i])
            list = argv[i].split(":")
            rootPath = None
            filePath = list[0]
            if len(list) == 1:
                rootPath = None
                filePath = list[0]
            else:
                rootPath = list[0] + "."
                filePath = list[1]
            with open(filePath, 'r') as file:
                yamlQurry = YamlQuery()
                yamlQurry.rootPath = rootPath
                yamlQurry.yamlData = yaml.safe_load(file)
                yamlQueryArray.append(yamlQurry)
            inputType = None
    for i in range(1, len(argv)):
        if argv[i] == "-t":
            inputType = "-t"
        elif  inputType == "-t":
            print("template path: " + argv[i])
            processingTemplate(yamlQueryArray, argv[i])
            inputType = None
