FROM registry.example.com/cto_shared/dotnet-aspnet-6-0:latest

ARG PUBLISHDIR='./app'

WORKDIR /app

COPY $PUBLISHDIR/* .

EXPOSE 8080

ENTRYPOINT ["dotnet", "MyApplication.hellohelm.dll"]