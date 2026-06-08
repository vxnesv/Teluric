import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../../data/mock_data.dart';
import '../wallet/certificate_screen.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key, required AreaModel area});

  @override
  Widget build(BuildContext context) {
    // Carrega a lista do mockData
    final ativos = mockAreas;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildAppBar(context),

          // Seção Fixa Superior: Resumos e Título
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Grid de Resumos (Cards de contadores)
                  _buildSummaryGrid(),
                  const SizedBox(height: 32),

                  // 2. Título da Seção de Ativos
                  _buildSectionHeader('Ativos Ambientais em Custódia', '🌿'),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),

          // 3. Renderização Dinâmica dos Ativos como Slivers (Evita erros de Layout/RenderBox)
          if (ativos.isEmpty)
            SliverToBoxAdapter(child: _buildEmptyState())
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 120),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                      (context, index) {
                    final area = ativos[index];
                    final assetId = 'TEL-${(index + 1).toString().padLeft(3, '0')}';

                    // Retorna o card com um pequeno espaçamento inferior para simular o separator
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: _buildAssetCard(context, area, assetId, index),
                    );
                  },
                  childCount: ativos.length,
                ),
              ),
            ),
        ],
      ),
    );
  }

  // Header com visual Web3, Endereço Cripto e Status da Rede
  Widget _buildAppBar(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    return SliverAppBar(
      expandedHeight: 220,
      collapsedHeight: 80,
      pinned: true,
      backgroundColor: AppColors.background.withOpacity(0.8),
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.textPrimary, size: 20),
        onPressed: () => Navigator.of(context).pop(),
      ),
      flexibleSpace: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: FlexibleSpaceBar(
            background: Container(
              padding: EdgeInsets.fromLTRB(20, topPadding + 50, 20, 20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.primary.withOpacity(0.08), Colors.transparent],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'CARTEIRA DIGITAL',
                    style: GoogleFonts.inter(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                      letterSpacing: 2.0,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Wallet Ambiental',
                    style: GoogleFonts.orbitron(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      _buildNetworkBadge('Polygon', Colors.purple),
                      const SizedBox(width: 8),
                      _buildAddressBadge('0xA81F....92C4'),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Grid de Resumo com os 3 Metadados Consolidados
  Widget _buildSummaryGrid() {
    return Row(
      children: [
        Expanded(child: _buildSummaryCard('Ativos', '3', AppColors.textPrimary)),
        const SizedBox(width: 10),
        Expanded(child: _buildSummaryCard('Certificados', '3', AppColors.textPrimary)),
        const SizedBox(width: 10),
        Expanded(child: _buildSummaryCard('Impacto Total', '+12.3 tCO₂', AppColors.primary)),
      ],
    ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.05, end: 0);
  }

  Widget _buildSummaryCard(String label, String value, Color valueColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors:[
            AppColors.primary.withOpacity(0.08),
            AppColors.card.withOpacity(0.08),
          ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.primary, width: 0.4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 10,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.orbitron(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }

  // Card do Ativo Ambiental (Espelhado no visual de Certificados)
  Widget _buildAssetCard(BuildContext context, dynamic area, String id, int index) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => CertificateScreen(area: area),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors:[
              AppColors.background,
              AppColors.secondary.withOpacity(0.04),
            ],),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.secondary, width: 0.8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    '$id',
                    style: GoogleFonts.orbitron(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                Icon(
                  Icons.token_outlined,
                  size: 16,
                  color: AppColors.textMuted.withOpacity(0.5),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // CORREÇÃO: Alterado de area.title para area.name
            Text(
              area.name,
              style: GoogleFonts.inter(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                // CORREÇÃO: Alterado de area.score para area.scoreEnv
                _buildAssetMetric('Score', '${area.scoreEnv.toInt()}'),
                const SizedBox(width: 24),
                // CORREÇÃO: Usando o estimador de carbono que já existe no seu modelo
                _buildAssetMetric('Carbono Est.', '${area.carbonEstimate}t'),
                const Spacer(),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Verificar',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.arrow_forward,
                      size: 14,
                      color: AppColors.primary,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    )
        .animate()
        .fadeIn(duration: 400.ms, delay: (100 * index).ms)
        .slideX(begin: 0.05, end: 0, duration: 400.ms, delay: (100 * index).ms);
  }

  Widget _buildAssetMetric(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(fontSize: 10, color: AppColors.textMuted),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: GoogleFonts.orbitron(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildNetworkBadge(String name, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3), width: 0.8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          Text(
            name,
            style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.textPrimary),
          ),
        ],
      ),
    );
  }

  Widget _buildAddressBadge(String address) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.cardLight, width: 0.8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            address,
            style: GoogleFonts.inter(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, String icon) {
    return Row(
      children: [
        Text(icon, style: const TextStyle(fontSize: 14)),
        const SizedBox(width: 8),
        Text(
          title.toUpperCase(),
          style: GoogleFonts.orbitron(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: AppColors.textMuted,
            letterSpacing: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Text(
          'Nenhum ativo ambiental tokenizado encontrado.',
          style: GoogleFonts.inter(color: AppColors.textMuted, fontSize: 13),
        ),
      ),
    );
  }
}