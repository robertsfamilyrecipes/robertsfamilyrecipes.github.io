$ErrorActionPreference="Stop"
Set-StrictMode -Version 1.0

# This file only needs to be run once to install this stuff

# Also installed dotnet 9 SDK
# https://github.com/xoofx/markdig/
Find-Package -Name markdig -ProviderName NuGet | Install-Package 
# https://pester.dev/
Install-Module Pester -Force
# https://github.com/cloudbase/powershell-yaml
Install-Module powershell-yaml