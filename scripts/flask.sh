#!/bin/bash
set -euo pipefail

echo "==== [1/4] Updating and getting libs ===="
sudo apt-get update -y
sudo apt-get install -y python3-pip libgl1-mesa-glx

APP_DIR="/vagrant/mlp-scratch"
echo "==== [2/4] Verifying dir: $APP_DIR ===="
if [ ! -d "$APP_DIR" ]; then
    echo "ERROR: Dir '$APP_DIR' not found."
    exit 1
fi

REQUIREMENTS_FILE="$APP_DIR/requirements.txt"
echo "==== [3/4] Installing dependecies '$REQUIREMENTS_FILE' globaly... ===="
if [ ! -f "$REQUIREMENTS_FILE" ]; then
    echo "ERROR: File '$REQUIREMENTS_FILE' not found."
    exit 1
fi
sudo pip3 install --timeout=600 -r "$REQUIREMENTS_FILE"

echo "==== [4/4] Starting Flask... ===="
APP_FOLDER_FLASK="$APP_DIR/flaskApp"
MODEL_FILE_SOURCE="/vagrant/NeuralNetwork.pkl"
MODEL_FILE_DEST="$APP_DIR/NeuralNetwork.pkl"

if [ -f "$MODEL_FILE_SOURCE" ]; then
    cp "$MODEL_FILE_SOURCE" "$MODEL_FILE_DEST"
else
    echo "ATENTION: 'NeuralNetwork.pkl' not found!"
    exit 1
fi

pkill -f "python3 app.py" || true

(cd "$APP_FOLDER_FLASK" && \
 nohup python3 app.py > /home/vagrant/flask_app.log 2>&1 &)

echo ""
echo "#########################################################################"
echo "✅ Flask started"
echo "#########################################################################"
echo ""