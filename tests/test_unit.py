import sys
import os
import pytest
import numpy as np

# Adiciona o diretório flaskapp ao path para importar os módulos
sys.path.append(os.path.join(os.path.dirname(__file__), '../flaskapp'))

from NMLPlib import sigmoid, sigmoid_derivative, NeuralNetwork

# --- TESTES MATEMÁTICOS (FUNÇÕES AUXILIARES) ---
#--
def test_sigmoid_basic():
    # 1. Testa se sigmoid de 0 é 0.5
    assert sigmoid(0) == 0.5

def test_sigmoid_positive():
    # 2. Testa se sigmoid de número grande tende a 1
    assert sigmoid(10) > 0.99

def test_sigmoid_derivative():
    # 3. Testa a derivada da sigmoid no ponto 0.5 (entrada x=0.5, pois a função espera o valor já sigmoide)
    # A derivada é x * (1 - x). Se x=0.5 -> 0.5 * 0.5 = 0.25
    assert sigmoid_derivative(0.5) == 0.25

# --- TESTES DA CLASSE NEURALNETWORK ---

@pytest.fixture
def dummy_nn():
    # Fixture cria uma rede neural pequena para testes
    images = np.zeros((1, 784)) # 1 imagem preta
    labels = np.array([0])      # label 0
    # Rede: Input(784) -> Hidden(10) -> Output(10)
    return NeuralNetwork(images, labels, [10], 10, 0)

def test_nn_initialization_input_shape(dummy_nn):
    dummy_nn.initiateNN()
    # 4. Verifica se os pesos da camada de input têm o formato correto (Hidden x Input)
    # Esperado: (10, 784)
    assert dummy_nn.camada_input_pesos.shape == (10, 784)

def test_nn_initialization_output_shape(dummy_nn):
    dummy_nn.initiateNN()
    # 5. Verifica se os pesos da última camada têm formato correto
    # Temos 1 camada oculta, então camada_pesos[0] conecta Hidden->Output
    # Esperado: (10, 10)
    assert dummy_nn.camada_pesos[0].shape == (10, 10)

def test_nn_forward_propagation_range(dummy_nn):
    dummy_nn.initiateNN()
    dummy_nn.fPropagation()
    # 6. Verifica se a saída final contém valores entre 0 e 1 (por causa da sigmoid)
    assert np.all(dummy_nn.camada_final_valor >= 0)
    assert np.all(dummy_nn.camada_final_valor <= 1)

def test_nn_cost_function_initial(dummy_nn):
    dummy_nn.initiateNN()
    dummy_nn.fPropagation()
    cost = dummy_nn.costFunc()
    # 7. Verifica se a função de custo retorna um número válido (float) e não negativo
    assert isinstance(cost, float)
    assert cost >= 0