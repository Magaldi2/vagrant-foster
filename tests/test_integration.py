import pytest
import requests
import json
import time

# URL do container Flask (mapeado no docker-compose ports: 5000:5000)
BASE_URL = "http://localhost:5000"

# Fixture para garantir que o container está respondendo antes de testar
@pytest.fixture(scope="module", autouse=True)
def wait_for_server():
    retries = 10
    for i in range(retries):
        try:
            response = requests.get(BASE_URL)
            if response.status_code == 200:
                return
        except requests.exceptions.ConnectionError:
            pass
        print(f"Aguardando servidor subir... tentativa {i+1}/{retries}")
        time.sleep(5)
    pytest.fail("O servidor Flask não subiu a tempo.")

def test_home_route_container():
    """Teste 1: Verifica se a home page carrega no container"""
    response = requests.get(f"{BASE_URL}/")
    assert response.status_code == 200
    assert "Canvas" in response.text

def test_clear_route_container():
    """Teste 2: Verifica se a rota /clear funciona via POST no container"""
    response = requests.post(f"{BASE_URL}/clear")
    assert response.status_code == 200
    data = response.json()
    assert data['success'] is True

def test_predict_route_container():
    """Teste 3: Envia um grid vazio para o container processar"""
    # Grid 28x28 vazio
    grid_data = [[0]*28 for _ in range(28)]
    payload = {'grid': grid_data}
    
    headers = {'Content-Type': 'application/json'}
    response = requests.post(f"{BASE_URL}/predict", 
                             data=json.dumps(payload),
                             headers=headers)
    
    assert response.status_code == 200
    data = response.json()
    
    # Valida a resposta vinda do container
    assert data['success'] is True
    assert 'numero' in data
    assert 'certeza' in data