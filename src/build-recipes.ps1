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
    $html, $metadata = (Get-Content $SourceFile -Raw) | ConvertFrom-MarkDig
    $outHtml = $Template -replace '##Recipe##', $html
    $outHtml = $outHtml -replace '##Title##', $metadata.title
    $outHtml = $outHtml -replace '##CreatedDate##', ([bool]$metadata['createdDate'] ? "Created: $($metadata.createdDate)" : "")
    $outHtml = $outHtml -replace '##UpdatedDate##', ([bool]$metadata['updatedDate'] ? "Updated: $($metadata.updatedDate)" : "")
    Write-Host "Writing $outfile"
    $outHtml | Out-File -FilePath $outfile
}

$targetFolder = "$PsScriptRoot\..\docs\recipes"
$template = Get-Content "$PsScriptRoot\templates\recipe.html" -Raw

Get-ChildItem -Path "$PsScriptRoot\recipes\*" -File -Include *.md | ForEach-Object {
    Build-Article -Template $template -SourceFile $_ -TargetFolder $targetFolder
}

