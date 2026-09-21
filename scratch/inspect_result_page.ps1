$text = [System.IO.File]::ReadAllText("index.html")
$idx = $text.IndexOf("function showStudentResultPage")
if ($idx -ge 0) {
    Write-Host $text.Substring($idx + 1800, 1000)
}
