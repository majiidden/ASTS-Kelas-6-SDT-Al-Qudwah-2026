$text = [System.IO.File]::ReadAllText("index.html")
$idx = $text.IndexOf("function openStudentDiscussion")
if ($idx -ge 0) {
    Write-Host $text.Substring($idx, [Math]::Min(1500, $text.Length - $idx))
} else {
    Write-Host "Not found"
}
