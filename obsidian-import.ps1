# ============================================================
# Obsidian Import Script — Claude Code Session
# ============================================================
# Voraussetzung: Obsidian Local REST API Plugin aktiviert
# Plugin: https://github.com/coddingtonbear/obsidian-local-rest-api
#
# Anleitung:
# 1. API Key kopieren: Obsidian → Einstellungen → Local REST API → API Key
# 2. Dieses Script in PowerShell ausführen:
#    .\obsidian-import.ps1
# ============================================================

# --- KONFIGURATION ---
$ApiKey    = Read-Host "Obsidian API Key eingeben"
$VaultPath = "Claude Sessions"          # Ordner in deinem Vault
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

# --- IN OBSIDIAN IMPORTIEREN ---
$Headers = @{
    "Authorization" = "Bearer $ApiKey"
    "Content-Type"  = "text/markdown"
}

$NotePath = "$VaultPath/$FileName"
$Url      = "$ApiBase/vault/$([Uri]::EscapeDataString($NotePath))"

Write-Host ""
Write-Host "Importiere nach Obsidian..." -ForegroundColor Cyan
Write-Host "Ziel: $NotePath"

try {
    # SSL-Zertifikat ignorieren (selbstsigniert vom Plugin)
    add-type @"
        using System.Net;
        using System.Security.Cryptography.X509Certificates;
        public class TrustAll : ICertificatePolicy {
            public bool CheckValidationResult(ServicePoint sp, X509Certificate cert,
                WebRequest req, int problem) { return true; }
        }
"@
    [System.Net.ServicePointManager]::CertificatePolicy = New-Object TrustAll

    $Response = Invoke-RestMethod `
        -Uri $Url `
        -Method Put `
        -Headers $Headers `
        -Body ([System.Text.Encoding]::UTF8.GetBytes($Content)) `
        -ErrorAction Stop

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
