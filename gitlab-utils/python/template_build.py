import sys
import os
import yaml

import template_replace

def  __build_ci_query(appName, ciInstPath, yamlQueryArray, outputPath):
  print("build ci app: " + $apName)
  appPath = outputPath + "/ci/" + apName
  configYmlFile = appPath + "/config.yml"
  with open(configYmlFile, 'w') as wf:
    #echo "IMAGE_TYPE: $IMAGE_TYPE" > "$configYmlFile"
    #echo "inst: $appName.">> "$configYmlFile"
    wf.write("inst: " + $appName + ".\n")
    wf.write("gitlibAppConfPath: " + $appPath + "\n")
    with open(ciInstPath, 'r') as rf:
        lines = rf.readlines()
        for line in lines:
            wf.write(line)
    yamlData = yaml.safe_loadconfigYmlFile)
    query = YamlQuery()
    query.rootPath = "ci." + $appName
    query.yamlData = yaml.safe_loadconfigYmlFile)
    yamlQueryArray.append(query)

def  __build_cdbcp_query(appName, ciInstPath, yamlQueryArray, outputPath):
  print("build ci app: " + $apName)
  appPath = outputPath + "/cd_bcp/" + apName
  confPath = appPath + "/conf"
  configYmlFile = confPath + "/config.yml"
  with open(configYmlFile, 'w') as wf:
    wf.write("inst: " + $appName + ".\n")
    wf.write("gitlibAppPath: " + $appPath + "\n")
    with open(ciInstPath, 'r') as rf:
        lines = rf.readlines()
        for line in lines:
            wf.write(line)
    yamlData = yaml.safe_loadconfigYmlFile)
    query = YamlQuery()
    query.rootPath = "cd." + $appName
    query.yamlData = yaml.safe_loadconfigYmlFile)
    yamlQueryArray.append(query)

def template_build(appYamlData, ciInstPath, cdbcpInstPath, yamlQueryArray, outputPath):
    appQyery = YamlQuery()
    appQyery.yamlData = appYamlData
    yamlQueryArray = [appQyery]
    if "ci" in yamlData.keys():    
        ciData = yamlData["ci"]
        for appName in ciData.keys():
            __build_ci_query(appName, ciInstPath, yamlQueryArray, outputPath)
    if "cd_bcp" in yamlData.keys():
        cdbcpData = yamlData["cd_bcp"]
        for appName in cdbcpData.keys():
            __build_cdbcp_query(appName, cdbcpInstPath, yamlQueryArray, outputPath)
    processingTemplate(yamlQueryArray, outputPath)
      
if __name__ == "__main__":
    print("main")
    iArgs = len(sys.argv)
    if iArgs < 5:
        print("Args: -a appConfigFile -c <configFile> -t <template directory>")
        exit(1)
    argv = sys.argv
    inputType = None
    appYamlData = None
    ciInstPath = None
    cdbcpInstPath = None
    outputPath = none
    yamlQueryArray = []
    for i in range(1, len(argv)):
        if argv[i].startswith("-"):
            inputType = argv[i]
        elif inputType == "-a":
            print("application config file: " + argv[i])
            appYamlData = yaml.safe_load(argv[i])
            appQyery = YamlQuery()
            appQyery.yamlData = appYamlData
            yamlQueryArray.append(appQyery)
            inputType = None
        elif inputType == "-ci":
            print("ci config file: " + argv[i])
            ciQyery = YamlQuery()
            ciQyery.yamlData = yaml.safe_load(argv[i])
            yamlQueryArray.append(ciQyery)
            inputType = None
        elif inputType == "-ci-inst":
            print("ci inst Path: " + argv[i])
            ciInstPath = argv[i]
            inputType = None
        elif inputType == "-cdbcp":
            print("cdbcp config file: " + argv[i])
            cdbcpQyery = YamlQuery()
            cdbcpQyery.yamlData = yaml.safe_load(argv[i])
            yamlQueryArray.append(cdbcpQyery)
            inputType = None
        elif inputType == "-cdbcp-inst":
            print("cdbcp inst Path: " + argv[i])
            cdbcpInstPath = argv[i]
            inputType = None
        elif inputType == "-output":
            print("output Path: " + argv[i])
            cdbcpInstPath = argv[i]
            outputPath = None
    template_build(appYamlData, ciInstPath, cdbcpInstPath, yamlQueryArray, outputPath)
