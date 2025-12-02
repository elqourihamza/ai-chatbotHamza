#!/bin/bash

# Startup script for Azure Web App - Frontend
echo "Starting Streamlit Frontend..."

# Install dependencies
pip install -r requirements.txt

# Start streamlit on port 8000 (Azure Web App default)
streamlit run ui.py --server.port 8000 --server.address 0.0.0.0 --server.headless true
