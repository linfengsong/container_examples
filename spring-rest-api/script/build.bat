set ScriptPath=%~dp0
set ScriptPath=%ScriptPath:~0,-1%

pushd %ScriptPath%\..
set srcDir=%CD%
popd

if not exist %srcDir%\bin\apache-maven-3.9.6 (
  powershell -Command "(New-Object Net.WebClient).DownloadFile('https://dlcdn.apache.org/maven/maven-3/3.9.6/binaries/apache-maven-3.9.6-bin.zip', '%srcDir%\bin\apache-maven-3.9.6-bin.zip')"
  powershell -command "Expand-Archive -Force '%srcDir%\bin\apache-maven-3.9.6-bin.zip' '%srcDir%\bin'"
) 

pushd %srcDir%
call %srcDir%\bin\apache-maven-3.9.6\bin\mvn clean compile install
popd

mkdir %srcDir%\target\image
xcopy %srcDir%\target\rest-api-0.0.1-SNAPSHOT.jar %srcDir%\target\image
xcopy %srcDir%\Dockerfile %srcDir%\target\image

docker build -t spring-rest-api:latest %srcDir%\target\image
