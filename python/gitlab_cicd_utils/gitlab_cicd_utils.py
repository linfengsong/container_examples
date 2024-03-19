"""Main module."""

import os
import template_replace
       
print('start')
configFile = 'C:/linfeng/work-java-sample/helm_test/values.yaml'
directory = 'C:\\linfeng\\work-java-sample\\python\\gitlab-utils'

if not os.path.isfile(configFile):
    print("file: "+ configFile + " does not exist")
    exit(1)
template_replace.replaceTemplates(configFile, directory)

