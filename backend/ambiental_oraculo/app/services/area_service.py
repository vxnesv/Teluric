from typing import List
from fastapi import HTTPException, status
from sqlalchemy.orm import Session
from app.models.area import Area
from app.schemas.area import AreaCreate


def create_area(db: Session, user_id: str, data: AreaCreate) -> Area:
    area = Area(user_id=user_id, **data.model_dump())
    db.add(area)
    db.commit()
    db.refresh(area)
    return area


def get_areas_by_user(db: Session, user_id: str) -> List[Area]:
    return (
        db.query(Area)
        .filter(Area.user_id == user_id)
        .order_by(Area.created_at.desc())
        .all()
    )


def get_area_by_id(db: Session, area_id: str, user_id: str) -> Area:
    area = (
        db.query(Area)
        .filter(Area.id == area_id, Area.user_id == user_id)
        .first()
    )
    if not area:
        raise HTTPException(status_code=status.HTTP_404_NOT_FOUND, detail="Área não encontrada")
    return area


def delete_area(db: Session, area_id: str, user_id: str) -> None:
    area = get_area_by_id(db, area_id, user_id)
    db.delete(area)
    db.commit()
