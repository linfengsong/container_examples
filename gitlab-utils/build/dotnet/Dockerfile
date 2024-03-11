FROM mcr.microsoft.com/dotnet/aspnet:6.0
ARG PUBLISH_DIR=/publish
WORKDIR /app
COPY $PUBLISH_DIR .
ENTRYPOINT ["dotnet", "/app/aspnetapp.dll"]
