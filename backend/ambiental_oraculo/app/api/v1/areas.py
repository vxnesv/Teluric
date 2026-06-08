from typing import List
from fastapi import APIRouter, Depends, status
from sqlalchemy.orm import Session
from app.api.deps import get_db, get_current_user
from app.models.user import User
from app.schemas.area import AreaCreate, AreaResponse
from app.services import area_service

router = APIRouter(prefix="/areas", tags=["Áreas Ambientais"])


@router.post("/", response_model=AreaResponse, status_code=status.HTTP_201_CREATED)
def create_area(
    data: AreaCreate,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    return area_service.create_area(db, current_user.id, data)


@router.get("/", response_model=List[AreaResponse])
def list_areas(
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    return area_service.get_areas_by_user(db, current_user.id)


@router.get("/{area_id}", response_model=AreaResponse)
def get_area(
    area_id: str,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    return area_service.get_area_by_id(db, area_id, current_user.id)


@router.delete("/{area_id}", status_code=status.HTTP_204_NO_CONTENT)
def delete_area(
    area_id: str,
    db: Session = Depends(get_db),
    current_user: User = Depends(get_current_user),
):
    area_service.delete_area(db, area_id, current_user.id)
