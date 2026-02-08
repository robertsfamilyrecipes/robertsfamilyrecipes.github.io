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
[Done] Want the print layout to be white background
[Done] add created and update dates to the recipes
[InProgress] Show cook time and serves
[ToDo] Change ingredients to a straight list



[ToDo] CSS variables. https://www.w3schools.com/css/css3_variables.asp
[ToDo] Look at bootstrap reset and apply
* Set a max page width (768?)
* Screen res
* iPad: 768 x 1024
* Phone: 320 x 693
* Used clamp on the heading sizes (maybe on h1 needed)
* Line height on heading (see reb casserole)
* Default font size is 16px allegedly. Font size 12 for print?
* Like the alert style font colouring in bootstrap
  * See here for definition of the background colours
  * https://github.com/twbs/bootstrap/blob/main/scss/_variables.scss
  * This file has the definition of colour shade
  * https://github.com/twbs/bootstrap/blob/main/scss/_functions.scss
  * This bit of code should do colour mixing in pure css
.button {
  background-color: color-mix(in srgb, red 50%, blue);
}
[ToDo] Limit image size on larger screens
[ToDo] What about line ending settings  
[ToDO] canonical link <link rel="canonical" href="https://robertsfamilyrecipes.com">
[ToDo] favicon  <link rel="icon" type="image/png" href="favicon.png">
[ToDo] Print layout two column

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
