$ErrorActionPreference="Stop"
Set-StrictMode -Version 1.0


# Also installed dotnet 9 SDK
Find-Package -Name markdig -ProviderName NuGet | Install-Package 