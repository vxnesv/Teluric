Markdown
# 🌍 TELURIC — Oráculo Ambiental

Monitoramento ambiental com rastreabilidade criptográfica. Este projeto utiliza inteligência e dados geográficos para análise de áreas ambientais, estruturado com um backend em FastAPI (Python) e um frontend em Flutter.

---

## 📂 Estrutura do Repositório

🚀 Como Executar o Projeto (Passo a Passo)
Siga as instruções abaixo para rodar o backend e o frontend na sua máquina local de forma integrada e sem necessidade de instalações complexas.


🔹 Parte 1: Configurando o Backend (Python + SQLite)
O banco de dados foi configurado utilizando SQLite, o que significa que não é necessário instalar o PostgreSQL. O banco será gerado automaticamente como um arquivo local dentro da pasta.

1. Acesse a pasta do backend e crie o ambiente virtual:

Bash
cd backend
python -m venv venv
2. Ative o ambiente virtual (VENV):

Windows (PowerShell):

PowerShell
.\venv\Scripts\Activate.ps1
Linux / Mac:

Bash
source venv/bin/activate
3. Instale as dependências do projeto:

Bash
pip install -r requirements.txt
4. Configure as Variáveis de Ambiente:
Crie um arquivo chamado .env na raiz da pasta backend (você pode duplicar o .env.example) e adicione as configurações abaixo:

Plaintext
DATABASE_URL=sqlite:///./teluric.db
SECRET_KEY=sua_chave_secreta_super_segura_aqui
ALGORITHM=HS256
ACCESS_TOKEN_EXPIRE_MINUTES=1440
5. Rode as Migrações do Banco de Dados (Alembic):
Esse comando vai criar o arquivo teluric.db e estruturar todas as tabelas automaticamente.

Bash
# Se o venv estiver ativo:
alembic upgrade head

# Caso o comando acima não seja reconhecido no Windows:
.\venv\Scripts\alembic.exe upgrade head
6. Inicie o Servidor:
Iniciamos o servidor escutando em 0.0.0.0 para garantir que tanto o Navegador (Web) quanto os Emuladores de Celular consigam se conectar à API:

Bash
uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
Acompanhe a documentação interativa da API em: http://localhost:8000/docs

🔸 Parte 2: Configurando o Frontend (Flutter)
O frontend foi programado para detectar automaticamente onde está sendo executado. Ele adapta o endereço IP de conexão se você estiver rodando no navegador ou no emulador do Android Studio.

1. Abra uma nova janela do terminal e acesse a pasta do frontend:

Bash
cd frontend
2. Baixe os pacotes do Flutter:

Bash
flutter pub get
3. Execute o projeto:

Bash
flutter run
💡 Nota de Conexão: No emulador do Android, o Flutter se comunicará via o IP interno padrão 10.0.2.2:8000. No navegador ou simulador iOS, ele utilizará o localhost/127.0.0.1