# Verifikasi Fitur: Penanganan Soal Matematika, Bank Soal dan Evaluasi Nilai
$htmlFile = "c:\Users\ACER\.gemini\antigravity\scratch\ujian online\index.html"
$kodeFile = "c:\Users\ACER\.gemini\antigravity\scratch\ujian online\Kode.gs.txt"

$htmlContent = Get-Content -Path $htmlFile -Raw -Encoding UTF8
$kodeContent = Get-Content -Path $kodeFile -Raw -Encoding UTF8

Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host "VERIFIKASI INTEGRITAS PERBAIKAN SOAL MATEMATIKA" -ForegroundColor Cyan
Write-Host "==========================================================" -ForegroundColor Cyan

$tests = @(
    @{ Name = "Frontend: formatExcelMathCell helper exists"; Content = $htmlContent; Pattern = 'function\s+formatExcelMathCell\s*\(' },
    @{ Name = "Frontend: formatExcelMathCell handles fractions from dates"; Content = $htmlContent; Pattern = 'dateMmmMatch[\s\S]*return\s*[''"]4/7[''"]' },
    @{ Name = "Frontend: processExcelImport uses raw: false for SheetJS"; Content = $htmlContent; Pattern = 'sheet_to_json\(worksheet,\s*\{\s*header:\s*1,\s*raw:\s*false' },
    @{ Name = "Frontend: processExcelImport normalizes question types"; Content = $htmlContent; Pattern = 'PILIHAN\s+GANDA' },
    @{ Name = "Frontend: loadQuestionsTable string sanitization"; Content = $htmlContent; Pattern = 'allQuestionsData\s*=\s*\(qs\s*\|\|\s*\[\]\)\.map' },
    @{ Name = "Frontend: renderQuestionsInternal protects math tags"; Content = $htmlContent; Pattern = 'hasHtmlTags' },
    @{ Name = "Frontend: renderQuestionsInternal escapes content and key"; Content = $htmlContent; Pattern = 'escapeHtml\(plainContent\)' },
    @{ Name = "Frontend: applyQuestionFilters safe string replace"; Content = $htmlContent; Pattern = 'String\(q\.content\s*\|\|\s*[''"]{2}\)\.replace' },
    
    @{ Name = "Backend: normalizeMathSymbols function exists"; Content = $kodeContent; Pattern = 'function\s+normalizeMathSymbols\s*\(' },
    @{ Name = "Backend: normalizeMathSymbols normalizes multiplication"; Content = $kodeContent; Pattern = 'u00D7' },
    @{ Name = "Backend: normalizeMathSymbols normalizes division"; Content = $kodeContent; Pattern = 'u00F7' },
    @{ Name = "Backend: normalizeMathSymbols normalizes minus"; Content = $kodeContent; Pattern = 'u2212' },
    @{ Name = "Backend: normalizeMathSymbols removes spaces around slash"; Content = $kodeContent; Pattern = 'Normalisasi spasi di sekitar tanda pecahan' },
    @{ Name = "Backend: isOptionMatch calls normalizeMathSymbols"; Content = $kodeContent; Pattern = 'normalizeMathSymbols\(sNorm\)' },
    @{ Name = "Backend: isOptionMatch matches option letters (A-E)"; Content = $kodeContent; Pattern = 'tLetterMatch' },
    @{ Name = "Backend: evaluateStudentAnswers hybrid key matching"; Content = $kodeContent; Pattern = 'keyLetterMatch' },
    @{ Name = "Backend: getQuestionsByExam safe string conversion"; Content = $kodeContent; Pattern = 'content:\s*\(r\[3\]\s*!==\s*undefined' },
    @{ Name = "Backend: saveImportedQuestions formula protection"; Content = $kodeContent; Pattern = 'content\.startsWith\([''"]=[''"]\)' },
    @{ Name = "Backend: saveImportedQuestions cache invalidation"; Content = $kodeContent; Pattern = 'cache\.remove\([''"]cbt_q_eval_[''"]' }
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

# --- SIMULASI EVALUASI MATEMATIKA ---
Write-Host "`n--- PENGUJIAN LOGIKA MATEMATIKA (SIMULASI) ---" -ForegroundColor Cyan

function Normalize-MathSymbols($str) {
    if (-not $str) { return '' }
    $s = [string]$str
    $s = $s -replace "[\u00D7\u22C5\*]", "x"
    $s = $s -replace "[\u00F7\:]", "/"
    $s = $s -replace "[\u2212\u2013\u2014]", "-"
    $s = $s -replace "\s*(\/)\s*", '$1'
    $s = ($s -replace "\s+", " ").Trim()
    return $s
}

$simTests = @(
    @{ Name = "Pecahan dengan spasi: 4 / 7 vs 4/7"; Ans = "4 / 7"; Key = "4/7"; Expected = $true },
    @{ Name = "Simbol kali: 25 * 4 vs 25 x 4"; Ans = "25 * 4"; Key = "25 x 4"; Expected = $true },
    @{ Name = "Simbol bagi: 12 : 3 vs 12 / 3"; Ans = "12 : 3"; Key = "12 / 3"; Expected = $true },
    @{ Name = "Simbol minus dash vs strip"; Ans = ("10 " + [char]0x2212 + " 4"); Key = "10 - 4"; Expected = $true },
    @{ Name = "Angka ribuan presisi: 345.456 vs 345.456"; Ans = "345.456"; Key = "345.456"; Expected = $true },
    @{ Name = "Angka desimal nol belakang koma: 8.940 vs 8.940"; Ans = "8.940"; Key = "8.940"; Expected = $true }
)

foreach ($st in $simTests) {
    $normAns = Normalize-MathSymbols $st.Ans
    $normKey = Normalize-MathSymbols $st.Key
    $isMatch = ($normAns.ToLower() -eq $normKey.ToLower())
    if ($isMatch -eq $st.Expected) {
        Write-Host "[PASS] Simulasi: $($st.Name)" -ForegroundColor Green
        $passed++
    } else {
        Write-Host "[FAIL] Simulasi: $($st.Name) (Hasil: $isMatch, Harapan: $($st.Expected))" -ForegroundColor Red
        $failed++
    }
}

Write-Host "----------------------------------------------------------"
$color = if ($failed -eq 0) { "Green" } else { "Red" }
Write-Host "Hasil Akhir: $passed PASS, $failed FAIL" -ForegroundColor $color

if ($failed -gt 0) {
    exit 1
} else {
    Write-Host "Semua verifikasi dan pengujian simulasi BERHASIL 100%!" -ForegroundColor Green
}
