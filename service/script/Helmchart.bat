set ScriptPath=%~dp0
set ScriptPath=%ScriptPath:~0,-1%

pushd %ScriptPath%\..
set srcDir=%CD%
popd

set tmpDir=%UserProfile%\tmp\swag
set workingDir=%tmpDir%\helm

mkdir %workingDir%

SET initFile=%srcDir%\conf\service_desktop.ini

set valueFile=%workingDir%\values.yaml
copy %srcDir%\helm\values.yaml.template %workingDir%
powershell -executionpolicy remotesigned -File %ScriptPath%\UtilToken.ps1 %initFile% env %workingDir%\values.yaml.template false
powershell -executionpolicy remotesigned -File %ScriptPath%\UtilToken.ps1 %initFile% service %workingDir%\values.yaml.template true

kubectl get po -A|findstr nginx-ingress-nginx-controller
if %errorlevel% NEQ 0 (
  helm install --namespace kube-system nginx ingress-nginx --repo https://kubernetes.github.io/ingress-nginx
)

helm list|findstr spring-rest-api
if %errorlevel% EQU 0 (
  helm delete spring-rest-api
)

helm list|findstr swag
if %errorlevel% EQU 0 (
  helm delete swag
)

:while
@echo off
timeout 3 > NUL
kubectl get pod|findstr swag
if %errorlevel% EQU 0 (
  goto :while
)
@echo on

helm install -f %valueFile% swag %srcDir%\helm\swag

helm install -f %valueFile% spring-rest-api %srcDir%\helm\spring-rest-api
