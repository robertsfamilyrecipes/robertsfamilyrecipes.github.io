Import-Module Pester -PassThru
Import-Module "$PsScriptRoot\..\src\ConvertFrom-MarkDig.psm1" -Force

Describe 'ConvertFrom-MarkDig tests' {
    BeforeEach {
    }
    Context 'happy path' {
        It 'Given a bit of mark down, it is converted to html' {
            Mock Write-Warning { } -ModuleName ConvertFrom-MarkDig
            $markdown = @"
# Heading 1
"@
            $html, $metadata = ConvertFrom-MarkDig -MarkDown $markdown

            $html | Should -Be "<h1 id=""heading-1"">Heading 1</h1>`n"
        }

        It 'Given definition list markdown, a definition list is created' {
            Mock Write-Warning { } -ModuleName ConvertFrom-MarkDig
            $markdown = @"
1 tsp
:   table salt
"@
            $html, $metadata = ConvertFrom-MarkDig -MarkDown $markdown

            $html | Should -Be "<dl>`n<dt>1 tsp</dt>`n<dd>table salt</dd>`n</dl>`n"            
        }
    }

    Context 'yaml data' {
        It 'The yaml front matter should be returned as an object' {
            $markdown = @"
---
title: BBQ Chicken wings
serves: 4
---
"@
            $html, $metadata = ConvertFrom-MarkDig -MarkDown $markdown
            
            $metadata.title | Should -Be "BBQ Chicken wings"
            $metadata.serves | Should -Be "4"
        }
    }
}