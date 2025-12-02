# Azure RAG Chatbot

Application de chatbot RAG (Retrieval-Augmented Generation) utilisant Azure OpenAI, Pinecone et LangChain.

## 📋 Prérequis

- Python 3.9 ou supérieur
- Un compte Azure avec accès à Azure OpenAI
- Un compte Pinecone
- pip (gestionnaire de paquets Python)

## 🚀 Installation et Configuration

### 1. Cloner le projet

```bash
git clone https://github.com/OUCHAALI/azure-rag-chatbot.git
cd azure-rag-chatbot
```

### 2. Créer un environnement virtuel (recommandé)

```powershell
# Créer l'environnement virtuel
python -m venv venv

# Activer l'environnement virtuel
.\venv\Scripts\Activate.ps1
```

### 3. Installer les dépendances

#### Backend
```powershell
cd backend
pip install -r requirements.txt
cd ..
```

#### Frontend
```powershell
cd frontend
pip install -r requirements.txt
cd ..
```

### 4. Configuration des variables d'environnement

Créez un fichier `.env` dans le dossier `backend` avec vos clés API :

```env
# Azure OpenAI Configuration
AZURE_OPENAI_API_KEY=votre_cle_azure_openai
AZURE_OPENAI_ENDPOINT=https://votre-endpoint.openai.azure.com/
AZURE_OPENAI_API_VERSION=2024-12-01-preview
AZURE_CHAT_DEPLOYMENT=o4-mini
AZURE_EMBEDDING_DEPLOYMENT=text-embedding-ada-002

# Pinecone Configuration
PINECONE_API_KEY=votre_cle_pinecone
PINECONE_CLOUD=aws
PINECONE_ENV=us-east-1
PINECONE_INDEX_NAME=rag-workshop-azure
PINECONE_NAMESPACE=
PINECONE_DIMENSION=1536
```

> 💡 Un fichier `.env.example` est disponible dans le dossier `backend` comme référence.
> ⚠️ Le fichier `.env` contient vos clés secrètes et est ignoré par Git (`.gitignore`)

## ▶️ Lancement de l'application

Vous devez lancer **deux terminaux séparés** :

### 🚀 Option 1 : Avec les scripts PowerShell (Recommandé)

**Terminal 1 : Backend**
```powershell
.\start-backend.ps1
```

**Terminal 2 : Frontend**
```powershell
.\start-frontend.ps1
```

### 🔧 Option 2 : Commandes manuelles

**Terminal 1 : Démarrer le backend (API FastAPI)**

```powershell
cd backend
uvicorn app.main:app --reload --host 127.0.0.1 --port 8000
```

Le backend sera accessible sur `http://127.0.0.1:8000`

**Terminal 2 : Démarrer le frontend (Interface Streamlit)**

```powershell
cd frontend
streamlit run ui.py
```

Le frontend s'ouvrira automatiquement dans votre navigateur sur `http://localhost:8501`

> 📖 Consultez le fichier [QUICKSTART.md](QUICKSTART.md) pour un guide détaillé

## 📖 Utilisation

1. **Télécharger un PDF** : Utilisez la barre latérale pour uploader un document PDF
2. **Poser des questions** : Une fois le PDF traité, posez vos questions dans le chat
3. **Consulter l'historique** : Les conversations sont sauvegardées et accessibles dans la barre latérale

## 🏗️ Architecture

```
azure-rag-chatbot/
├── backend/
│   ├── app/
│   │   ├── __init__.py
│   │   ├── main.py           # API FastAPI
│   │   ├── config.py         # Configuration
│   │   └── rag_pipeline.py   # Pipeline RAG
│   ├── requirements.txt
│   └── .env                   # Variables d'environnement (à créer)
├── frontend/
│   ├── ui.py                  # Interface Streamlit
│   └── requirements.txt
└── README.md
```

## 🛠️ Technologies utilisées

- **Backend** : FastAPI, LangChain, Azure OpenAI, Pinecone
- **Frontend** : Streamlit
- **Embeddings** : Azure OpenAI Embeddings
- **Vector Database** : Pinecone
- **LLM** : Azure OpenAI GPT

## 🔧 Dépannage

### Le backend ne démarre pas
- Vérifiez que toutes les variables d'environnement sont correctement configurées dans le fichier `.env`
- Assurez-vous que le port 8000 n'est pas déjà utilisé

### Le frontend ne se connecte pas au backend
- Vérifiez que le backend est bien démarré sur `http://127.0.0.1:8000`
- La variable `API_URL` dans `ui.py` est configurée pour pointer vers `http://127.0.0.1:8000` par défaut

### Erreurs avec Pinecone
- Vérifiez que votre index Pinecone existe et a la bonne dimension (1536 pour les embeddings Azure)
- Vérifiez vos clés API Pinecone

## 📝 License

Ce projet est sous licence MIT.
