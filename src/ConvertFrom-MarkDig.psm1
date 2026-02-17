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
    if ($null -eq $yaml) {
        Write-Warning "missing front matter"
        $metadata = @{}
    } else {
        $metadata = ConvertFrom-Yaml $yaml.Lines.ToString()
    }

    # html
    $outHtml = [Markdig.Markdown]::ToHtml($document, $pipeline)

    Write-Output $outHtml, $metadata
}

function Split-Document {
    [CmdletBinding()]
    [OutputType([String])]
    param (
        [Parameter(ValueFromPipeline, Mandatory=$true)]
        [string] $MarkDown
    )

    $parts = $MarkDown -split "((?smi)^#{1,6}\s+.*?$)"

    # return this
    $parts[0]
    for($i = 1; $i -lt $parts.Length; $i+=2){
        # return this
        $parts[$i] + $parts[$i+1]
    }
}