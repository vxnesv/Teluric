from datetime import datetime
from typing import List, Optional
from pydantic import BaseModel, field_validator


class AreaCreate(BaseModel):
    nome: str
    descricao: Optional[str] = None
    coordenadas: List[List[float]]
    area_hectares: float

    @field_validator("coordenadas")
    @classmethod
    def coordenadas_min_pontos(cls, v: List[List[float]]) -> List[List[float]]:
        if len(v) < 3:
            raise ValueError("São necessários pelo menos 3 pontos para definir uma área")
        return v

    @field_validator("area_hectares")
    @classmethod
    def area_positiva(cls, v: float) -> float:
        if v <= 0:
            raise ValueError("Área em hectares deve ser maior que zero")
        return v


class AreaResponse(BaseModel):
    id: str
    user_id: str
    nome: str
    descricao: Optional[str]
    coordenadas: List[List[float]]
    area_hectares: float
    created_at: datetime

    model_config = {"from_attributes": True}
