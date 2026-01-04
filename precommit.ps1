$ErrorActionPreference="Stop"
Set-StrictMode -Version Latest

Invoke-Pester -Path .\test\*
.\src\build-recipes.ps1
.\src\build-index.ps1