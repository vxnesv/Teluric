from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from app.api.v1 import auth, areas, analise, certificados

app = FastAPI(
    title="Teluric API",
    description=(
        "Backend de monitoramento ambiental com inteligência geoespacial "
        "e rastreabilidade criptográfica. Preparado para integração Web3/Polygon."
    ),
    version="2.0.0",
)

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

PREFIX = "/api/v1"
app.include_router(auth.router, prefix=PREFIX)
app.include_router(areas.router, prefix=PREFIX)
app.include_router(analise.router, prefix=PREFIX)
app.include_router(certificados.router, prefix=PREFIX)


@app.get("/", tags=["Status"])
def health_check():
    return {
        "status": "Online",
        "plataforma": "Teluric — Monitoramento Ambiental",
        "versao": "2.0.0",
        "docs": "/docs",
    }
