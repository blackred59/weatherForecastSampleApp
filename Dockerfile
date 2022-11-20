FROM mcr.microsoft.com/dotnet/aspnet:5.0 AS base
WORKDIR /app

FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build
WORKDIR /src
COPY ["sample-app.csproj", "./"]
RUN dotnet restore "sample-app.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "sample-app.csproj" -c Release -o /src/build 

FROM build AS publish
RUN dotnet publish "sample-app.csproj" -c Release -o /src/publish

FROM base AS final
WORKDIR /src
COPY --from=publish /src/publish .
EXPOSE 5000
ENV ASPNETCORE_URLS http://*:5000
ENTRYPOINT ["dotnet", "sample-app.dll"]
