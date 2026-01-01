$ErrorActionPreference="Stop"
Set-StrictMode -Version Latest

<#
Import-Module "$PsScriptRoot\ConvertFrom-Markdig.psm1" -Force

$outFolder = "$PsScriptRoot\..\docs\recipes"
Get-ChildItem -Path "$PsScriptRoot\recipes" | ForEach-Object {
    $file = $_
    $outfile = "$outFolder\$($file.BaseName).html"

    Write-Host "Writing $outfile"
    (Get-Content $file -Raw) | ConvertFrom-MarkDig -UseDefinitionLists | Out-File $outfile
}
#>
.\build-index.ps1
