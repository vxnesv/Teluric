from pydantic import BaseModel


class AnaliseRequest(BaseModel):
    area_id: str
