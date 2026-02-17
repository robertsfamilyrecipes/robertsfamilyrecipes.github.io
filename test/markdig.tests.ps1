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
            $html = ConvertFrom-MarkDig -MarkDown $markdown

            $html | Should -Be "<h1 id=""heading-1"">Heading 1</h1>`n"
        }

        It 'Given definition list markdown, a definition list is created' {
            Mock Write-Warning { } -ModuleName ConvertFrom-MarkDig
            $markdown = @"
1 tsp
:   table salt
"@
            $html = ConvertFrom-MarkDig -MarkDown $markdown

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
            $metadata, $html = ConvertFrom-MarkDig -MarkDown $markdown
            
            $metadata.title | Should -Be "BBQ Chicken wings"
            $metadata.serves | Should -Be "4"
        }
    }
}

Describe 'Split-Document tests' {
    Context 'happy path' {
        It 'Just an intro' {
            $markdown = @"
intro
more intro
"@
            $intro, $section1, $section2 = Split-Document -MarkDown $markdown
            $intro | Should -Be "intro`r`nmore intro"
            $section1 | Should -Be $null
            $section2 | Should -Be $null
        }

        It 'One section' {
            $markdown = @"
intro

# section 1 heading

section 1 body
"@
            $intro, $section1, $section2 = Split-Document -MarkDown $markdown
            $intro | Should -Be "intro`r`n`r`n"
            $section1 | Should -Be "# section 1 heading`r`n`r`nsection 1 body"
            $section2 | Should -Be $null
        }

                It 'One section' {
            $markdown = @"
intro

# section 1 heading

section 1 body

# section 2 heading

section 2 body
"@
            $intro, $section1, $section2 = Split-Document -MarkDown $markdown
            $intro | Should -Be "intro`r`n`r`n"
            $section1 | Should -Be "# section 1 heading`r`n`r`nsection 1 body`r`n`r`n"
            $section2 | Should -Be "# section 2 heading`r`n`r`nsection 2 body"
        }
    }
}