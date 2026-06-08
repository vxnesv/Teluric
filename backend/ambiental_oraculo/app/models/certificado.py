import uuid
from datetime import datetime
from sqlalchemy import String, Float, Integer, DateTime, ForeignKey
from sqlalchemy.orm import Mapped, mapped_column, relationship
from app.database.session import Base


class Certificado(Base):
    """
    Armazena a evidência criptográfica de cada análise ambiental.
    blockchain_status: 'pending' agora; futuramente 'anchored' quando integrado ao Polygon.
    """

    __tablename__ = "certificados"

    id: Mapped[str] = mapped_column(
        String(36), primary_key=True, default=lambda: str(uuid.uuid4())
    )
    user_id: Mapped[str] = mapped_column(
        String(36), ForeignKey("users.id"), nullable=False, index=True
    )
    area_id: Mapped[str] = mapped_column(
        String(36),
        ForeignKey("areas.id", ondelete="CASCADE"),
        nullable=False,
        index=True,
    )

    # Métricas ambientais
    ndvi_avg: Mapped[float] = mapped_column(Float, nullable=False)
    environmental_score: Mapped[float] = mapped_column(Float, nullable=False)
    carbono_estimado: Mapped[float] = mapped_column(Float, nullable=False)
    status_vegetacao: Mapped[str] = mapped_column(String(255), nullable=False)

    # Prova criptográfica (SHA-256 do payload da análise)
    hash_evidencia: Mapped[str] = mapped_column(String(66), unique=True, nullable=False)

    # Campos preparados para futura integração Polygon
    transaction_id_simulado: Mapped[str] = mapped_column(String(66), nullable=False)
    block_number_simulado: Mapped[int] = mapped_column(Integer, nullable=False)
    network_simulado: Mapped[str] = mapped_column(
        String(100), nullable=False, default="Polygon PoS Mainnet (Simulado)"
    )
    blockchain_anchored_at: Mapped[str] = mapped_column(String(50), nullable=False)
    blockchain_status: Mapped[str] = mapped_column(
        String(20), nullable=False, default="pending"
    )

    created_at: Mapped[datetime] = mapped_column(
        DateTime, default=datetime.utcnow, nullable=False
    )

    user: Mapped["User"] = relationship("User", back_populates="certificados")  # noqa: F821
    area: Mapped["Area"] = relationship("Area", back_populates="certificados")  # noqa: F821
