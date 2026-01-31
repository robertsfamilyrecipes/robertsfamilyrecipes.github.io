$ErrorActionPreference="Stop"
Set-StrictMode -Version 1.0

# Also installed dotnet 9 SDK

if (Get-Module -ListAvailable -Name "Pester") {
    Write-Host "Module 'Pester' is already installed."
} else {
    # https://pester.dev/
    Install-Module Pester -Force
}

if (Get-Module -ListAvailable -Name "powershell-yaml") {
    Write-Host "Module 'powershell-yaml' is already installed."
} else {
    # https://github.com/cloudbase/powershell-yaml
    Install-Module powershell-yaml
}

if (Get-Package -Name "markdig"){
    Write-Host "Package 'markdig' is already installed."
} else {
    # https://github.com/xoofx/markdig/
    Find-Package -Name markdig -ProviderName NuGet | Install-Package 
}
