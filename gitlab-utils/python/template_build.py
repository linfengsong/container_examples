import sys
import os
import yaml
import shutil
import glob
from pathlib import Path
import template_replace

def __createQuery(yamlPath, rootPath = None):
  print("Load yaml file: " + yamlPath)
  os.system("cat " + yamlPath)
  with open(yamlPath, 'r') as file:
    yamlData = yaml.safe_load(file)
    query = template_replace.YamlQuery()
    query.rootPath = rootPath
    query.yamlData = yamlData
    return query
    
def __createQueryArray(appQuery, defaultPath, appPath):
    query = template_replace.YamlQuery()
    query.rootPath = appPath
    query.prefixPath = defaultPath
    query.yamlData = appQuery.yamlData
    return [appQuery, query]
    
def __getImageType(srcPath):
  slnFiles = glob.glob(srcPath + '/*.sln')
  mavenfile = Path(srcPath + "/pom.xml")
  packageFile = Path(srcPath + "/package.json")
  distDir = Path(srcPath + "/dist")
  srcDir = Path(srcPath + "/src")
  if mavenfile.is_file():
    return "maven"
  elif len(slnFiles) > 0:
    return "dotnet"
  elif packageFile.is_file():
    return "httpd"
  elif distDir.is_dir():
    return "httpd"
  elif srcDir.is_dir():
    return "httpd"
  else:
    return "unknown"

def  __build_ci_query(appName, ciPath, appSrcPath, appQuery, ciQuery, appOutputPath):
  print("Build ci app: " + appName)
  yamlQueryArray = [appQuery, ciQuery]
  yamlQueryArray = __createQueryArray(appQuery, "ci.default.", "ci.applications." + appName + ".")
  yamlQueryArray.append(ciQuery)
  configPath = appOutputPath + "/conf"
  shutil.copytree(ciPath + "/conf", configPath)
  configYmlFile = configPath + "/config.yml"
  with open(configYmlFile, 'w') as wf:
    imageType = __getImageType(appSrcPath)
    wf.write("inst: ci.applications." + appName + ".\n")
    wf.write("appPath: " + appOutputPath + "\n")
    wf.write("image:\n")
    wf.write("  type: " + imageType + "\n")
    with open(configPath + "/ci_inst.yml", 'r') as rf:
        lines = rf.readlines()
        for line in lines:
            wf.write(line) 
  query = __createQuery(configYmlFile, "ci.applications." + appName + ".")
  yamlQueryArray.append(query)
  template_replace.processingTemplate(yamlQueryArray, appOutputPath)

def  __build_bcp_query(appName, bcpPath, appQuery, appOutputPath):
  print("Build bcp app: " + appName)
  yamlQueryArray = __createQueryArray(appQuery, "bcp.default.", "bcp.applications." + appName + ".")
  os.mkdir(appOutputPath)
  configPath = appOutputPath + "/conf"
  shutil.copytree(bcpPath + "/conf", configPath)
  shutil.copytree(bcpPath + "/infra", appOutputPath + "/infra")
  configYmlFile = configPath + "/config.yml"
  with open(configYmlFile, 'w') as wf:
    wf.write("inst: bcp.applications." + appName + ".\n")
    wf.write("applicationName: " + appName + "\n")
    wf.write("appPath: " + appOutputPath + "\n")
    with open(configPath + "/bcp_inst.yml", 'r') as rf:
        lines = rf.readlines()
        for line in lines:
            wf.write(line)
  query = __createQuery(configYmlFile, "bcp.applications." + appName + ".")
  yamlQueryArray.append(query)
  template_replace.processingTemplate(yamlQueryArray, appOutputPath)

def template_build(envName, appSrcPath, utilPath, actionType, appName):
    appConfigFile = Path(appSrcPath + "/conf/" + appName + "_cicd_" + envName + ".yml")
    if appConfigFile.is_file():
        appQuery = __createQuery(appSrcPath + "/conf/" + appName + "_cicd_" + envName + ".yml")
    else:
        appQuery = __createQuery(appSrcPath + "/conf/cicd_" + envName + ".yml")
    outputPath = utilPath + "/apps"
    os.mkdir(outputPath)
    
    if actionType == "ci":
        ciOutputPath = outputPath + "/ci"
        os.mkdir(ciOutputPath)
        ciQuery = __createQuery(utilPath + "/ci/conf/ci.yml")
        __build_ci_query(appName, utilPath + "/ci", appSrcPath, appQuery, ciQuery, ciOutputPath + "/" + appName)
        os.system("cat " + ciOutputPath + "/" + appName + "/conf/ci.env")
    elif actionType == "bcp":
        bcpOutputPath = outputPath + "/bcp"
        os.mkdir(bcpOutputPath)
        __build_bcp_query(appName, utilPath + "/bcp", appQuery, bcpOutputPath + "/" + appName)
        os.system("cat " + bcpOutputPath + "/" + appName + "/conf/bcp.env")
      
if __name__ == "__main__":
    print("main")
    iArgs = len(sys.argv)
    if iArgs < 4:
        print("Args: envName appSrcPath utilPath")
        exit(1)
    envName = sys.argv[1]
    appSrcPath = sys.argv[2]
    utilPath = sys.argv[3]
    actionType = sys.argv[4]
    appName = sys.argv[5]
    print("Build gitlab util start")
    print("envName: " + envName)
    print("appSrcPath: " + appSrcPath)
    print("utilPath: " + utilPath)
    print("actionType: " + actionType)
    print("appName: " + appName)
       
    template_build(envName, appSrcPath, utilPath, actionType, appName)
    
    print("Build gitlab util finish")
