# Use the same lightweight Python image
FROM python:3.11-slim

# Set working directory
WORKDIR /app

# Copy requirements and install
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Copy the frontend code (including .streamlit folder for the theme)
COPY . .

# Expose Streamlit's default port
EXPOSE 8501

# Run Streamlit
# --server.address=0.0.0.0 is required for Docker networking
CMD ["streamlit", "run", "ui.py", "--server.port=8501", "--server.address=0.0.0.0"]