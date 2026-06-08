# 🌍 TELURIC

## Sobre o Projeto

O **Teluric** é uma plataforma de validação ambiental baseada em tecnologias da economia espacial, desenvolvida para monitorar, analisar e validar impactos ambientais positivos por meio de dados geoespaciais e sensoriamento remoto.

A solução utiliza imagens de satélite, análise temporal da vegetação e indicadores ambientais para acompanhar a evolução de áreas monitoradas, permitindo identificar evidências de regeneração ambiental e gerar informações confiáveis para apoio à tomada de decisão.

O principal objetivo da plataforma é reduzir a dependência de processos manuais de auditoria ambiental, promovendo maior transparência, rastreabilidade e confiabilidade na validação de iniciativas como reflorestamento, recuperação de áreas degradadas e preservação ambiental.

Como visão de evolução futura, o projeto prevê a implementação de mecanismos de tokenização e rastreabilidade digital, possibilitando a criação de ativos ambientais verificáveis vinculados às evidências geradas pela plataforma.

---

## 🎯 Objetivos

* Monitorar áreas ambientais utilizando dados espaciais.
* Validar automaticamente evidências de regeneração ambiental.
* Calcular indicadores ambientais baseados em sensoriamento remoto.
* Gerar scores ambientais para apoio à tomada de decisão.
* Emitir ativos digitais auditáveis.
* Criar uma base tecnológica para futura tokenização de ativos ambientais.

---

## 🚀 Funcionalidades

### Cadastro e Monitoramento de Áreas

* Delimitação de áreas geográficas diretamente no mapa.
* Cadastro de informações complementares da área monitorada.
* Armazenamento de coordenadas georreferenciadas.

### Processamento Ambiental

* Integração com dados de satélite.
* Análise temporal da vegetação.
* Cálculo do índice NDVI (Normalized Difference Vegetation Index).
* Classificação ambiental da área.

### Indicadores Ambientais

* Score Ambiental.
* Estimativa de regeneração.
* Indicadores de carbono equivalente (CO₂e).
* Histórico de evolução da área.

### Ativo Digital

* Geração de ativo ambiental.
* Registro dos resultados da análise.
* Evidências digitais verificáveis.

### Evolução Futura

* Tokenização de ativos ambientais.
* Integração com Blockchain.
* Wallet ambiental para gestão de ativos digitais.

---

## 🏗 Arquitetura da Solução

A arquitetura do Teluric foi estruturada em camadas para garantir escalabilidade, modularidade e facilidade de manutenção.

### Camada Mobile

Responsável pela interação com o usuário.

Funções principais:

* Seleção de áreas geográficas.
* Visualização de mapas.
* Consulta de indicadores ambientais.
* Visualização de ativos.
* Acompanhamento das áreas monitoradas.

### Camada Backend

Responsável pela lógica de negócio.

Funções principais:

* Validação de coordenadas geográficas.
* Processamento geoespacial.
* Integração com APIs externas.
* Cálculo de indicadores ambientais.
* Geração de ativos digitais.

### Banco de Dados Geoespacial

Responsável pelo armazenamento das informações da plataforma.

Armazena:

* Usuários.
* Áreas cadastradas.
* Coordenadas geográficas.
* Histórico de análises.
* Scores ambientais.
* Ativos emitidos.

### Serviços Externos

Integração com fontes de observação da Terra para obtenção de dados espaciais e imagens de satélite utilizadas durante o processo de validação ambiental.

---

## 🛰 Tecnologias Utilizadas

### Mobile

* Flutter
* Dart

### Backend

* Python
* FastAPI
* SQLAlchemy
* JWT Authentication
* Pydantic
* PostgreSQL

### Banco de Dados

* PostgreSQL
* PostGIS

### Geoprocessamento Espacial

* INMET
* INPE
* Sentinel-2
* Landsat
* ArcGis
* GeoJSON

### Inteligência Artificial

* TensorFlow
* PyTorch
* OpenCV

### Geolocalização e Mapas

* Flutter Map

### Ferramentas de Desenvolvimento

* Visual Studio Code
* Android Studio
* Git
* GitHub
* Figma

---

## 📊 Fluxo de Funcionamento

1. O usuário seleciona uma área no mapa.
2. O aplicativo envia as coordenadas para o backend.
3. O sistema valida os dados recebidos.
4. São solicitadas imagens de satélite da região.
5. O backend processa os dados geoespaciais.
6. É realizada a análise temporal baseada em NDVI.
7. O sistema calcula indicadores ambientais.
8. Um Score Ambiental é gerado.
9. O ativo digital é emitido.
10. Os resultados são disponibilizados ao usuário.

---

## 📱 Principais Telas

* Dashboard Ambiental
* Seleção de Área
* Detalhamento da Área
* Análise Ambiental
* Ativo Ambiental
* Wallet Ambiental
* Perfil do Usuário

---

## ⚙️ ▶️ Guia Completo de Execução

Para instruções detalhadas de instalação e execução, consulte:

👉 [EXECUTANDO.md](.idea/EXECUTANDO.md)

---

## 🌱 Impacto Esperado

O Teluric busca democratizar o acesso a mecanismos de validação ambiental por meio de tecnologias espaciais, contribuindo para processos mais transparentes, auditáveis e escaláveis de monitoramento ambiental.

A plataforma tem potencial para apoiar produtores rurais, organizações ambientais, empresas e instituições públicas na geração de evidências confiáveis relacionadas à preservação ambiental, recuperação de áreas degradadas e acompanhamento de indicadores ecológicos.

---

## 👥 Equipe

Projeto desenvolvido como parte da Global Solution FIAP, conectando tecnologias da economia espacial aos desafios ambientais e climáticos contemporâneos.

---

## 📄 Licença

Este projeto foi desenvolvido para fins acadêmicos e educacionais, desenvolvido por Manoela Oliveira, Paula Carregal, Pedro Santiago e Vanessa Fittipaldi.
