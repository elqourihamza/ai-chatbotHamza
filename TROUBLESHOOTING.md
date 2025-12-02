# 🔧 Guide de Dépannage

## Problèmes courants et solutions

### 1. Le backend ne démarre pas

#### Erreur : "AZURE_OPENAI_API_KEY is not configured"
**Solution :**
```powershell
# Vérifiez que le fichier .env existe
Test-Path backend\.env

# Si le fichier n'existe pas, créez-le avec vos clés
# Copiez le contenu de .env.example et modifiez avec vos vraies clés
```

#### Erreur : "Address already in use" (Port 8000 occupé)
**Solution :**
```powershell
# Trouvez le processus qui utilise le port 8000
netstat -ano | findstr :8000

# Tuez le processus (remplacez PID par le numéro trouvé)
taskkill /PID <PID> /F

# Ou utilisez un autre port
uvicorn app.main:app --reload --host 127.0.0.1 --port 8001
```

### 2. Erreurs Pinecone

#### Erreur : "Index 'rag-workshop-azure' not found"
**Solution :**
1. Connectez-vous à https://app.pinecone.io/
2. Vérifiez que l'index `rag-workshop-azure` existe
3. Si non, créez-le avec :
   - **Dimensions** : 1536
   - **Metric** : cosine
   - **Cloud** : AWS
   - **Region** : us-east-1

#### Erreur : "Invalid API key"
**Solution :**
1. Vérifiez votre clé API sur https://app.pinecone.io/
2. Copiez la clé depuis "API Keys"
3. Mettez à jour `PINECONE_API_KEY` dans `backend/.env`
4. Redémarrez le backend

### 3. Erreurs Azure OpenAI

#### Erreur : "DeploymentNotFound: o4-mini"
**Solution :**
1. Connectez-vous au portail Azure
2. Allez dans votre ressource Azure OpenAI
3. Vérifiez que le déploiement `o4-mini` existe
4. Si le nom est différent, mettez à jour `AZURE_CHAT_DEPLOYMENT` dans `.env`

#### Erreur : "DeploymentNotFound: text-embedding-ada-002"
**Solution :**
1. Vérifiez que le déploiement d'embeddings existe dans Azure
2. Mettez à jour `AZURE_EMBEDDING_DEPLOYMENT` dans `.env` avec le bon nom
3. Redémarrez le backend

#### Erreur : "Unauthorized" ou "Invalid API key"
**Solution :**
1. Vérifiez votre clé API Azure OpenAI
2. Dans le portail Azure, allez dans votre ressource OpenAI
3. Copiez la clé depuis "Keys and Endpoint"
4. Mettez à jour `AZURE_OPENAI_API_KEY` dans `.env`

### 4. Le frontend ne se connecte pas au backend

#### Erreur : "Connection refused" ou "Failed to fetch"
**Solution :**
```powershell
# 1. Vérifiez que le backend est démarré
# Vous devriez voir "Uvicorn running on http://127.0.0.1:8000"

# 2. Testez l'API directement
curl http://127.0.0.1:8000/docs

# 3. Vérifiez la variable API_URL dans frontend/ui.py
# Elle doit être : http://127.0.0.1:8000
```

### 5. Erreurs lors de l'upload de PDF

#### Erreur : "File must be a PDF"
**Solution :**
- Vérifiez que le fichier a bien l'extension `.pdf`
- Assurez-vous que le fichier n'est pas corrompu

#### Erreur : "Error ingesting PDF"
**Solution :**
1. Vérifiez les logs du backend
2. Causes possibles :
   - PDF protégé par mot de passe → Enlevez la protection
   - PDF scanné sans texte → Utilisez un PDF avec texte extractible
   - Problème de connexion Azure/Pinecone → Vérifiez vos clés

### 6. Questions sans réponse pertinente

#### Problème : Le chatbot répond "I could not find that in the document"
**Solution :**
1. **Document trop long** : Le système cherche dans un contexte limité
2. **Question trop vague** : Soyez plus précis
3. **Document non indexé** : Réuploadez le PDF
4. **Mauvais doc_id** : Créez une nouvelle conversation

### 7. Erreurs de dépendances Python

#### Erreur : "No module named 'xxx'"
**Solution :**
```powershell
# Réinstallez les dépendances
cd backend
pip install -r requirements.txt

cd ..\frontend
pip install -r requirements.txt
```

#### Erreur de version Python
**Solution :**
```powershell
# Vérifiez votre version
python --version

# Minimum requis : Python 3.9
# Si version < 3.9, installez une version plus récente
```

### 8. Problèmes de performance

#### Le traitement PDF est lent
**Causes normales :**
- Gros PDF (100+ pages) : peut prendre plusieurs minutes
- Première connexion à Pinecone : création d'index
- Azure OpenAI : génération des embeddings prend du temps

**Solutions :**
- Soyez patient pour les gros documents
- Vérifiez votre connexion internet
- Consultez les quotas Azure/Pinecone

### 9. Erreurs de timeout

#### Erreur : "Timeout" lors de l'upload
**Solution :**
```python
# Dans frontend/ui.py, augmentez le timeout
response = requests.post(
    f"{API_URL}/upload-pdf",
    files={"file": uploaded_file},
    timeout=300  # Augmentez à 300 secondes (5 minutes)
)
```

### 10. Vérifications de santé

#### Tester la connexion Azure
```powershell
cd backend
python -c "from app.rag_pipeline import llm; print(llm.invoke('Hello').content)"
```

#### Tester la connexion Pinecone
```powershell
cd backend
python -c "from app.rag_pipeline import pc; print([i.name for i in pc.list_indexes()])"
```

#### Tester la configuration complète
```powershell
cd backend
python -c "from app.config import *; print('✅ Tout est OK')"
```

## Logs et debugging

### Activer les logs détaillés

Modifiez `backend/app/rag_pipeline.py` :
```python
logging.basicConfig(
    level=logging.DEBUG,  # Changez INFO en DEBUG
    format="%(asctime)s [%(levelname)s] %(message)s",
    datefmt="%Y-%m-%d %H:%M:%S",
)
```

### Consulter les logs en temps réel

Les logs s'affichent dans les terminaux où vous avez lancé les services.

## Besoin d'aide supplémentaire ?

1. **Consultez la documentation API** : http://127.0.0.1:8000/docs
2. **Vérifiez les issues GitHub** du projet
3. **Consultez la documentation Azure OpenAI** : https://learn.microsoft.com/azure/ai-services/openai/
4. **Consultez la documentation Pinecone** : https://docs.pinecone.io/

## Réinitialisation complète

Si tout le reste échoue :

```powershell
# 1. Arrêtez tous les services (Ctrl+C dans chaque terminal)

# 2. Supprimez les données locales
Remove-Item -Recurse -Force backend\tmp_uploads
Remove-Item -Recurse -Force backend\data
Remove-Item -Force frontend\chat_history.json

# 3. Vérifiez votre .env
notepad backend\.env

# 4. Redémarrez les services
.\start-backend.ps1
# (dans un nouveau terminal)
.\start-frontend.ps1
```
