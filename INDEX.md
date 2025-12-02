# 📚 Documentation - Azure RAG Chatbot

Bienvenue dans la documentation du projet Azure RAG Chatbot !

## 🚀 Démarrage Rapide

Nouveau sur le projet ? Commencez ici :

1. **[QUICKSTART.md](QUICKSTART.md)** - Guide de démarrage rapide (5 minutes)
   - Instructions de lancement
   - Commandes essentielles
   - Premier test

## 📖 Documentation Complète

### Pour tous les utilisateurs

- **[README.md](README.md)** - Documentation principale
  - Installation complète
  - Configuration détaillée
  - Architecture du projet
  - Technologies utilisées

### Configuration et Setup

- **[SETUP-COMPLETE.md](SETUP-COMPLETE.md)** - État de la configuration actuelle
  - Configuration validée
  - Tests réussis
  - Prochaines étapes

- **[PROJECT-STATUS.md](PROJECT-STATUS.md)** - État détaillé du projet
  - Services en cours
  - Modifications appliquées
  - Structure des fichiers

### Résolution de problèmes

- **[TROUBLESHOOTING.md](TROUBLESHOOTING.md)** - Guide de dépannage
  - Problèmes courants
  - Solutions pas à pas
  - Commandes de diagnostic

## 🗂️ Navigation par Besoin

### Je veux démarrer l'application
→ [QUICKSTART.md](QUICKSTART.md) - Section "Lancement de l'application"

### J'ai une erreur
→ [TROUBLESHOOTING.md](TROUBLESHOOTING.md) - Recherchez votre message d'erreur

### Je veux comprendre le code
→ [README.md](README.md) - Section "Architecture"

### Je veux configurer mes clés API
→ [README.md](README.md) - Section "Configuration des variables d'environnement"

### Je veux voir l'état du projet
→ [PROJECT-STATUS.md](PROJECT-STATUS.md)

## 📋 Checklist de Démarrage

- [x] Python 3.9+ installé
- [x] Dépendances backend installées
- [x] Dépendances frontend installées
- [x] Fichier `.env` configuré dans `backend/`
- [x] Clés Azure OpenAI configurées
- [x] Clés Pinecone configurées
- [x] Tests de connexion réussis
- [x] Backend démarré avec succès
- [ ] Frontend démarré
- [ ] Premier PDF uploadé
- [ ] Première question posée

## 🎯 Commandes Essentielles

### Démarrer les services

```powershell
# Backend
.\start-backend.ps1

# Frontend (dans un nouveau terminal)
.\start-frontend.ps1
```

### Tester la configuration

```powershell
# Vérifier le fichier .env
Test-Path backend\.env

# Tester Azure + Pinecone
cd backend
python -c "from app.config import *; print('✅ Config OK')"
```

### Arrêter les services

Dans chaque terminal : `Ctrl+C`

## 🔗 Liens Utiles

### Documentation externe
- [Azure OpenAI](https://learn.microsoft.com/azure/ai-services/openai/)
- [Pinecone](https://docs.pinecone.io/)
- [FastAPI](https://fastapi.tiangolo.com/)
- [Streamlit](https://docs.streamlit.io/)
- [LangChain](https://python.langchain.com/)

### Accès local
- Frontend : http://localhost:8501
- Backend API : http://127.0.0.1:8000
- API Docs : http://127.0.0.1:8000/docs

## 📊 Structure de la Documentation

```
Documentation/
│
├── INDEX.md (ce fichier)          # Navigation
├── README.md                       # Doc principale
├── QUICKSTART.md                   # Démarrage rapide
├── SETUP-COMPLETE.md               # Configuration validée
├── PROJECT-STATUS.md               # État du projet
└── TROUBLESHOOTING.md              # Dépannage
```

## 🆘 Besoin d'Aide ?

1. **Consultez d'abord** [TROUBLESHOOTING.md](TROUBLESHOOTING.md)
2. **Vérifiez** [PROJECT-STATUS.md](PROJECT-STATUS.md) pour l'état des services
3. **Relisez** [QUICKSTART.md](QUICKSTART.md) pour les étapes de base

## 🎉 Félicitations !

Votre projet Azure RAG Chatbot est maintenant configuré et prêt à l'emploi.

**Prochaine étape** : Lancez le frontend et testez votre premier PDF !

```powershell
.\start-frontend.ps1
```

---

*Documentation mise à jour le 2 décembre 2025*
