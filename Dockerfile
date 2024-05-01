# Use Railway.app compatible base image
FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 3000  # Expose the port used by Railway.app

ENV ASPNETCORE_URLS=http://+:3000  # Configure ASP.NET Core URLs
ENV ASPNETCORE_ENVIRONMENT=Production  # Set ASP.NET Core environment to Production

# Set any additional environment variables required by Railway.app
# ENV RAILWAY_ENV=production

# Build Stage
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY ["5s.csproj", "./"]
RUN dotnet restore "./5s.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "5s.csproj" -c Release -o /app/build

# Publish Stage
FROM build AS publish
RUN dotnet publish "5s.csproj" -c Release -o /app/publish

# Final Stage
FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "5s.dll"]