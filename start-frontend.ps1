# Script pour lancer le frontend Streamlit
# Utilisation: .\start-frontend.ps1

Write-Host "🎨 Démarrage du frontend Streamlit..." -ForegroundColor Cyan
Write-Host "L'interface s'ouvrira automatiquement dans votre navigateur" -ForegroundColor Yellow
Write-Host ""

Set-Location "$PSScriptRoot\frontend"

# Lancer streamlit
streamlit run ui.py
