from typing import List
from fastapi import APIRouter, Depends
from sqlalchemy.orm import Session
from app.api.deps import get_db, get_current_user
from app.models.user import User
from app.schemas.certificado import CertificadoResponse
from app.services import certificado_service

router = APIRouter(prefix="/certificados", tags=["Certificados Ambientais"])


@router.get("/", response_model=List[CertificadoResponse])
def list_certificados(
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    return certificado_service.get_certificados_by_user(db, current_user.id)


@router.get("/{cert_id}", response_model=CertificadoResponse)
def get_certificado(
    cert_id: str,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    return certificado_service.get_certificado_by_id(db, cert_id, current_user.id)
