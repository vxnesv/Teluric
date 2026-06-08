from typing import List
from fastapi import HTTPException, status
from sqlalchemy.orm import Session
from app.models.area import Area
from app.models.certificado import Certificado
from app.services.oraculo_service import OraculoService


def processar_analise(db: Session, area_id: str, user_id: str) -> Certificado:
    area = (
        db.query(Area)
        .filter(Area.id == area_id, Area.user_id == user_id)
        .first()
    )
    if not area:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Área não encontrada")

    ndvi = OraculoService.calcular_ndvi(area.coordenadas)
    carbono = OraculoService.calcular_carbono_estimado(area.area_hectares, ndvi)
    status_veg = OraculoService.get_status_vegetacao(ndvi)
    score = round(ndvi * 100, 1)
    prova = OraculoService.gerar_prova_blockchain(area_id, score, ndvi)

    certificado = Certificado(
        user_id=user_id,
        area_id=area_id,
        ndvi_avg=ndvi,
        environmental_score=score,
        carbono_estimado=carbono,
        status_vegetacao=status_veg,
        hash_evidencia=prova["hash_evidencia"],
        transaction_id_simulado=prova["transaction_id"],
        block_number_simulado=prova["block_number"],
        network_simulado=prova["network"],
        blockchain_anchored_at=prova["timestamp"],
        blockchain_status="pending",
    )
    db.add(certificado)
    db.commit()
    db.refresh(certificado)
    return certificado


def get_certificados_by_user(db: Session, user_id: str) -> List[Certificado]:
    return (
        db.query(Certificado)
        .filter(Certificado.user_id == user_id)
        .order_by(Certificado.created_at.desc())
        .all()
    )


def get_certificado_by_id(db: Session, cert_id: str, user_id: str) -> Certificado:
    cert = (
        db.query(Certificado)
        .filter(Certificado.id == cert_id, Certificado.user_id == user_id)
        .first()
    )
    if not cert:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND, detail="Certificado não encontrado"
        )
    return cert
