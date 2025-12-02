# 🚀 Guide de Démarrage Rapide

## Prérequis
✅ Python 3.9+ installé  
✅ Dépendances installées (voir README.md)  
✅ Fichier `.env` configuré dans le dossier `backend`

## Lancement de l'application

### Option 1 : Avec les scripts PowerShell (Recommandé)

Ouvrez **deux terminaux PowerShell** dans le dossier `azure-rag-chatbot` :

**Terminal 1 - Backend :**
```powershell
.\start-backend.ps1
```

**Terminal 2 - Frontend :**
```powershell
.\start-frontend.ps1
```

### Option 2 : Commandes manuelles

**Terminal 1 - Backend :**
```powershell
cd backend
uvicorn app.main:app --reload --host 127.0.0.1 --port 8000
```

**Terminal 2 - Frontend :**
```powershell
cd frontend
streamlit run ui.py
```

## Accès à l'application

- **Frontend (Interface utilisateur)** : http://localhost:8501
- **Backend (API)** : http://127.0.0.1:8000
- **Documentation API** : http://127.0.0.1:8000/docs

## Utilisation

1. **Télécharger un PDF** : Cliquez sur "Upload PDF" dans la barre latérale
2. **Attendre le traitement** : Le système va découper et indexer le document
3. **Poser des questions** : Tapez vos questions dans le chat
4. **Consulter l'historique** : Les conversations sont sauvegardées automatiquement

## Dépannage

### Le backend ne démarre pas
```powershell
# Vérifier que le .env existe
Test-Path backend\.env

# Vérifier la configuration
cd backend
python -c "from app.config import *; print('Config OK')"
```

### Erreur de connexion Pinecone
- Vérifiez que votre index Pinecone `rag-workshop-azure` existe
- Vérifiez que la dimension est bien 1536
- Vérifiez votre clé API Pinecone

### Erreur Azure OpenAI
- Vérifiez que vos déploiements existent :
  - `o4-mini` pour le chat
  - `text-embedding-ada-002` pour les embeddings
- Vérifiez votre endpoint Azure et votre clé API

## Arrêter l'application

Dans chaque terminal, appuyez sur `Ctrl+C`

## Architecture

```
┌─────────────┐      HTTP      ┌──────────────┐
│  Frontend   │ ────────────► │   Backend    │
│ (Streamlit) │                │  (FastAPI)   │
│  Port 8501  │                │  Port 8000   │
└─────────────┘                └──────────────┘
                                      │
                    ┌─────────────────┼─────────────────┐
                    │                 │                 │
                    ▼                 ▼                 ▼
              ┌──────────┐     ┌──────────┐     ┌──────────┐
              │  Azure   │     │ Pinecone │     │  Local   │
              │  OpenAI  │     │  Vector  │     │   Data   │
              │          │     │   Store  │     │  Storage │
              └──────────┘     └──────────┘     └──────────┘
```

## Fonctionnalités

- ✅ Upload de documents PDF
- ✅ Découpage intelligent des documents
- ✅ Embeddings Azure OpenAI
- ✅ Stockage vectoriel Pinecone
- ✅ Chat RAG avec contexte
- ✅ Historique des conversations
- ✅ Interface moderne type Google AI Studio
- ✅ Sources avec numéros de page
