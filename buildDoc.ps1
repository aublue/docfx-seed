#Downloading DocFx

New-Item -Path './docfx_tooling' -ItemType Directory
Invoke-WebRequest -OutFile ./docfx_tooling/nugetPackage.zip https://www.nuget.org/api/v2/package/docfx.console
cd './docfx_tooling'
Expand-Archive "nugetPackage.zip"

Move-Item -Path .\nugetPackage\tools\* -Destination .
Remove-Item .\nugetPackage -Force -Recurse
Remove-Item .\nugetPackage.zip

cd ..

#Downloading Swashbuckle

New-Item -Path './swashbuckle_tooling' -ItemType Directory
dotnet tool install Swashbuckle.AspNetCore.Cli --tool-path './swashbuckle_tooling'


#start building openapi definition(s)

.\swashbuckle_tooling\swagger.exe tofile --serializeasv2 --output .\restapi\DemoWebApp.json .\src\SampleClass1\DemoWebApp\bin\Debug\net6.0\DemoWebApp.dll v1
.\swashbuckle_tooling\swagger.exe tofile --output --basepath http://localhost:8080 .\articles\openAPI\openapispec.md .\src\SampleClass1\DemoWebApp\bin\Debug\net6.0\DemoWebApp.dll v1

#Creating documentation

.\docfx_tooling\docfx.exe .\docfx.json --serve

#Cleanup

Remove-Item .\docfx_tooling -Force -Recurse
Remove-Item .\swashbuckle_tooling -Force -Recurse