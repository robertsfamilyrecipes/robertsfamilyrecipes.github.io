$ErrorActionPreference="Stop"
Set-StrictMode -Version Latest
Import-Module "$PsScriptRoot\ConvertFrom-MarkDig.psm1" -Force

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
        canonical = "https://robertsfamilyrecipes.com/recipes/$($SourceFile.BaseName).html";
        title = $metadata.title;
        photo = ([bool]$metadata['photo'] -eq $false ? "" :
@"
<figure>
<p><img src="$($metadata.photo)" alt="$($metadata.title)" /></p>
</figure>
"@);
        info = @"
<div class='strap-line'>
  <div class='info'>
    <div><i class='icon user mr-1'></i>Serves: $($metadata.serves)</div>
    <div><i class='icon clock mr-1'></i>Cook Time: $($metadata.duration)</div>
  </div>
  <div class='print-area'>
    <button onclick='window.print();return false;'><i class='icon printer mr-1'></i>Print</button>
  </div>
</div>  
"@;
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

