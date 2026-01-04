ToDo List
=========

[Done] Get connected to github  
[Done] Work out what going on with github pages  
[Done] Write a recipe in markdown  
[Done] Convert markdown to html  
* https://powershellisfun.com/2024/08/23/display-markdown-files-in-powershell/
* https://github.com/gravejester/ConvertFrom-MarkDown
* https://github.com/xoofx/markdig/tree/master
* https://johnh.co/blog/a-crash-course-in-markdig
* https://github.com/cloudbase/powershell-yaml
[Done] Make Index page update
* [Done] Last updated datetime on index.html
[Done] Make recipe page template
* [Done] Simplify Markdig Call
* [Done] Set title
* [ToDo] Index page html
* [ToDo] Fill in other metadata

[ToDo] What about line ending settings  
[Done] What about editor config settings  


```
    # attempt to use the markdig ast parser...it's pretty difficult from powershell
    # create the pipeline 
    $pipelineBuilder = [MarkDig.MarkdownPipelineBuilder]::new()
    [void][MarkDig.MarkdownExtensions]::UseAdvancedExtensions($pipelineBuilder)
    $pipeline = $pipelineBuilder.Build()

    # Parse the markdown
    $document = [MarkDig.Markdown]::Parse($MarkDown, $pipeline)
    $h2s = [MarkDig.Syntax.MarkdownObjectExtensions]::Descendants[Markdig.Syntax.HeadingBlock]($document) | Where-Object { $_.Level -eq 2 }
    Write-Host $h2s.Inline[0]

    $outHtml = [MarkDig.Markdown]::ToHtml($document, $pipeline)
```    
