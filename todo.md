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
[Done] Make an editor config  
[Done] Make recipe page template
* [Done] Simplify Markdig Call
* [Done] Set title
* [Done] Index page html
* [Done] Fill in other metadata
[Done] Change to use 1/2, 1/4 etc.
[Done] Basic css on the site 
[Done] Add instal to precommit, and make install idempotent
[Done] Navbar
[Done] Print layout
[Done] Style index page better 
* last updated small and at bottom and better date
* get rid of bullet points

[ToDo] Show cook time and serves
[ToDo] Print layout
* make more compact
* Url in the footer for print layout
[ToDo] What about line ending settings  
[ToDO] canonical link <link rel="canonical" href="https://robertsfamilyrecipes.com">
[ToDo] favicon  <link rel="icon" type="image/png" href="favicon.png">
[ToDo] set a max width on the page which will work well with an image size  

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
