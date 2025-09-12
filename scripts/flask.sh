#!/bin/bash
set -euo pipefail

# -- PASSO 1: Instalação de Dependências do Sistema --
echo "==== [1/4] Updating packages and installing Pip and graphics libraries... ===="
sudo apt-get update -y
# --- CORREÇÃO AQUI ---
sudo apt-get install -y python3-pip libgl1-mesa-glx

# -- PASSO 2: Definindo o Caminho da Aplicação --
APP_DIR="/vagrant/mlp-scratch"
echo "==== [2/4] Verifying local application directory: $APP_DIR ===="
if [ ! -d "$APP_DIR" ]; then
    echo "ERROR: Directory '$APP_DIR' not found."
    exit 1
fi

# -- PASSO 3: Instalação das Dependências Python --
REQUIREMENTS_FILE="$APP_DIR/requirements.txt"
echo "==== [3/4] Installing dependencies from '$REQUIREMENTS_FILE' globally... ===="
if [ ! -f "$REQUIREMENTS_FILE" ]; then
    echo "ERROR: File '$REQUIREMENTS_FILE' not found."
    exit 1
fi
sudo pip3 install --timeout=600 -r "$REQUIREMENTS_FILE"

# -- PASSO 4: Iniciar a Aplicação Flask --
echo "==== [4/4] Starting Flask application in development mode... ===="
APP_FOLDER_FLASK="$APP_DIR/flaskApp"
MODEL_FILE_SOURCE="/vagrant/NeuralNetwork.pkl"
MODEL_FILE_DEST="$APP_DIR/NeuralNetwork.pkl"

if [ -f "$MODEL_FILE_SOURCE" ]; then
    cp "$MODEL_FILE_SOURCE" "$MODEL_FILE_DEST"
else
    echo "WARNING: 'NeuralNetwork.pkl' not found!"
    exit 1
fi

pkill -f "python3 app.py" || true

(cd "$APP_FOLDER_FLASK" && \
 nohup python3 app.py > /home/vagrant/flask_app.log 2>&1 &)

echo ""
echo "#########################################################################"
echo "✅ Provisioning complete! The Flask application has been started."
echo "Access it in your browser at: http://localhost:8080"
echo "#########################################################################"
echo ""