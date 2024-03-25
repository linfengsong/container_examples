import sys
import os
import yaml

class YamlQuery:
  rootPath = None
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
              path = path[len(self.rootPath) + 1:]
      return self.__getValueByPath(self.yamlData, path)
                                        
def __getValueByPath(yamlQueryArray, path):
    for yamlQuery in yamlQueryArray:
        value = yamlQuery.getValueByPath(path)
        if not value is None:
            return value
    print("Cannot find path value: " + path)
    return ""

def __processLine(wf, yamlQueryArray, line, nameTag = "", valueTag = ""):
    eindex = line.find(']%')
    if eindex < 0:
        wf.write(line + "\n")
        return
    index = line.find('%[')
    while index >= 0 and index < eindex:
        sindex = index
        index = line.find('%[', sindex + 1)
    if sindex < 0:
        wf.write(line + "\n")
        return
    
    name = line[sindex + 2: eindex]
    if nameTag == name:
        value = valueTag
    else:
        value = __getValueByPath(yamlQueryArray, name)
    nLine = line[0: sindex] + value + line[eindex + 2: len(line)]
    __processLine(wf, yamlQueryArray, nLine)

def __processBlock(wf, yamlDataArray, blockName, block):
    iyamlData = __getValueByPath(yamlQueryArray, blockName)
    if iyamlData == "":
        return
    if not iyamlData is None:
        for k in iyamlData.keys():
            v = __getValueByPath(iyamlData, k)
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
                    blockName = rline[9 : len(rline) - 3]
                else:
                    __processLine(wf, yamlQueryArray, line)

def __processingTemplate(yamlQueryArray, path):
    if os.path.isfile(path):
        if path.endswith(".template"):
            outFile = path[0 : len(path) - 9]
            print("replace template to " + outFile)
            __processingTemplateFile(yamlQueryArray, path, outFile)
    else:
        for filename in os.listdir(path):
            __processingTemplate(yamlQueryArray, os.path.join(path, filename))
            
def __update(source, update):
    for i in update:
        source.update({update[i]})
    
      
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
                rootPath = list[0]
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
            __processingTemplate(yamlQueryArray, argv[i])
            inputType = None
