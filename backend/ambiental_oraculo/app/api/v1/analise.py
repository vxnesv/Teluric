from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from app.api.deps import get_db, get_current_user
from app.models.user import User
from app.schemas.analise import AnaliseRequest
from app.schemas.certificado import CertificadoResponse
from app.services import certificado_service

router = APIRouter(prefix="/analise", tags=["Análise NDVI"])


@router.post("/processar", response_model=CertificadoResponse)
def processar_analise(
    data: AnaliseRequest,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    return certificado_service.processar_analise(db, data.area_id, current_user.id)
