# Script de déploiement simple - Une seule Web App
# Utilisation: .\deploy-simple.ps1

param(
    [Parameter(Mandatory=$false)]
    [string]$AppName = "rag-chatbot-hamza"
)

Write-Host "🚀 Déploiement Simple Azure Web App" -ForegroundColor Cyan
Write-Host ""

$ResourceGroup = "rg-rag-chatbot"
$Location = "eastus"
$AppServicePlan = "plan-rag-chatbot"

Write-Host "📋 Configuration:" -ForegroundColor Yellow
Write-Host "   App Name: $AppName"
Write-Host "   Resource Group: $ResourceGroup"
Write-Host "   Location: $Location"
Write-Host ""

# Étape 1: Login
Write-Host "📝 Connexion à Azure..." -ForegroundColor Cyan
az login

# Étape 2: Resource Group
Write-Host "📝 Création du Resource Group..." -ForegroundColor Cyan
az group create --name $ResourceGroup --location $Location

# Étape 3: App Service Plan
Write-Host "📝 Création de l'App Service Plan (B1)..." -ForegroundColor Cyan
az appservice plan create `
    --name $AppServicePlan `
    --resource-group $ResourceGroup `
    --sku B1 `
    --is-linux

# Étape 4: Web App
Write-Host "📝 Création de la Web App..." -ForegroundColor Cyan
az webapp create `
    --resource-group $ResourceGroup `
    --plan $AppServicePlan `
    --name $AppName `
    --runtime "PYTHON:3.11"

# Étape 5: Variables d'environnement
Write-Host "📝 Configuration des variables d'environnement..." -ForegroundColor Cyan

# Lire depuis le fichier .env local
$envPath = "$PSScriptRoot\backend\.env"
if (-not (Test-Path $envPath)) {
    Write-Host "❌ Fichier .env non trouvé dans backend/" -ForegroundColor Red
    Write-Host "Créez d'abord backend/.env avec vos clés API" -ForegroundColor Yellow
    exit 1
}

$envContent = Get-Content $envPath
$settings = @()
foreach ($line in $envContent) {
    if ($line -match '^([^=]+)=(.*)$' -and -not $line.StartsWith('#')) {
        $key = $matches[1].Trim()
        $value = $matches[2].Trim()
        if ($key -and $value) {
            $settings += "$key=$value"
        }
    }
}

$settings += "SCM_DO_BUILD_DURING_DEPLOYMENT=true"
$settings += "WEBSITE_HTTPLOGGING_RETENTION_DAYS=3"

az webapp config appsettings set `
    --resource-group $ResourceGroup `
    --name $AppName `
    --settings @settings

# Étape 6: Configuration du startup
Write-Host "📝 Configuration du script de démarrage..." -ForegroundColor Cyan
az webapp config set `
    --resource-group $ResourceGroup `
    --name $AppName `
    --startup-file "backend/startup.sh"

# Étape 7: Activer HTTPS
Write-Host "📝 Activation HTTPS..." -ForegroundColor Cyan
az webapp update `
    --resource-group $ResourceGroup `
    --name $AppName `
    --https-only true

# Étape 8: Déploiement depuis GitHub
Write-Host "📝 Configuration du déploiement GitHub..." -ForegroundColor Cyan
az webapp deployment source config `
    --resource-group $ResourceGroup `
    --name $AppName `
    --repo-url https://github.com/elqourihamza/ai-chatbotHamza.git `
    --branch main `
    --manual-integration

Write-Host ""
Write-Host "✅ Déploiement terminé!" -ForegroundColor Green
Write-Host ""
Write-Host "🌐 Votre application:" -ForegroundColor Cyan
Write-Host "   URL:  https://$AppName.azurewebsites.net" -ForegroundColor Yellow
Write-Host "   Docs: https://$AppName.azurewebsites.net/docs" -ForegroundColor Yellow
Write-Host ""
Write-Host "📊 Commandes utiles:" -ForegroundColor Cyan
Write-Host "   Voir les logs:  az webapp log tail --resource-group $ResourceGroup --name $AppName"
Write-Host "   Redémarrer:     az webapp restart --resource-group $ResourceGroup --name $AppName"
Write-Host "   Stream logs:    az webapp log config --resource-group $ResourceGroup --name $AppName --web-server-logging filesystem"
Write-Host ""
Write-Host "⏳ Le déploiement prend 5-10 minutes. Surveillez les logs!" -ForegroundColor Yellow
