set ScriptPath=%~dp0
set ScriptPath=%ScriptPath:~0,-1%

pushd %ScriptPath%\..
set srcDir=%CD%
popd

docker build -t swag:latest .
