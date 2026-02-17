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
    $metadata, $intro, $sections = (Get-Content $SourceFile -Raw) | Split-Document | ForEach-Object {
        ConvertFrom-MarkDig $_
    }
    $replacements = @{
        title = $metadata.title;
        canonical = "https://robertsfamilyrecipes.com/recipes/$($SourceFile.BaseName).html";
        serves = "Serves: $($metadata.serves)";
        duration = "Cook Time: $($metadata.duration)";
        intro = $intro;
        sections = $sections;
        createdDate = "Created: $($metadata.createdDate)";
        updatedDate = ([bool]$metadata['updatedDate'] ? "Updated: $($metadata.updatedDate)" : "");
    }
    
    $outHtml = $ExecutionContext.InvokeCommand.ExpandString($Template)
    Write-Host "Writing $outfile"
    $outHtml | Out-File -FilePath $outfile
}

$targetFolder = "$PsScriptRoot\..\docs\recipes"
# see https://stackoverflow.com/a/60385403
$template = Get-Content "$PsScriptRoot\templates\recipe.html" -Raw

Get-ChildItem -Path "$PsScriptRoot\recipes\*" -File -Include *.md | ForEach-Object {
    Build-Article -Template $template -SourceFile $_ -TargetFolder $targetFolder
}

