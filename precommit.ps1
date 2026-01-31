$ErrorActionPreference="Stop"
Set-StrictMode -Version Latest

.\src\install-modules.ps1
Invoke-Pester -Path .\test\*
.\src\build-recipes.ps1
.\src\build-index.ps1