# create_dummy_model.py
import pickle
import numpy as np
import os
from flaskapp.NMLPlib import NeuralNetwork

# Cria um modelo simples apenas para o servidor ficar de pé
print("Criando modelo dummy para testes...")
dummy_images = np.zeros((1, 784))
dummy_labels = np.array([0])
modelo = NeuralNetwork(dummy_images, dummy_labels, [10], 10, 0)
modelo.initiateNN()

# Salva na pasta flaskapp onde o container espera encontrar
path = os.path.join('flaskapp', 'NeuralNetwork.pkl')
with open(path, 'wb') as f:
    pickle.dump(modelo, f)
print(f"Modelo salvo em {path}")