#!/bin/bash

# Startup script for Azure Web App - Backend
echo "Starting FastAPI Backend..."

# Install dependencies
pip install -r requirements.txt

# Start uvicorn
python -m uvicorn app.main:app --host 0.0.0.0 --port 8000
