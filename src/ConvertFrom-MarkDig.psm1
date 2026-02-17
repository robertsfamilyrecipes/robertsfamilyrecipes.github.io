$ErrorActionPreference="Stop"
Set-StrictMode -Version Latest
Import-Module powershell-yaml

function ConvertFrom-MarkDig {
    [CmdletBinding()]
    [OutputType([String], [Hashtable])]
    param (
        [Parameter(ValueFromPipeline, Mandatory=$true)]
        [string] $MarkDown
    )

    # create the parse pipeline
    $pipelineBuilder = [Markdig.MarkdownPipelineBuilder]::new()
    [void][Markdig.MarkdownExtensions]::UseAdvancedExtensions($pipelineBuilder)
    [void][Markdig.MarkdownExtensions]::UseYamlFrontMatter($pipelineBuilder)
    $pipeline = $pipelineBuilder.Build()

    # parse the markdown
    $document = [Markdig.Markdown]::Parse($MarkDown, $pipeline)

    # yaml
    $yaml = [Markdig.Syntax.MarkdownObjectExtensions]::Descendants[Markdig.Extensions.Yaml.YamlFrontMatterBlock]($document) | Select-Object -First 1
    if ($null -ne $yaml) {
        Write-Output (ConvertFrom-Yaml $yaml.Lines.ToString())
    }

    # html
    Write-Output ([Markdig.Markdown]::ToHtml($document, $pipeline))
}

function Split-Document {
    [CmdletBinding()]
    [OutputType([String])]
    param (
        [Parameter(ValueFromPipeline, Mandatory=$true)]
        [string] $MarkDown
    )

    $parts = $MarkDown -split "((?smi)^#{1,6}\s+.*?$)"

    Write-Output ($parts[0])
    for($i = 1; $i -lt $parts.Length; $i+=2){
        Write-Output ($parts[$i] + $parts[$i+1])
    }
}