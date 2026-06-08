Markdown
# 🚀 Executando o TELURIC

Este guia mostra como executar o projeto localmente.

O projeto é dividido em duas partes:

```text
TELURIC
│
├── frontend/  → Flutter
└── backend/   → FastAPI
```

⚠️ O backend deve estar rodando antes do frontend.

---

# Pré-requisitos

Instalar:

* Python 3.11+
* Flutter SDK
* Git

Verifique as instalações:

```bash
python --version
flutter --version
git --version
```

---

# 🔹 Backend (FastAPI)

## 1. Acesse a pasta

```bash
cd backend
```

## 2. Crie o ambiente virtual

```bash
python -m venv venv
```

## 3. Ative o ambiente virtual

### Windows

```powershell
.\venv\Scripts\Activate.ps1
```

### Linux / macOS

```bash
source venv/bin/activate
```

## 4. Instale as dependências

```bash
pip install -r requirements.txt
```

## 5. Configure o arquivo .env

Crie um arquivo chamado `.env` na raiz da pasta backend.

Exemplo:

```env
DATABASE_URL=sqlite:///./teluric.db
SECRET_KEY=sua_chave_secreta
ALGORITHM=HS256
ACCESS_TOKEN_EXPIRE_MINUTES=1440
```

---

## 6. Execute as migrações

```bash
alembic upgrade head
```

Windows:

```powershell
.\venv\Scripts\alembic.exe upgrade head
```

Esse comando criará automaticamente o banco de dados local.

---

## 7. Inicie a API

```bash
uvicorn app.main:app --reload --host 0.0.0.0 --port 8000
```

Se tudo estiver correto, a API ficará disponível em:

```text
http://localhost:8000
```

Documentação Swagger:

```text
http://localhost:8000/docs
```

---

# 🔸 Frontend (Flutter)

Abra um novo terminal.

## 1. Acesse a pasta

```bash
cd frontend
```

## 2. Instale as dependências

```bash
flutter pub get
```

## 3. Execute o projeto

```bash
flutter run
```

---

# 🔗 Configuração de Conexão

O aplicativo identifica automaticamente o ambiente onde está rodando.

| Ambiente         | Endereço da API |
| ---------------- | --------------- |
| Flutter Web      | localhost:8000  |
| Android Emulator | 10.0.2.2:8000   |
| iOS Simulator    | localhost:8000  |

---

# Problemas Comuns

### Erro ao ativar o ambiente virtual no Windows

Execute o PowerShell como administrador e rode:

```powershell
Set-ExecutionPolicy RemoteSigned
```

---

### Erro de dependências

Atualize o pip:

```bash
python -m pip install --upgrade pip
```

---

### API não conecta no Flutter

Verifique:

* Backend rodando na porta 8000
* Firewall liberado
* Emulador Android utilizando `10.0.2.2`

---

# Ordem Correta

Sempre execute nesta ordem:

```text
1. Backend
2. Banco de Dados (Alembic)
3. Frontend
```

Se o backend não estiver rodando, o login e as funcionalidades da aplicação não funcionarão.
