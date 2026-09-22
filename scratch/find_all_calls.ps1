$lines = Get-Content 'index.html'
for ($i = 14800; $i -lt 15000; $i++) {
    if ($lines[$i] -match 'google\.script\.run') {
        for ($j = $i; $j -lt $i + 60; $j++) {
            Write-Host "$($j+1): $($lines[$j])"
        }
    }
}
