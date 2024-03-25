import sys
import os
import yaml

def __getValue(yamlData, key):
    if yamlData is None:
        return None
    if key in yamlData.keys():
        return yamlData[key]
    return None
                                    
def __getValueByYamlData(yamlData, key):
    index = key.find('.')
    if index < 0:
        return __getValue(yamlData, key)
    fkey = key[0: index]
    rkey = key[index + 1: len(key)]
    return __getValueByYamlData(__getValue(yamlData, fkey), rkey)
    
def __getValueByPath(type, yamlDataArray, key):
    if key.startswith("cd."):
        key = type + "." + key[3:len(key)]
    if key.startswith("ci."):
        key = type + "." + key[3:len(key)]
    for yamlData in yamlDataArray:
        value = __getValueByYamlData(yamlData, key)
        if not value is None:
            return value
    print("Cannot find key value: " + key)
    return ""

def __processLine(wf, type, yamlDataArray, line, nameTag = "", valueTag = ""):
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
        value = __getValueByPath(type, yamlDataArray, name)
    nLine = line[0: sindex] + value + line[eindex + 2: len(line)]
    __processLine(wf, type, yamlDataArray, nLine)

def __processBlock(wf, type, yamlDataArray, blockName, block):
    iyamlData = __getValueByPath(type, yamlDataArray, blockName)
    if iyamlData == "":
        return
    if not iyamlData is None:
        for k in iyamlData.keys():
            v = __getValueByPath(iyamlData, k)
            for line in block:
                __processLine(wf, type, yamlDataArray, line, nameTag = "NAME", valueTag = v)
                
        
def __processingTemplateFile(type, yamlDataArray, inFile, outFile):
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
                        __processBlock(wf, type, yamlDataArray, blockName, block)
                    else:
                        block.append(line)
                elif rline.startswith('%%[START:') and rline.endswith(']%%'):
                    blockName = rline[9 : len(rline) - 3]
                else:
                    __processLine(wf, type, yamlDataArray, line)

def __processingTemplate(type, yamlDataArray, path):
    if os.path.isfile(path):
        if path.endswith(".template"):
            outFile = path[0 : len(path) - 9]
            print("replace template to " + outFile)
            __processingTemplateFile(type, yamlDataArray, path, outFile)
    else:
        for filename in os.listdir(path):
            __processingTemplate(type, yamlDataArray, os.path.join(path, filename))
            
def __update(source, update):
    for i in update:
        source.update({update[i]})
    
      
if __name__ == "__main__":
    print("main")
    iArgs = len(sys.argv)
    if iArgs < 5:
        print("Args: type -c <configFile> -t <template directory>")
        exit(1)
    argv = sys.argv
    type = argv[1]
    yamlDataArray = []
    inputType = None
    for i in range(2, len(argv)):
        if argv[i] == "-c":
            inputType = "-c"
        elif inputType == "-c":
            print("input config file: " + argv[i])
            with open(argv[i], 'r') as file:
                yamlDataArray.append(yaml.safe_load(file))
            inputType = None
    for i in range(2, len(argv)):
        if argv[i] == "-t":
            inputType = "-t"
        elif  inputType == "-t":
            print("template path: " + argv[i])
            __processingTemplate(type, yamlDataArray, argv[i])
            inputType = None