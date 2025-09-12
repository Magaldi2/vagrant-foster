import sys
from pathlib import Path

# --- CORREÇÃO CRUCIAL AQUI ---
# Adiciona o diretório pai (a raiz do mlp-scratch) ao path do Python.
# Isso garante que o pickle consiga encontrar a definição da classe NeuralNetwork.
sys.path.append(str(Path(__file__).resolve().parent.parent))
# -----------------------------

from flask import Flask, render_template, request, jsonify
from NMLPlib import *
import numpy as np
import traceback

app = Flask(__name__)

# Carrega o modelo uma vez na inicialização
modelo = loadModelo('../NeuralNetwork.pkl')

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/predict', methods=['POST'])
def predict():
    try:
        grid_data = request.json['grid']
        img_array = np.array(grid_data, dtype=np.uint8)
        numero, certeza = modelo.preverImageCustomOnlyText(img_array)
        
        return jsonify({
            'success': True,
            'numero': int(numero),
            'certeza': float(certeza)
        })
        
    except Exception as e:
        print(f"ERRO: {str(e)}")
        traceback.print_exc()
        return jsonify({
            'success': False,
            'error': str(e)
        })

if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5000)