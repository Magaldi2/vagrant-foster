# Vagrant Foster: Ambiente para Aplicação de Machine Learning com Flask

![Python](https://img.shields.io/badge/Python-3.8+-blue?logo=python&logoColor=yellow)
![Flask](https://img.shields.io/badge/Flask-2.x-black?logo=flask)
![Vagrant](https://img.shields.io/badge/Vagrant-2.x-blueviolet?logo=vagrant)
![VirtualBox](https://img.shields.io/badge/VirtualBox-6.x-blue?logo=virtualbox)

Este repositório contém a configuração de um ambiente de desenvolvimento virtualizado e automatizado para uma aplicação de Machine Learning. O ambiente utiliza o Vagrant para provisionar uma máquina virtual Ubuntu, que por sua vez executa uma API construída com Flask para servir um modelo de rede neural pré-treinado.

## 📋 Tabela de Conteúdos
1.  [Sobre o Projeto](#-sobre-o-projeto)
2.  [Tecnologias Utilizadas](#-tecnologias-utilizadas)
3.  [Pré-requisitos](#-pré-requisitos)
4.  [Como Executar](#-como-executar)
5.  [Comandos Úteis do Vagrant](#-comandos-úteis-do-vagrant)
6.  [Estrutura do Repositório](#-estrutura-do-repositório)

---

### 🚀 Sobre o Projeto

O objetivo deste projeto é fornecer um ambiente consistente, isolado e facilmente reprodutível para testar e executar uma aplicação de Machine Learning. Ao usar o Vagrant, garantimos que todos os desenvolvedores trabalhem com as mesmas dependências e configurações, eliminando o clássico problema de "funciona na minha máquina".

O script de provisionamento (`bootstrap.sh`) automatiza os seguintes passos:
-   Atualiza o sistema operacional da VM (Ubuntu).
-   Instala Python 3, pip e outras bibliotecas essenciais.
-   Instala as dependências da aplicação Python listadas no `requirements.txt`.
-   Copia o modelo de Machine Learning (`NeuralNetwork.pkl`) para a pasta da aplicação.
-   Inicia o servidor Flask em segundo plano.

---

### 🔧 Tecnologias Utilizadas

* **Virtualização:**
    * [Vagrant](https://www.vagrantup.com/): Ferramenta para criar e gerenciar ambientes virtuais.
    * [VirtualBox](https://www.virtualbox.org/): Provedor de virtualização para executar a VM.
* **Backend:**
    * [Python 3](https://www.python.org/): Linguagem de programação principal.
    * [Flask](https://flask.palletsprojects.com/): Microframework web para criar a API.
    * **Bibliotecas de ML:** (Ex: scikit-learn, pandas, numpy - a serem listadas em `requirements.txt`).
* **Sistema Operacional da VM:**
    * Ubuntu (configurado via Vagrantfile).
* **Automação:**
    * Bash Script (`bootstrap.sh`): Script para provisionamento automático.

---

### 💻 Pré-requisitos

Antes de começar, você precisa ter as seguintes ferramentas instaladas em sua máquina local:

* **Vagrant:** [Faça o download aqui](https://www.vagrantup.com/downloads)
* **VirtualBox:** [Faça o download aqui](https://www.virtualbox.org/wiki/Downloads)

---

### ▶️ Como Executar

Siga os passos abaixo para colocar o ambiente no ar:

1.  **Clone o repositório:**
    ```bash
    git clone [https://github.com/Magaldi2/vagrant-foster.git](https://github.com/Magaldi2/vagrant-foster.git)
    ```

2.  **Acesse o diretório do projeto:**
    ```bash
    cd vagrant-foster
    ```

3.  **Baixe o Modelo de Machine Learning:**
    Antes de iniciar a máquina virtual, é necessário baixar o modelo de rede neural pré-treinado (`NeuralNetwork.pkl`).

    * **Acesse o link a seguir para fazer o download:** [Link para o Modelo de Rede Neural](https://cdn.discordapp.com/attachments/11415882683317489735/11415882694495047760/NeuralNetwork.pkl)
    * **Mova o arquivo `NeuralNetwork.pkl` baixado para a pasta (`/mlp-scratch` do projeto** (a mesma pasta onde está no memo nivel que o `/flaskapp` e o `/_pycache_`).

    > **⚠️ Nota:** O ideal para um projeto público é incluir o arquivo do modelo diretamente no repositório ou hospedá-lo em um link público e estável, como no Google Drive (com acesso público) ou usando Git LFS.

4.  **Inicie a máquina virtual:**
    ```bash
    vagrant up
    ```
    * Este comando irá baixar a imagem do sistema operacional (se for a primeira vez), criar a máquina virtual e executar o script `bootstrap.sh`. O processo pode levar alguns minutos.

5.  **Acesse a aplicação:**
    Após a conclusão do `vagrant up`, o servidor Flask estará rodando dentro da VM. Para que você possa acessá-lo do seu navegador, o `Vagrantfile` deve ser configurado para encaminhar uma porta (por exemplo, a porta 8080 da VM para a 8080 da sua máquina).

    Abra seu navegador e acesse: `http://localhost:8080`

6.  **Verificando os logs:**
    Caso a aplicação não pareça estar funcionando, você pode acessar a VM via SSH e verificar o arquivo de log:
    ```bash
    # Conectar à VM
    vagrant ssh

    # Visualizar o log do Flask
    cat /home/vagrant/flask_app.log
    ```

---

### ✨ Comandos Úteis do Vagrant

* **Ligar a VM (se estiver desligada):**
    ```bash
    vagrant up
    ```
* **Desligar a VM:**
    ```bash
    vagrant halt
    ```
* **Conectar-se à VM via SSH:**
    ```bash
    vagrant ssh
    ```
* **Forçar a re-execução do script de provisionamento:**
    ```bash
    vagrant provision
    # Ou, para recarregar a VM e rodar o provisionamento
    vagrant reload --provision
    ```
* **Destruir a VM (apaga tudo, irreversível):**
    ```bash
    vagrant destroy -f
    ```

---

### 📁 Estrutura do Repositório
