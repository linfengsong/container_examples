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

kubectl get po -A|findstr kube-controller-manager-docker-desktop
if %errorlevel% NEQ 0 (
  kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v0.40.2/deploy/static/provider/cloud/deploy.yaml
)

helm list|findstr loadbalance
if %errorlevel% EQU 0 (
  helm delete loadbalance
)

helm install -f %valueFile% loadbalance %srcDir%\helm\loadbalance

helm list|findstr swag
if %errorlevel% EQU 0 (
  helm delete swag
)

helm install -f %valueFile% swag %srcDir%\helm\swag
