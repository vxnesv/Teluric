from datetime import datetime
from pydantic import BaseModel


class CertificadoResponse(BaseModel):
    id: str
    user_id: str
    area_id: str
    ndvi_avg: float
    environmental_score: float
    carbono_estimado: float
    status_vegetacao: str
    hash_evidencia: str
    transaction_id_simulado: str
    block_number_simulado: int
    network_simulado: str
    blockchain_anchored_at: str
    blockchain_status: str
    created_at: datetime

    model_config = {"from_attributes": True}
