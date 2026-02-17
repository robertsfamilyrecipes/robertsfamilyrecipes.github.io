$ErrorActionPreference="Stop"
Set-StrictMode -Version Latest

.\src\install-modules.ps1
$results = Invoke-Pester -PassThru -Path .\test\*
if($results.FailedCount -gt 0){
    throw "pester tests failed"
}
.\src\build-recipes.ps1
.\src\build-index.ps1