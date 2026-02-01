$ErrorActionPreference="Stop"
Set-StrictMode -Version Latest

$template = Get-Content "$PsScriptRoot\templates\index.html" -Raw

$template = $template -replace '##LastUpdated##', (Get-Date -Format 'yyyy-MM-dd HH:mm')

$contents = Get-ChildItem -Path "$PsScriptRoot\..\docs\recipes" | ForEach-Object {
    $title = (Get-Content $_ | Select-String -Pattern '<title>(.*)</title>').Matches[0].Groups[1].Value
    "`n      <li><a href='./recipes/$($_.Name)'>$title</a></li>"
}
$template = $template -replace '##Contents##', $contents

$template | Out-File -FilePath "$PsScriptRoot\..\docs\index.html"