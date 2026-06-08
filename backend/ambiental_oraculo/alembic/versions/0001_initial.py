"""Criação inicial das tabelas: users, areas, certificados

Revision ID: 0001
Revises:
Create Date: 2024-01-01 00:00:00.000000
"""
from typing import Sequence, Union

from alembic import op
import sqlalchemy as sa

revision: str = "0001"
down_revision: Union[str, None] = None
branch_labels: Union[str, Sequence[str], None] = None
depends_on: Union[str, Sequence[str], None] = None


def upgrade() -> None:
    op.create_table(
        "users",
        sa.Column("id", sa.String(36), primary_key=True),
        sa.Column("email", sa.String(255), unique=True, nullable=False),
        sa.Column("nome", sa.String(255), nullable=False),
        sa.Column("hashed_password", sa.String(255), nullable=False),
        sa.Column("is_active", sa.Boolean, nullable=False, server_default=sa.true()),
        sa.Column("created_at", sa.DateTime, nullable=False, server_default=sa.func.now()),
    )
    op.create_index("ix_users_email", "users", ["email"])

    op.create_table(
        "areas",
        sa.Column("id", sa.String(36), primary_key=True),
        sa.Column(
            "user_id",
            sa.String(36),
            sa.ForeignKey("users.id", ondelete="CASCADE"),
            nullable=False,
        ),
        sa.Column("nome", sa.String(255), nullable=False),
        sa.Column("descricao", sa.String(1000), nullable=True),
        sa.Column("coordenadas", sa.JSON, nullable=False),
        sa.Column("area_hectares", sa.Float, nullable=False),
        sa.Column("created_at", sa.DateTime, nullable=False, server_default=sa.func.now()),
    )
    op.create_index("ix_areas_user_id", "areas", ["user_id"])

    op.create_table(
        "certificados",
        sa.Column("id", sa.String(36), primary_key=True),
        sa.Column("user_id", sa.String(36), sa.ForeignKey("users.id"), nullable=False),
        sa.Column(
            "area_id",
            sa.String(36),
            sa.ForeignKey("areas.id", ondelete="CASCADE"),
            nullable=False,
        ),
        sa.Column("ndvi_avg", sa.Float, nullable=False),
        sa.Column("environmental_score", sa.Float, nullable=False),
        sa.Column("carbono_estimado", sa.Float, nullable=False),
        sa.Column("status_vegetacao", sa.String(255), nullable=False),
        sa.Column("hash_evidencia", sa.String(66), unique=True, nullable=False),
        sa.Column("transaction_id_simulado", sa.String(66), nullable=False),
        sa.Column("block_number_simulado", sa.Integer, nullable=False),
        sa.Column("network_simulado", sa.String(100), nullable=False),
        sa.Column("blockchain_anchored_at", sa.String(50), nullable=False),
        sa.Column(
            "blockchain_status",
            sa.String(20),
            nullable=False,
            server_default=sa.literal("pending"),
        ),
        sa.Column("created_at", sa.DateTime, nullable=False, server_default=sa.func.now()),
    )
    op.create_index("ix_certificados_user_id", "certificados", ["user_id"])
    op.create_index("ix_certificados_area_id", "certificados", ["area_id"])


def downgrade() -> None:
    op.drop_table("certificados")
    op.drop_table("areas")
    op.drop_table("users")
