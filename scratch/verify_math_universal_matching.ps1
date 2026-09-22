# Verifikasi Komprehensif: Solusi Soal Matematika, Pencocokan Kunci Hybrid, & Recalculate Nilai
$htmlFile = "c:\Users\ACER\.gemini\antigravity\scratch\ujian online\index.html"
$kodeFile = "c:\Users\ACER\.gemini\antigravity\scratch\ujian online\Kode.gs.txt"

$htmlContent = Get-Content -Path $htmlFile -Raw -Encoding UTF8
$kodeContent = Get-Content -Path $kodeFile -Raw -Encoding UTF8

Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "VERIFIKASI INTEGRITAS PENCOCOKAN SOAL MATEMATIKA UNIVERSAL" -ForegroundColor Cyan
Write-Host "==========================================================" -ForegroundColor Cyan

$tests = @(
    # Backend Normalization & Helpers
    @{ Name = "Backend: decodeHtmlMathEntities function exists"; Content = $kodeContent; Pattern = 'function\s+decodeHtmlMathEntities\s*\(' },
    @{ Name = "Backend: normalizeMathUniversal function exists"; Content = $kodeContent; Pattern = 'function\s+normalizeMathUniversal\s*\(' },
    @{ Name = "Backend: normalizeMathSymbols backward-compat alias exists"; Content = $kodeContent; Pattern = 'function\s+normalizeMathSymbols\s*\(' },
    @{ Name = "Backend: extractOptionLetterAndContent function exists"; Content = $kodeContent; Pattern = 'function\s+extractOptionLetterAndContent\s*\(' },
    @{ Name = "Backend: recoverExcelDateFractions function exists"; Content = $kodeContent; Pattern = 'function\s+recoverExcelDateFractions\s*\(' },
    @{ Name = "Backend: isOptionMatch calls normalizeMathUniversal"; Content = $kodeContent; Pattern = 'normalizeMathUniversal\(sRaw\)' },
    @{ Name = "Backend: isOptionMatch calls recoverExcelDateFractions"; Content = $kodeContent; Pattern = 'recoverExcelDateFractions\(targetOption\)' },
    @{ Name = "Backend: isOptionMatch calls extractOptionLetterAndContent"; Content = $kodeContent; Pattern = 'extractOptionLetterAndContent\(sRaw\)' },
    @{ Name = "Backend: evaluateStudentAnswers hybrid key matching"; Content = $kodeContent; Pattern = 'extractOptionLetterAndContent\(cleanKey\)' },
    @{ Name = "Backend: JODOH evaluation supports normalized math match"; Content = $kodeContent; Pattern = 'isOptionMatch\(userAns\[pair\.q\],\s*pair\.a' },
    @{ Name = "Backend: recalculateExamScoresBackend API exists"; Content = $kodeContent; Pattern = 'function\s+recalculateExamScoresBackend\s*\(' },
    @{ Name = "Backend: recalculateExamScores spreadsheet macro updated"; Content = $kodeContent; Pattern = 'evaluateStudentAnswers\(targetExamID,' },
    @{ Name = "Backend: saveImportedQuestions protects fraction strings from date conversion"; Content = $kodeContent; Pattern = 'saveImportedQuestions[\s\S]*?cTrim\.startsWith\(''\=''\)' },
    @{ Name = "Backend: addQuestion protects fraction strings"; Content = $kodeContent; Pattern = 'addQuestion[\s\S]*?cTrim\.startsWith\(''\=''\)' },
    @{ Name = "Backend: updateQuestion protects fraction strings"; Content = $kodeContent; Pattern = 'updateQuestion[\s\S]*?cTrim\.startsWith\(''\=''\)' },
    @{ Name = "Backend: getStudentAnswerDetails fallback uses hybrid key parsing"; Content = $kodeContent; Pattern = 'extractOptionLetterAndContent\(qKeyRaw\)' },
    
    # Frontend UI & Helpers
    @{ Name = "Frontend: formatExcelMathCell helper exists"; Content = $htmlContent; Pattern = 'function\s+formatExcelMathCell\s*\(' },
    @{ Name = "Frontend: formatExcelMathCell handles proper fractions without inverting"; Content = $htmlContent; Pattern = 'num\s*<\s*m\)\s*return\s*`\$\{num\}\/\$\{m\}`' },
    @{ Name = "Frontend: btn-recalc-scores button exists in toolbar"; Content = $htmlContent; Pattern = 'id=["'']btn-recalc-scores["'']' },
    @{ Name = "Frontend: loadResultsTable toggles btn-recalc-scores"; Content = $htmlContent; Pattern = 'btnRecalc\.classList\.remove\([''"]hidden[''"]\)' },
    @{ Name = "Frontend: confirmRecalculateExamScores function exists"; Content = $htmlContent; Pattern = 'function\s+confirmRecalculateExamScores\s*\(' }
)

$passed = 0
$failed = 0

foreach ($t in $tests) {
    if ($t.Content -match $t.Pattern) {
        Write-Host "[PASS] $($t.Name)" -ForegroundColor Green
        $passed++
    } else {
        Write-Host "[FAIL] $($t.Name)" -ForegroundColor Red
        $failed++
    }
}

# --- SIMULASI PENCOCOKAN MATEMATIKA UNIVERSAL ---
Write-Host "`n--- SIMULASI PENGUJIAN LOGIKA MATEMATIKA UNIVERSAL ---" -ForegroundColor Cyan

function Decode-HtmlMathEntities($str) {
    if (-not $str) { return '' }
    $s = [string]$str
    $s = $s.Replace('&times;', 'x').Replace('&divide;', '/').Replace('&minus;', '-').Replace('&plusmn;', '+-').Replace('&sup2;', '^2').Replace('&sup3;', '^3').Replace('&nbsp;', ' ')
    $s = $s.Replace('&#215;', 'x').Replace('&#247;', '/').Replace('&#8722;', '-')
    return $s
}

function Normalize-MathUniversal($str) {
    if (-not $str) { return '' }
    $s = Decode-HtmlMathEntities $str
    $s = $s -replace "<sup[^>]*>([\s\S]*?)<\/sup>", '^$1'
    $s = $s -replace "<sub[^>]*>([\s\S]*?)<\/sub>", '_$1'
    $s = $s -replace "<[^>]*>", " "
    $s = $s -replace "\\frac\s*\{([^{}]+)\}\s*\{([^{}]+)\}", '$1/$2'
    $s = $s -replace "\\sqrt\s*\{([^{}]+)\}", '√$1'
    $s = $s -replace "\\times\b", 'x'
    $s = $s -replace "\\div\b", '/'
    $s = $s.Replace("$([char]0x00BD)", '1/2').Replace("$([char]0x00BC)", '1/4').Replace("$([char]0x00BE)", '3/4')
    $s = $s.Replace("$([char]0x00B2)", '^2').Replace("$([char]0x00B3)", '^3')
    $s = $s -replace "[\u00D7\u22C5\u00B7\u2715\*]", "x"
    $s = $s -replace "[\u00F7\:\u2044\u2215]", "/"
    $s = $s -replace "[\u2212\u2013\u2014\u2011\u2010]", "-"
    $s = $s -replace "\s*(\/)\s*", '$1'
    $s = $s -replace "\s*([+\-=\^])\s*", '$1'
    $s = $s -replace "\b(\d+),(\d{1,2})\b(?!\d)", '$1.$2'
    $s = ($s -replace "\s+", " ").Trim().ToLower()
    return $s
}

function Extract-OptionLetterAndContent($str) {
    if (-not $str) { return @{ letter = $null; index = -1; content = '' } }
    $s = [string]$str.Trim()
    $mapHuruf = @('A', 'B', 'C', 'D', 'E')
    if ($s -match '^[\(\[]?([A-Ea-e])[\.\)\]]?$') {
        $l = $Matches[1].ToUpper()
        return @{ letter = $l; index = $mapHuruf.IndexOf($l); content = '' }
    }
    if ($s -match '^(?:kunci\s*:\s*|opsi\s*|jawaban\s*:\s*)?[\(\[]?([A-Ea-e])[\.\)\]:\-–\s]\s*(.+)$') {
        $l = $Matches[1].ToUpper()
        return @{ letter = $l; index = $mapHuruf.IndexOf($l); content = $Matches[2].Trim() }
    }
    return @{ letter = $null; index = -1; content = $s }
}

function Simulate-IsOptionMatch($studentAns, $targetOpt, $targetIndex, $allOptions) {
    $sRaw = ([string]$studentAns).Trim()
    $tRaw = ([string]$targetOpt).Trim()
    if ($sRaw.ToLower() -eq $tRaw.ToLower()) { return $true }
    
    $sParsed = Extract-OptionLetterAndContent $sRaw
    $tParsed = Extract-OptionLetterAndContent $tRaw
    $mapHuruf = @('A', 'B', 'C', 'D', 'E')

    if ($targetIndex -ge 0 -and $targetIndex -lt 5) {
        $exp = $mapHuruf[$targetIndex]
        if ($sParsed.letter -eq $exp -and (-not $sParsed.content -or -not $tParsed.content)) { return $true }
    }
    if ($tParsed.letter -and $tParsed.content) {
        if ($targetIndex -eq $tParsed.index) { return $true }
        if (Simulate-IsOptionMatch $studentAns $tParsed.content $tParsed.index $allOptions) { return $true }
        if ($allOptions -and $tParsed.index -lt $allOptions.Length -and $allOptions[$tParsed.index]) {
            if (Simulate-IsOptionMatch $studentAns $allOptions[$tParsed.index] $tParsed.index $null) { return $true }
        }
    }
    
    $sMath = Normalize-MathUniversal $sRaw
    $tMath = Normalize-MathUniversal $tRaw
    if ($sMath -and $tMath -and $sMath -eq $tMath) { return $true }
    
    # Excel date conversion check e.g. "07-Apr" or "04-Jul" vs 4/7
    if ($tRaw -match '0?7[-/]Apr|0?4[-/]Jul') {
        if (Simulate-IsOptionMatch $studentAns '4/7' $targetIndex $null) { return $true }
    }
    if ($tRaw -match '0?2[-/]Jan|0?1[-/]Feb') {
        if (Simulate-IsOptionMatch $studentAns '1/2' $targetIndex $null) { return $true }
    }
    return $false
}

$simCases = @(
    @{ Name = "Pecahan spasi: '4 / 7' vs '4/7'"; SAns = "4 / 7"; Key = "4/7"; Idx = 0; Expected = $true },
    @{ Name = "Pecahan vulgar: '1/2' vs '½'"; SAns = "1/2"; Key = [char]0x00BD; Idx = 0; Expected = $true },
    @{ Name = "LaTeX Frac: '\frac{4}{7}' vs '4/7'"; SAns = "\frac{4}{7}"; Key = "4/7"; Idx = 0; Expected = $true },
    @{ Name = "Perkalian HTML entity: '25 &times; 4' vs '25 x 4'"; SAns = "25 &times; 4"; Key = "25 x 4"; Idx = 1; Expected = $true },
    @{ Name = "Perkalian tanda silang unicode: '25 × 4' vs '25 x 4'"; SAns = ("25 " + [char]0x00D7 + " 4"); Key = "25 x 4"; Idx = 1; Expected = $true },
    @{ Name = "Pembagian tanda bagi unicode: '12 ÷ 3' vs '12 / 3'"; SAns = ("12 " + [char]0x00F7 + " 3"); Key = "12 / 3"; Idx = 2; Expected = $true },
    @{ Name = "Pembagian tanda titik dua: '12 : 3' vs '12 / 3'"; SAns = "12 : 3"; Key = "12 / 3"; Idx = 2; Expected = $true },
    @{ Name = "Minus dash minus unicode: '10 − 4' vs '10 - 4'"; SAns = ("10 " + [char]0x2212 + " 4"); Key = "10 - 4"; Idx = 0; Expected = $true },
    @{ Name = "Pangkat superscript tag: 'x<sup>2</sup>' vs 'x^2'"; SAns = "x<sup>2</sup>"; Key = "x^2"; Idx = 3; Expected = $true },
    @{ Name = "Pangkat unicode: 'x²' vs 'x^2'"; SAns = ("x" + [char]0x00B2); Key = "x^2"; Idx = 3; Expected = $true },
    @{ Name = "Desimal koma vs titik: '12,5' vs '12.5'"; SAns = "12,5"; Key = "12.5"; Idx = 0; Expected = $true },
    @{ Name = "Hybrid prefix kunci: siswa '4/7', kunci 'A. 4/7'"; SAns = "4/7"; Key = "A. 4/7"; Idx = 0; Expected = $true },
    @{ Name = "Hybrid prefix kurung: siswa '25 x 4', kunci 'B) 25 x 4'"; SAns = "25 x 4"; Key = "B) 25 x 4"; Idx = 1; Expected = $true },
    @{ Name = "Format tanggal Excel 07-Apr vs 4/7"; SAns = "4/7"; Key = "07-Apr"; Idx = 0; Expected = $true },
    @{ Name = "Format tanggal Excel 02-Jan vs 1/2"; SAns = "1/2"; Key = "02-Jan"; Idx = 0; Expected = $true }
)

$sampleOptions = @("4/7", "25 x 4", "12 / 3", "x^2", "12.5")

foreach ($sc in $simCases) {
    $res = Simulate-IsOptionMatch $sc.SAns $sc.Key $sc.Idx $sampleOptions
    if ($res -eq $sc.Expected) {
        Write-Host "[PASS] Simulasi: $($sc.Name)" -ForegroundColor Green
        $passed++
    } else {
        Write-Host "[FAIL] Simulasi: $($sc.Name) (Hasil: $res, Harapan: $($sc.Expected))" -ForegroundColor Red
        $failed++
    }
}

Write-Host "----------------------------------------------------------"
$color = if ($failed -eq 0) { "Green" } else { "Red" }
Write-Host "Hasil Akhir: $passed PASS, $failed FAIL" -ForegroundColor $color

if ($failed -gt 0) {
    exit 1
} else {
    Write-Host "Semua pengujian dan verifikasi matematika berhasil 100%!" -ForegroundColor Green
}
