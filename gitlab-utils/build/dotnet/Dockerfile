FROM registry.access.redhat.com/dotnet-aspnet-6-0:latest
ARG PUBLISH_DIR=/publish
ARG DOTNET_LAUNCH_DLL=MyApplication.MyProject.dll
WORKDIR /app
COPY $PUBLISH_DIR/* .
ENTRYPOINT ["dotnet", "${DOTNET_LAUNCH_DLL}"]