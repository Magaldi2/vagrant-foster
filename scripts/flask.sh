#!/bin/bash
set -euo pipefail

# -- PASSO 1: Instalação de Dependências do Sistema --
echo "==== [1/6] Atualizando pacotes e instalando Pip, Venv e libs gráficas... ===="
sudo apt-get update -y
sudo apt-get install -y python3-pip python3-venv libgl1-mesa-glx

# -- PASSO 2: Definindo Caminhos --
# O Vagrant compartilha a pasta do seu projeto para /vagrant na VM.
# O script assume que sua pasta de código 'mlp-scratch' está dentro dela.
APP_DIR="/vagrant/mlp-scratch"
# O ambiente virtual será criado na home do usuário da VM para evitar erros.
VENV_DIR="/home/vagrant/mlp_venv"

echo "==== [2/6] Verificando diretório local da aplicação: $APP_DIR ===="
if [ ! -d "$APP_DIR" ]; then
    echo "************************************************************************"
    echo "ERRO: Diretório '$APP_DIR' não encontrado dentro da VM."
    echo "Verifique se a sua pasta de código se chama exatamente 'mlp-scratch' e"
    echo "está no mesmo nível da sua pasta 'scripts'."
    echo "************************************************************************"
    exit 1
fi

# -- PASSO 3: Criação do Ambiente Virtual (Venv) --
echo "==== [3/6] Criando ambiente virtual em '$VENV_DIR'... ===="
python3 -m venv "$VENV_DIR"

# -- PASSO 4: Instalação das Dependências Python --
# O script procura pelo requirements.txt DENTRO da sua pasta de código.
REQUIREMENTS_FILE="$APP_DIR/requirements.txt"
echo "==== [4/6] Instalando dependências de '$REQUIREMENTS_FILE'... ===="
if [ ! -f "$REQUIREMENTS_FILE" ]; then
    echo "ERRO: Arquivo '$REQUIREMENTS_FILE' não encontrado."
    exit 1
fi
# --- CORREÇÃO AQUI ---
# Adicionado --timeout=600 para dar mais tempo para o download dos pacotes
"$VENV_DIR/bin/pip" install --timeout=600 -r "$REQUIREMENTS_FILE"

# -- PASSO 5: Copiar o Modelo .pkl Local --
MODEL_FILE_SOURCE="/vagrant/NeuralNetwork.pkl"
MODEL_FILE_DEST="$APP_DIR/NeuralNetwork.pkl"
echo "==== [5/6] Copiando o modelo local 'NeuralNetwork.pkl'... ===="

if [ ! -f "$MODEL_FILE_SOURCE" ]; then
    echo "ATENÇÃO: Arquivo 'NeuralNetwork.pkl' não encontrado na sua pasta raiz!"
    exit 1
fi
cp "$MODEL_FILE_SOURCE" "$MODEL_FILE_DEST"
echo "Modelo copiado com sucesso para a pasta da aplicação."

# -- PASSO 6: Iniciar a Aplicação com Gunicorn --
echo "==== [6/6] Iniciando a aplicação com o servidor de produção Gunicorn... ===="
APP_FOLDER_FLASK="$APP_DIR/flaskApp"
pkill gunicorn || true

# Inicia o Gunicorn a partir do diretório local, usando o venv criado na home
(cd "$APP_FOLDER_FLASK" && \
 nohup "$VENV_DIR/bin/gunicorn" --workers 3 --bind 0.0.0.0:5000 app:app > /home/vagrant/flask_app.log 2>&1 &)

echo ""
echo "#########################################################################"
echo "✅ Provisionamento a partir de arquivos locais concluído!"
echo "A aplicação foi iniciada com o servidor Gunicorn em segundo plano."
echo "Acesse em seu navegador: http://localhost:8080"
echo "#########################################################################"
echo ""