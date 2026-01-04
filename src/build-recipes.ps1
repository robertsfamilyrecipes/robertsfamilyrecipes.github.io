$ErrorActionPreference="Stop"
Set-StrictMode -Version Latest
Import-Module "$PsScriptRoot\ConvertFrom-MarkDig.psm1"

function Build-Article {
    param (
        [string] $Template,
        [IO.FileInfo] $SourceFile,
        [string] $TargetFolder
    )

    $outfile = "$TargetFolder\$($SourceFile.BaseName).html"
    $recipe, $metadata = (Get-Content $SourceFile -Raw) | ConvertFrom-MarkDig
    $html = $Template -replace '##Recipe##', $recipe
    Write-Host "Writing $outfile"
    $html | Out-File -FilePath $outfile
}

$targetFolder = "$PsScriptRoot\..\docs\recipes"
$template = Get-Content "$PsScriptRoot\templates\recipe.html" -Raw

Get-ChildItem -Path "$PsScriptRoot\recipes\*" -File -Include *.md | ForEach-Object {
    Build-Article -Template $template -SourceFile $_ -TargetFolder $targetFolder
}

