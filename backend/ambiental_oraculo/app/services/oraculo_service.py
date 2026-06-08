import hashlib
import random
from datetime import datetime
from typing import List


class OraculoService:

    @staticmethod
    def calcular_ndvi(coordenadas: List[List[float]]) -> float:
        if not coordenadas or len(coordenadas) < 3:
            raise ValueError("Polígono inválido: mínimo de 3 coordenadas necessário")
        return round(random.uniform(0.45, 0.85), 4)

    @staticmethod
    def calcular_carbono_estimado(area_hectares: float, ndvi: float) -> float:
        fator_captura = ndvi * 4.2
        return round(area_hectares * fator_captura, 2)

    @staticmethod
    def get_status_vegetacao(ndvi: float) -> str:
        if ndvi >= 0.65:
            return "Regenerando (Alta Densidade Vegetal)"
        elif ndvi >= 0.45:
            return "Estável (Cobertura Moderada)"
        return "Alerta de Degradação (Baixo Índice Vegetal)"

    @classmethod
    def gerar_hash_evidencia(
        cls, area_id: str, score: float, ndvi: float, timestamp: str
    ) -> str:
        payload = f"ID:{area_id}|SCORE:{score}|NDVI:{ndvi}|TIME:{timestamp}"
        return "0x" + hashlib.sha256(payload.encode()).hexdigest()

    @classmethod
    def gerar_prova_blockchain(
        cls, area_id: str, environmental_score: float, ndvi: float
    ) -> dict:
        timestamp = datetime.utcnow().strftime("%Y-%m-%d %H:%M:%S UTC")
        hash_evidencia = cls.gerar_hash_evidencia(area_id, environmental_score, ndvi, timestamp)
        tx_id = "0x" + hashlib.sha256(
            f"TX-{area_id}-{random.randint(100000, 999999)}".encode()
        ).hexdigest()
        return {
            "hash_evidencia": hash_evidencia,
            "transaction_id": tx_id,
            "block_number": random.randint(45800000, 45900000),
            "network": "Polygon PoS Mainnet (Simulado)",
            "timestamp": timestamp,
        }
