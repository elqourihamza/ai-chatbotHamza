# 🚀 Guide de Déploiement Rapide - Azure Web App

## Choix de déploiement

### Option 1 : Script Automatique (Recommandé) ⚡

Déploiement simple en une commande :

```powershell
.\deploy-simple.ps1
```

Ce script va :
- ✅ Créer tous les ressources Azure nécessaires
- ✅ Configurer automatiquement vos clés depuis `backend/.env`
- ✅ Déployer l'application depuis GitHub
- ✅ Activer HTTPS

**Temps estimé** : 10-15 minutes

### Option 2 : Commandes Manuelles

Suivez le guide complet : [AZURE-DEPLOYMENT.md](AZURE-DEPLOYMENT.md)

---

## Prérequis Rapide

```powershell
# 1. Installer Azure CLI
# Télécharger: https://aka.ms/installazurecliwindows

# 2. Vérifier l'installation
az --version

# 3. Avoir votre fichier backend/.env prêt avec vos clés
```

---

## Déploiement en 3 Étapes

### Étape 1 : Préparer
```powershell
# Vérifier que le fichier .env existe
Test-Path backend\.env
# Doit retourner: True
```

### Étape 2 : Déployer
```powershell
# Lancer le script
.\deploy-simple.ps1

# Ou avec un nom personnalisé
.\deploy-simple.ps1 -AppName "mon-chatbot-rag"
```

### Étape 3 : Vérifier
```powershell
# Attendre 5-10 minutes, puis accéder à:
# https://rag-chatbot-hamza.azurewebsites.net/docs
```

---

## Après le Déploiement

### Voir les logs en direct
```powershell
az webapp log tail --resource-group rg-rag-chatbot --name rag-chatbot-hamza
```

### Redémarrer l'application
```powershell
az webapp restart --resource-group rg-rag-chatbot --name rag-chatbot-hamza
```

### Mettre à jour l'application
```powershell
# Après un push sur GitHub, redéployer:
az webapp deployment source sync --resource-group rg-rag-chatbot --name rag-chatbot-hamza
```

---

## Coûts Azure

- **App Service Plan B1** : ~13$/mois
- **Stockage** : Négligeable
- **Azure OpenAI** : Facturation à l'usage (déjà existant)

**Total estimé** : ~13-20$/mois

---

## URLs de Votre Application

Après déploiement, votre application sera accessible à :

- **API Backend** : https://rag-chatbot-hamza.azurewebsites.net
- **Documentation** : https://rag-chatbot-hamza.azurewebsites.net/docs
- **Health Check** : https://rag-chatbot-hamza.azurewebsites.net/

---

## Problèmes Courants

### Le déploiement échoue
```powershell
# Vérifier les logs
az webapp log tail --resource-group rg-rag-chatbot --name rag-chatbot-hamza
```

### L'application ne démarre pas
- Vérifier que toutes les variables d'environnement sont configurées
- Vérifier les logs de déploiement
- Redémarrer l'app

### Erreur 502/503
- L'application démarre (normal les 2-3 premières minutes)
- Attendre 5 minutes et réessayer

---

## Commandes Utiles

```powershell
# Lister les Web Apps
az webapp list --resource-group rg-rag-chatbot --output table

# Voir la configuration
az webapp config appsettings list --resource-group rg-rag-chatbot --name rag-chatbot-hamza

# Supprimer tout (pour recommencer)
az group delete --name rg-rag-chatbot --yes
```

---

## Support

- **Documentation complète** : [AZURE-DEPLOYMENT.md](AZURE-DEPLOYMENT.md)
- **Dépannage** : [TROUBLESHOOTING.md](TROUBLESHOOTING.md)
- **Azure Docs** : https://docs.microsoft.com/azure/app-service/

---

**Prêt ? Lancez le déploiement !**

```powershell
.\deploy-simple.ps1
```
