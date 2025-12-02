# Script de déploiement Azure Web App
# Utilisation: .\deploy-azure.ps1

param(
    [Parameter(Mandatory=$false)]
    [string]$ResourceGroup = "rg-rag-chatbot",
    
    [Parameter(Mandatory=$false)]
    [string]$Location = "eastus",
    
    [Parameter(Mandatory=$false)]
    [string]$AppServicePlan = "plan-rag-chatbot",
    
    [Parameter(Mandatory=$false)]
    [string]$BackendAppName = "rag-backend-hamza",
    
    [Parameter(Mandatory=$false)]
    [string]$FrontendAppName = "rag-frontend-hamza"
)

Write-Host "🚀 Déploiement Azure Web App - RAG Chatbot" -ForegroundColor Cyan
Write-Host ""

# Vérifier si Azure CLI est installé
try {
    $azVersion = az --version
    Write-Host "✅ Azure CLI détecté" -ForegroundColor Green
} catch {
    Write-Host "❌ Azure CLI n'est pas installé!" -ForegroundColor Red
    Write-Host "Installez-le depuis: https://docs.microsoft.com/cli/azure/install-azure-cli" -ForegroundColor Yellow
    exit 1
}

Write-Host ""
Write-Host "📋 Configuration du déploiement:" -ForegroundColor Yellow
Write-Host "   Resource Group: $ResourceGroup"
Write-Host "   Location: $Location"
Write-Host "   App Service Plan: $AppServicePlan"
Write-Host "   Backend App: $BackendAppName"
Write-Host "   Frontend App: $FrontendAppName"
Write-Host ""

# Demander confirmation
$confirm = Read-Host "Continuer avec cette configuration? (o/n)"
if ($confirm -ne "o") {
    Write-Host "Déploiement annulé." -ForegroundColor Yellow
    exit 0
}

Write-Host ""
Write-Host "📝 Étape 1: Connexion à Azure..." -ForegroundColor Cyan
az login

Write-Host ""
Write-Host "📝 Étape 2: Création du Resource Group..." -ForegroundColor Cyan
az group create --name $ResourceGroup --location $Location

Write-Host ""
Write-Host "📝 Étape 3: Création de l'App Service Plan..." -ForegroundColor Cyan
az appservice plan create `
    --name $AppServicePlan `
    --resource-group $ResourceGroup `
    --sku B1 `
    --is-linux

Write-Host ""
Write-Host "📝 Étape 4: Création de la Web App Backend..." -ForegroundColor Cyan
az webapp create `
    --resource-group $ResourceGroup `
    --plan $AppServicePlan `
    --name $BackendAppName `
    --runtime "PYTHON:3.11"

Write-Host ""
Write-Host "📝 Étape 5: Configuration des variables d'environnement Backend..." -ForegroundColor Cyan

# Lire les variables depuis le fichier .env
$envPath = "$PSScriptRoot\backend\.env"
if (Test-Path $envPath) {
    Write-Host "   Lecture du fichier .env..." -ForegroundColor Yellow
    
    $envVars = @{}
    Get-Content $envPath | ForEach-Object {
        if ($_ -match '^([^=]+)=(.*)$') {
            $key = $matches[1].Trim()
            $value = $matches[2].Trim()
            if ($key -and $value -and -not $key.StartsWith('#')) {
                $envVars[$key] = $value
            }
        }
    }
    
    # Construire la commande de configuration
    $settingsArgs = @()
    foreach ($key in $envVars.Keys) {
        $settingsArgs += "$key=$($envVars[$key])"
    }
    
    az webapp config appsettings set `
        --resource-group $ResourceGroup `
        --name $BackendAppName `
        --settings @settingsArgs `
        SCM_DO_BUILD_DURING_DEPLOYMENT="true"
    
    Write-Host "   ✅ Variables d'environnement configurées" -ForegroundColor Green
} else {
    Write-Host "   ⚠️  Fichier .env non trouvé. Configuration manuelle requise." -ForegroundColor Yellow
}

Write-Host ""
Write-Host "📝 Étape 6: Configuration du démarrage Backend..." -ForegroundColor Cyan
az webapp config set `
    --resource-group $ResourceGroup `
    --name $BackendAppName `
    --startup-file "startup.sh"

Write-Host ""
Write-Host "📝 Étape 7: Création de la Web App Frontend..." -ForegroundColor Cyan
az webapp create `
    --resource-group $ResourceGroup `
    --plan $AppServicePlan `
    --name $FrontendAppName `
    --runtime "PYTHON:3.11"

Write-Host ""
Write-Host "📝 Étape 8: Configuration Frontend..." -ForegroundColor Cyan
$backendUrl = "https://$BackendAppName.azurewebsites.net"
az webapp config appsettings set `
    --resource-group $ResourceGroup `
    --name $FrontendAppName `
    --settings API_URL="$backendUrl" `
    SCM_DO_BUILD_DURING_DEPLOYMENT="true"

az webapp config set `
    --resource-group $ResourceGroup `
    --name $FrontendAppName `
    --startup-file "startup.sh"

Write-Host ""
Write-Host "📝 Étape 9: Déploiement depuis GitHub..." -ForegroundColor Cyan
Write-Host "   Backend..." -ForegroundColor Yellow
az webapp deployment source config `
    --resource-group $ResourceGroup `
    --name $BackendAppName `
    --repo-url https://github.com/elqourihamza/ai-chatbotHamza.git `
    --branch main `
    --manual-integration

Write-Host "   Frontend..." -ForegroundColor Yellow
az webapp deployment source config `
    --resource-group $ResourceGroup `
    --name $FrontendAppName `
    --repo-url https://github.com/elqourihamza/ai-chatbotHamza.git `
    --branch main `
    --manual-integration

Write-Host ""
Write-Host "✅ Déploiement terminé!" -ForegroundColor Green
Write-Host ""
Write-Host "🌐 URLs de votre application:" -ForegroundColor Cyan
Write-Host "   Backend API:  https://$BackendAppName.azurewebsites.net" -ForegroundColor Yellow
Write-Host "   Backend Docs: https://$BackendAppName.azurewebsites.net/docs" -ForegroundColor Yellow
Write-Host "   Frontend:     https://$FrontendAppName.azurewebsites.net" -ForegroundColor Yellow
Write-Host ""
Write-Host "📊 Commandes utiles:" -ForegroundColor Cyan
Write-Host "   Logs Backend:  az webapp log tail --resource-group $ResourceGroup --name $BackendAppName"
Write-Host "   Logs Frontend: az webapp log tail --resource-group $ResourceGroup --name $FrontendAppName"
Write-Host "   Redémarrer:    az webapp restart --resource-group $ResourceGroup --name $BackendAppName"
Write-Host ""
Write-Host "⏳ Note: Le premier déploiement peut prendre 5-10 minutes." -ForegroundColor Yellow
