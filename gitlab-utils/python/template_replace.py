import sys
import os
import yaml
                                    
def __getValueByPath(yamlData, key):
    if yamlData == "":
        return ""
    index = key.find('.')
    if index < 0:
        return __getValue(yamlData, key)
    fkey = key[0: index]
    rkey = key[index + 1: len(key)]
    print("fkey: " + fkey + ", rkey: " + rkey)
    return __getValueByPath(__getValue(yamlData, fkey), rkey)
    
def __getValue(yamlData, key):
    if key in yamlData.keys():
        return  yamlData[key]
    else:
        return ""

def __processLine(wf, yamlData, line, nameTag = "", valueTag = ""):
    sindex = line.find('%[')
    if sindex < 0:
        print(line)
        return
    eindex = line.find(']%', sindex)
    if eindex < 0:
        print(line)
        return
    name = line[sindex + 2: eindex]
    if nameTag == name:
        value = valueTag
    else:
        value = __getValueByPath(yamlData, name)
    nLine = line[0: sindex] + value + line[eindex + 2: len(line)]
    __processLine(wf, yamlData, nLine)

def __processBlock(wf, yamlData, blockName, block):
    iyamlData = __getValueByPath(yamlData, blockName)
    if iyamlData == "":
        return
    for k in iyamlData.keys():
        v = __getValueByPath(iyamlData, k)
        for line in block:
            __processLine(wf, yamlData, line, nameTag = "NAME", valueTag = v)
                
        
def __processingTemplateFile(yamlData, inFile, outFile):
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
                        __processBlock(wf, yamlData, blockName, block)
                    else:
                        block.append(line)
                elif rline.startswith('%%[START:') and rline.endswith(']%%'):
                    blockName = rline[9 : len(rline) - 3]
                else:
                    __processLine(wf, yamlData, line)

def __processingTemplate(yamlData, path):
    if os.path.isfile(path):
        if path.endswith(".template"):
            outFile = path[0 : len(path) - 9]
            print("replace template to " + outFile)
            __processingTemplateFile(yamlData, path, outFile)
    else:
        for filename in os.listdir(path):
            __processingTemplate(yamlData, os.path.join(path, filename))

def replaceTemplates(configFile, directory):
    with open(configFile, 'r') as file:
        yamlData = yaml.safe_load(file)
        __processingTemplate(yamlData, directory)

if __name__ == "__main__":
    print("main")
    iArgs = len(sys.argv)
    if iArgs == 3:
        print("Args: configFile directory")
        exit(1)
    configFile = sys.argv[1]
    directory = sys.argv[2]
    replaceTemplates(configFile, directory)
    