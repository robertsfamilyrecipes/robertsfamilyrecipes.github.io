$ErrorActionPreference="Stop"
Set-StrictMode -Version Latest

function ConvertFrom-MarkDig {
    [CmdletBinding()]
    [OutputType([String])]
    param (
        [Parameter(ValueFromPipeline, Mandatory=$true)]
        [string] $MarkDown
    )

    # create a pipeline builder object
    $pipelineBuilder = [MarkDig.MarkdownPipelineBuilder]::new()
    [void][MarkDig.MarkdownExtensions]::UseAdvancedExtensions($pipelineBuilder)

    # build the pipeline object
    $pipeline = $pipelineBuilder.Build()

    # convert to html
    $outHtml = [MarkDig.Markdown]::ToHtml($MarkDown,$pipeline)

    Write-Output $outHtml
}

function Build-Article {
    param (
        [string] $Template,
        [IO.FileInfo] $SourceFile,
        [string] $TargetFolder
    )

    $outfile = "$TargetFolder\$($SourceFile.BaseName).html"
    $recipe = (Get-Content $SourceFile -Raw) | ConvertFrom-MarkDig
    $html = $Template -replace '##Recipe##', $recipe
    Write-Host "Writing $outfile"
    $html | Out-File -FilePath $outfile
}

$targetFolder = "$PsScriptRoot\..\docs\recipes"
$template = Get-Content "$PsScriptRoot\templates\recipe.html" -Raw

Get-ChildItem -Path "$PsScriptRoot\recipes\*" -File -Include *.md | ForEach-Object {
    Build-Article -Template $template -SourceFile $_ -TargetFolder $targetFolder
}

