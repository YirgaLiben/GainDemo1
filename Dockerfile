FROM mcr.microsoft.com/dotnet/core/sdk:3.1 AS build
WORKDIR /app
# copy sln and csproj files into the image
COPY *.sln .
COPY src/DemoAPI/*.csproj ./src/DemoAPI/
COPY test/DemoAPI.Tests/*.csproj ./test/DemoAPI.Tests/
# restore package dependencies for the solution
RUN dotnet restore

# copy full solution over
COPY . .

# build the solution
RUN dotnet build

# run the unit tests
FROM build AS test
WORKDIR /app/test/DemoAPI.Tests
RUN dotnet test --logger:trx


# publish the API
FROM build AS publish
WORKDIR /app/src/DemoAPI
RUN dotnet publish -c Release -o out

# run the api
FROM mcr.microsoft.com/dotnet/core/aspnet:3.1 AS runtime
WORKDIR /app
# copy over the files produced when publishing the service
COPY --from=publish /app/src/DemoAPI/out ./
# expose port 80 as our application will be listening on this port
EXPOSE 80
# run the web api when the docker image is started
ENTRYPOINT ["dotnet", "DemoAPI.dll"]