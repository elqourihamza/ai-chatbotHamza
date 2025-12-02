# Azure Web App Deployment Guide

## 🚀 Déploiement sur Azure Web App

### Architecture de déploiement

Pour déployer cette application sur Azure, vous avez **deux options** :

#### Option 1 : Application Monolithique (Recommandé pour débuter)
Déployer le backend et utiliser Streamlit comme frontend dans la même Web App.

#### Option 2 : Architecture Séparée
- Backend : Azure Web App (FastAPI)
- Frontend : Azure Web App séparée (Streamlit) ou Azure Static Web Apps

---

## 📋 Prérequis

- [x] Compte Azure actif
- [x] Azure CLI installé : https://docs.microsoft.com/cli/azure/install-azure-cli
- [x] Variables d'environnement configurées localement
- [x] Repository Git accessible

---

## 🛠️ Option 1 : Déploiement Monolithique

### Étape 1 : Connexion à Azure

```powershell
# Se connecter à Azure
az login

# Vérifier votre abonnement
az account show

# (Optionnel) Changer d'abonnement si nécessaire
az account set --subscription "YOUR_SUBSCRIPTION_ID"
```

### Étape 2 : Créer un Resource Group

```powershell
az group create --name rg-rag-chatbot --location eastus
```

### Étape 3 : Créer un App Service Plan

```powershell
# Plan Basic B1 (économique)
az appservice plan create `
  --name plan-rag-chatbot `
  --resource-group rg-rag-chatbot `
  --sku B1 `
  --is-linux
```

### Étape 4 : Créer la Web App

```powershell
az webapp create `
  --resource-group rg-rag-chatbot `
  --plan plan-rag-chatbot `
  --name rag-chatbot-hamza `
  --runtime "PYTHON:3.11"
```

### Étape 5 : Configurer les Variables d'Environnement

**⚠️ IMPORTANT** : Remplacez les valeurs par VOS clés API réelles !

```powershell
az webapp config appsettings set `
  --resource-group rg-rag-chatbot `
  --name rag-chatbot-hamza `
  --settings `
    AZURE_OPENAI_API_KEY="VOTRE_CLE_AZURE_OPENAI" `
    AZURE_OPENAI_ENDPOINT="https://votre-endpoint.openai.azure.com/" `
    AZURE_OPENAI_API_VERSION="2024-12-01-preview" `
    AZURE_CHAT_DEPLOYMENT="o4-mini" `
    AZURE_EMBEDDING_DEPLOYMENT="text-embedding-ada-002" `
    PINECONE_API_KEY="VOTRE_CLE_PINECONE" `
    PINECONE_CLOUD="aws" `
    PINECONE_ENV="us-east-1" `
    PINECONE_INDEX_NAME="rag-workshop-azure" `
    PINECONE_NAMESPACE="" `
    PINECONE_DIMENSION="1536" `
    SCM_DO_BUILD_DURING_DEPLOYMENT="true"
```

**Ou utilisez le script automatique** qui lit depuis votre fichier `.env` local :
```powershell
.\deploy-simple.ps1
```

### Étape 6 : Déployer depuis Git

```powershell
az webapp deployment source config `
  --resource-group rg-rag-chatbot `
  --name rag-chatbot-hamza `
  --repo-url https://github.com/elqourihamza/ai-chatbotHamza.git `
  --branch main `
  --manual-integration
```

---

## 🔧 Option 2 : Backend et Frontend Séparés

### Backend Web App

```powershell
# Créer la Web App pour le backend
az webapp create `
  --resource-group rg-rag-chatbot `
  --plan plan-rag-chatbot `
  --name rag-backend-hamza `
  --runtime "PYTHON:3.11"

# Configurer les variables d'environnement (comme ci-dessus)
az webapp config appsettings set `
  --resource-group rg-rag-chatbot `
  --name rag-backend-hamza `
  --settings [SAME_AS_ABOVE]

# Déployer
az webapp deployment source config `
  --resource-group rg-rag-chatbot `
  --name rag-backend-hamza `
  --repo-url https://github.com/elqourihamza/ai-chatbotHamza.git `
  --branch main `
  --manual-integration
```

### Frontend Web App

```powershell
# Créer la Web App pour le frontend
az webapp create `
  --resource-group rg-rag-chatbot `
  --plan plan-rag-chatbot `
  --name rag-frontend-hamza `
  --runtime "PYTHON:3.11"

# Configurer l'URL du backend
az webapp config appsettings set `
  --resource-group rg-rag-chatbot `
  --name rag-frontend-hamza `
  --settings API_URL="https://rag-backend-hamza.azurewebsites.net"
```

---

## 📦 Fichiers Requis pour le Déploiement

Votre repository a besoin des fichiers suivants (je vais les créer) :

### Pour le Backend

1. **`backend/startup.sh`** - Script de démarrage
2. **`backend/.deployment`** - Configuration de déploiement
3. **`requirements.txt`** à la racine (si déploiement monolithique)

### Pour le Frontend

1. **`frontend/startup.sh`** - Script Streamlit
2. **Configuration CORS** dans le backend

---

## 🔍 Vérification du Déploiement

```powershell
# Voir les logs de déploiement
az webapp log tail --resource-group rg-rag-chatbot --name rag-chatbot-hamza

# Obtenir l'URL de l'application
az webapp show --resource-group rg-rag-chatbot --name rag-chatbot-hamza --query defaultHostName -o tsv
```

---

## 💰 Estimation des Coûts

- **App Service Plan B1** : ~13$/mois
- **Ressources Azure existantes** : Déjà payées (Azure OpenAI)
- **Pinecone** : Plan gratuit ou payant selon usage

---

## ⚡ Optimisations

### Activer le scaling automatique

```powershell
az monitor autoscale create `
  --resource-group rg-rag-chatbot `
  --resource rag-chatbot-hamza `
  --resource-type Microsoft.Web/sites `
  --name autoscale-rag `
  --min-count 1 `
  --max-count 3 `
  --count 1
```

### Activer HTTPS uniquement

```powershell
az webapp update `
  --resource-group rg-rag-chatbot `
  --name rag-chatbot-hamza `
  --https-only true
```

---

## 🐛 Troubleshooting

### Voir les logs en temps réel

```powershell
az webapp log tail --resource-group rg-rag-chatbot --name rag-chatbot-hamza
```

### Redémarrer l'application

```powershell
az webapp restart --resource-group rg-rag-chatbot --name rag-chatbot-hamza
```

### Vérifier la configuration

```powershell
az webapp config appsettings list `
  --resource-group rg-rag-chatbot `
  --name rag-chatbot-hamza
```

---

## 🎯 Prochaines Étapes

1. Je vais créer les fichiers de configuration nécessaires
2. Vous exécuterez les commandes Azure CLI
3. Votre application sera en ligne !

**Voulez-vous que je crée les fichiers de configuration maintenant ?**
