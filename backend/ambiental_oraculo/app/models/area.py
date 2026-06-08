import uuid
from datetime import datetime
from typing import List, Optional
from sqlalchemy import String, Float, DateTime, ForeignKey, JSON
from sqlalchemy.orm import Mapped, mapped_column, relationship
from app.database.session import Base


class Area(Base):
    __tablename__ = "areas"

    id: Mapped[str] = mapped_column(
        String(36), primary_key=True, default=lambda: str(uuid.uuid4())
    )
    user_id: Mapped[str] = mapped_column(
        String(36),
        ForeignKey("users.id", ondelete="CASCADE"),
        nullable=False,
        index=True,
    )
    nome: Mapped[str] = mapped_column(String(255), nullable=False)
    descricao: Mapped[Optional[str]] = mapped_column(String(1000), nullable=True)
    coordenadas: Mapped[list] = mapped_column(JSON, nullable=False)
    area_hectares: Mapped[float] = mapped_column(Float, nullable=False)
    created_at: Mapped[datetime] = mapped_column(
        DateTime, default=datetime.utcnow, nullable=False
    )

    user: Mapped["User"] = relationship("User", back_populates="areas")  # noqa: F821
    certificados: Mapped[List["Certificado"]] = relationship(  # noqa: F821
        "Certificado", back_populates="area", cascade="all, delete-orphan"
    )
