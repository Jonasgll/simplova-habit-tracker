# ============================================================
# Obsidian Import Script — Claude Code Session
# ============================================================

# --- SSL FIX für Windows PowerShell 5.1 ---
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
[System.Net.ServicePointManager]::ServerCertificateValidationCallback = { $true }

# --- KONFIGURATION ---
$ApiKey    = Read-Host "Obsidian API Key eingeben"
$VaultPath = "Claude Sessions"
$FileName  = "2026-04-17 Habit Tracker Session.md"
$ApiBase   = "https://localhost:27123"

# --- MARKDOWN DATEI LESEN ---
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$MdFile    = Join-Path $ScriptDir "session-notes.md"

if (-not (Test-Path $MdFile)) {
    Write-Host "FEHLER: session-notes.md nicht gefunden in $ScriptDir" -ForegroundColor Red
    exit 1
}

$Content = Get-Content $MdFile -Raw -Encoding UTF8
$Bytes   = [System.Text.Encoding]::UTF8.GetBytes($Content)

# --- IN OBSIDIAN IMPORTIEREN ---
$NotePath = "$VaultPath/$FileName"
$Url      = "$ApiBase/vault/$([Uri]::EscapeDataString($NotePath))"

Write-Host ""
Write-Host "Importiere nach Obsidian..." -ForegroundColor Cyan
Write-Host "Ziel: $NotePath"

try {
    $Request                = [System.Net.WebRequest]::Create($Url)
    $Request.Method         = "PUT"
    $Request.ContentType    = "text/markdown"
    $Request.Headers["Authorization"] = "Bearer $ApiKey"
    $Request.ContentLength  = $Bytes.Length

    $Stream = $Request.GetRequestStream()
    $Stream.Write($Bytes, 0, $Bytes.Length)
    $Stream.Close()

    $Response = $Request.GetResponse()
    $Response.Close()

    Write-Host ""
    Write-Host "Erfolgreich importiert!" -ForegroundColor Green
    Write-Host "Note: $NotePath" -ForegroundColor Green
}
catch {
    Write-Host ""
    Write-Host "FEHLER: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host ""
    Write-Host "Checke:" -ForegroundColor Yellow
    Write-Host "  1. Ist Obsidian offen?"
    Write-Host "  2. Ist das Local REST API Plugin aktiv?"
    Write-Host "  3. Ist der API Key korrekt?"
    Write-Host "  4. Port 27123 erreichbar? → https://localhost:27123"
}

Write-Host ""
Read-Host "Enter druecken zum Beenden"
