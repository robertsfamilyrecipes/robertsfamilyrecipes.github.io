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