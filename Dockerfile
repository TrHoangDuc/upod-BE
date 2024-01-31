FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
ARG BUILD_CONFIGURATION=Release
WORKDIR /src
COPY ["UPOD.API/UPOD.API.csproj", "UPOD.API/"]
COPY ["UPOD.REPOSITORIES/UPOD.REPOSITORIES.csproj", "UPOD.REPOSITORIES/"]
COPY ["UPOD.SERVICES/UPOD.SERVICES.csproj", "UPOD.SERVICES/"]
RUN dotnet restore "./UPOD.API/./UPOD.API.csproj"
COPY . .
WORKDIR "/src/UPOD.API"
RUN dotnet build "./UPOD.API.csproj" -c $BUILD_CONFIGURATION -o /app/build

FROM build AS publish
ARG BUILD_CONFIGURATION=Release
RUN dotnet publish "./UPOD.API.csproj" -c $BUILD_CONFIGURATION -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "UPOD.API.dll"]