$ErrorActionPreference="Stop"
Set-StrictMode -Version Latest

$template = Get-Content "$PsScriptRoot\templates\index.html" -Raw

$template = $template -replace '##LastUpdated##', (Get-Date -Format 'u')

$contents = Get-ChildItem -Path "$PsScriptRoot\..\docs\recipes" | ForEach-Object {
    "    <li><a href='./recipes/$($_.Name)'>$($_.BaseName)</a></li>`n"
}
$template = $template -replace '##Contents##', $contents

$template | Out-File -FilePath "$PsScriptRoot\..\docs\index.html"