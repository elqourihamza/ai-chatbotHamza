# Script pour lancer le backend
# Utilisation: .\start-backend.ps1

Write-Host "🚀 Démarrage du backend FastAPI..." -ForegroundColor Cyan
Write-Host "Le backend sera accessible sur http://127.0.0.1:8000" -ForegroundColor Yellow
Write-Host ""

Set-Location "$PSScriptRoot\backend"

# Vérifier que le fichier .env existe
if (-not (Test-Path ".env")) {
    Write-Host "⚠️  ATTENTION: Le fichier .env n'existe pas!" -ForegroundColor Red
    Write-Host "Veuillez créer un fichier .env dans le dossier backend avec vos clés API." -ForegroundColor Red
    Write-Host "Voir .env.example pour un exemple." -ForegroundColor Yellow
    exit 1
}

Write-Host "✅ Fichier .env trouvé" -ForegroundColor Green
Write-Host ""

# Lancer uvicorn
uvicorn app.main:app --reload --host 127.0.0.1 --port 8000
