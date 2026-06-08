import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../../data/mock_data.dart';
import '../../data/services/auth_service.dart';
import '../../data/services/session_service.dart';
import '../auth/login_screen.dart';
import '../wallet/wallet_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildAppBar(context),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 120),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                const SizedBox(height: 20),
                _ImpactSection(),
                const SizedBox(height: 24),
                _WalletSection(),
                const SizedBox(height: 24),
                _SettingsSection(),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    final top = MediaQuery.of(context).padding.top;
    final user = SessionService.currentUser;

    return SliverAppBar(
      backgroundColor: AppColors.surface,
      expandedHeight: 210,
      pinned: true,
      stretch: true,
      flexibleSpace: FlexibleSpaceBar(
        stretchModes: const [StretchMode.blurBackground],
        background: Stack(
          children: [
            // Fundo gradiente
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF081018), AppColors.surface],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
            Positioned.fill(child: CustomPaint(painter: _OrbitalPainter())),
            Positioned(
              top: top + 30,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.secondary.withValues(alpha: 0.15),
                        blurRadius: 70,
                        spreadRadius: 20,
                      )
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: top + 10,
              right: 16,
              child: IconButton(
                icon: const Icon(Icons.notifications_outlined,
                    color: AppColors.textSecondary, size: 22),
                onPressed: () {},
              ),
            ),
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: Row(
                children: [
                  _AvatarWidget(),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Olá,',
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: FontWeight.w400,
                            color: AppColors.textSecondary,
                          ),
                        ),
                        Text(
                          user?.nome ?? 'Usuário',
                          style: GoogleFonts.orbitron(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textPrimary,
                            letterSpacing: 0.5,
                          ),
                        ),
                        // Data de cadastro (quando disponível)
                        if (user?.memberSince.isNotEmpty == true) ...[
                          const SizedBox(height: 2),
                          Text(
                            user!.memberSince,
                            style: GoogleFonts.inter(
                              fontSize: 10,
                              color: AppColors.textMuted,
                            ),
                          ),
                        ],
                        const SizedBox(height: 8),
                        // Badge de wallet (simulado por enquanto)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.06),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: AppColors.primary.withValues(alpha: 0.15),
                              width: 0.8,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 6,
                                height: 6,
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.primary
                                          .withValues(alpha: 0.6),
                                      blurRadius: 6,
                                      spreadRadius: 1,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Wallet conectada: ',
                                style: GoogleFonts.inter(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              Text(
                                '0xA81F...92C4',
                                style: GoogleFonts.orbitron(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimary,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                        )
                            .animate()
                            .fadeIn(duration: 400.ms, delay: 200.ms)
                            .scaleXY(
                                begin: 0.95,
                                end: 1.0,
                                duration: 400.ms,
                                delay: 200.ms),
                        const SizedBox(height: 4),
                      ],
                    ),
                  ),
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: AppColors.card,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.cardLight),
                    ),
                    child: const Icon(Icons.edit_outlined,
                        color: AppColors.textSecondary, size: 16),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      title: Text(
        'Perfil',
        style: GoogleFonts.orbitron(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
          letterSpacing: 1.5,
        ),
      ),
      centerTitle: true,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(0),
        child: Container(height: 0.5, color: AppColors.cardLight),
      ),
    );
  }
}

class _AvatarWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final initials = SessionService.currentUser?.initials ?? '?';
    return Container(
      width: 70,
      height: 70,
      padding: const EdgeInsets.all(2.5),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: AppColors.brandGradient,
        boxShadow: [
          BoxShadow(
            color: AppColors.secondary.withValues(alpha: 0.3),
            blurRadius: 18,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Container(
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.card,
        ),
        child: Center(
          child: Text(
            initials,
            style: GoogleFonts.orbitron(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
        ),
      ),
    );
  }
}

class _ImpactSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const double target = 10.0;
    final double progress = (totalCarbon / target).clamp(0.0, 1.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(title: 'Impacto Ambiental', icon: '🌍'),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: AppColors.cardGradient,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.cardLight),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: _ImpactTile(
                      emoji: '🌿',
                      value: '${totalCarbon.toStringAsFixed(1)}t',
                      label: 'CO₂ Sequestrado',
                      color: AppColors.primary,
                    ),
                  ),
                  Container(
                      width: 0.5, height: 50, color: AppColors.cardLight),
                  Expanded(
                    child: _ImpactTile(
                      emoji: '🛰️',
                      value: '36',
                      label: 'Imagens Orbitais',
                      color: AppColors.secondary,
                    ),
                  ),
                  Container(
                      width: 0.5, height: 50, color: AppColors.cardLight),
                  Expanded(
                    child: _ImpactTile(
                      emoji: '📍',
                      value: '12.4ha',
                      label: 'Área Monitorada',
                      color: AppColors.amber,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Meta anual de CO₂',
                    style: GoogleFonts.inter(
                        fontSize: 12, color: AppColors.textSecondary),
                  ),
                  Text(
                    '${totalCarbon.toStringAsFixed(1)} / ${target.toStringAsFixed(0)}t',
                    style: GoogleFonts.orbitron(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 6,
                  backgroundColor: AppColors.cardLight,
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    )
        .animate()
        .fadeIn(duration: 500.ms, delay: 300.ms)
        .slideY(begin: 0.1, end: 0, duration: 500.ms, delay: 300.ms);
  }
}

class _ImpactTile extends StatelessWidget {
  final String emoji;
  final String value;
  final String label;
  final Color color;

  const _ImpactTile({
    required this.emoji,
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(emoji, style: const TextStyle(fontSize: 22)),
        const SizedBox(height: 4),
        Text(
          value,
          style: GoogleFonts.orbitron(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          textAlign: TextAlign.center,
          style: GoogleFonts.inter(
            fontSize: 10,
            color: AppColors.textSecondary,
            height: 1.2,
          ),
        ),
      ],
    );
  }
}

class _WalletSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(title: 'Carteira Ambiental', icon: '💳'),
        const SizedBox(height: 12),
        GestureDetector(
          onTap: () {
            if (mockAreas.isNotEmpty) {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => WalletScreen(area: mockAreas.first),
                ),
              );
            }
          },
          child: Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.primary.withValues(alpha: 0.12),
                  AppColors.card,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.25)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Carteira Ambiental'.toUpperCase(),
                      style: GoogleFonts.orbitron(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                        letterSpacing: 1.0,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.cardLight),
                      ),
                      child: Text(
                        '0xA81...92F',
                        style: GoogleFonts.inter(
                          fontSize: 10,
                          color: AppColors.textMuted,
                          fontFeatures: const [FontFeature.tabularFigures()],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _WalletStat(
                      label: 'Ativos Ambientais',
                      value: '3',
                      color: AppColors.textPrimary,
                    ),
                    _WalletStat(
                      label: 'Impacto Acumulado',
                      value: '+12.4 tCO₂',
                      color: AppColors.primary,
                    ),
                    _WalletStat(
                      label: 'Certificados',
                      value: '5',
                      color: AppColors.amber,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    )
        .animate()
        .fadeIn(duration: 500.ms, delay: 400.ms)
        .slideY(begin: 0.1, end: 0, duration: 500.ms, delay: 400.ms);
  }
}

class _WalletStat extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _WalletStat({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 10,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: GoogleFonts.orbitron(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
      ],
    );
  }
}

class _SettingsSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final items = [
      _SettingsItem(
          icon: Icons.account_circle_outlined,
          label: 'Dados da Conta',
          sub: 'Editar dados de perfil',
          color: AppColors.secondary),
      _SettingsItem(
          icon: Icons.notifications_outlined,
          label: 'Notificações',
          sub: 'Preferências de notificações',
          color: AppColors.primary),
      _SettingsItem(
          icon: Icons.security_outlined,
          label: 'Segurança',
          sub: 'Senha e autenticação',
          color: AppColors.amber),
      _SettingsItem(
          icon: Icons.help_outline_rounded,
          label: 'Suporte',
          sub: 'Central de ajuda e documentação',
          color: AppColors.textSecondary),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(title: 'Configurações', icon: '⚙️'),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: AppColors.card,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.cardLight),
          ),
          child: Column(
            children: items.asMap().entries.map((entry) {
              final i = entry.key;
              final item = entry.value;
              final isLast = i == items.length - 1;
              return Column(
                children: [
                  _SettingsTile(item: item),
                  if (!isLast)
                    const Divider(
                        height: 0,
                        color: AppColors.cardLight,
                        indent: 56),
                ],
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 16),

        // ── Botão Sair (logout real)
        GestureDetector(
          onTap: () async {
            await AuthService.logout();
            if (context.mounted) {
              Navigator.of(context).pushAndRemoveUntil(
                PageRouteBuilder(
                  pageBuilder: (_, __, ___) => const LoginScreen(),
                  transitionsBuilder: (_, a, __, child) =>
                      FadeTransition(opacity: a, child: child),
                  transitionDuration: const Duration(milliseconds: 500),
                ),
                (route) => false,
              );
            }
          },
          child: Container(
            width: double.infinity,
            height: 52,
            decoration: BoxDecoration(
              gradient: AppColors.brandGradient,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: AppColors.secondary.withValues(alpha: 0.25),
                  blurRadius: 20,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.logout_rounded, color: Colors.black, size: 18),
                const SizedBox(width: 8),
                Text(
                  'Sair',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    )
        .animate()
        .fadeIn(duration: 500.ms, delay: 600.ms)
        .slideY(begin: 0.1, end: 0, duration: 500.ms, delay: 600.ms);
  }
}

class _SettingsItem {
  final IconData icon;
  final String label;
  final String sub;
  final Color color;
  final bool isDanger;

  const _SettingsItem({
    required this.icon,
    required this.label,
    required this.sub,
    required this.color,
    this.isDanger = false,
  });
}

class _SettingsTile extends StatelessWidget {
  final _SettingsItem item;
  const _SettingsTile({required this.item});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: item.color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(item.icon, color: item.color, size: 18),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.label,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: item.isDanger
                          ? AppColors.danger
                          : AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    item.sub,
                    style: GoogleFonts.inter(
                      fontSize: 11,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color:
                  item.isDanger ? AppColors.danger : AppColors.textMuted,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final String icon;

  const _SectionHeader({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(icon, style: const TextStyle(fontSize: 16)),
        const SizedBox(width: 8),
        Text(
          title.toUpperCase(),
          style: GoogleFonts.orbitron(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: AppColors.textSecondary,
            letterSpacing: 1.8,
          ),
        ),
      ],
    );
  }
}

class _OrbitalPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5
      ..color = AppColors.primary.withValues(alpha: 0.08);

    final cx = size.width / 2;
    const cy = 70.0;
    for (int i = 0; i < 3; i++) {
      final r = 80.0 + i * 30;
      canvas.drawCircle(Offset(cx, cy), r, paint);

      if (i == 1) {
        final dotPaint = Paint()
          ..style = PaintingStyle.fill
          ..color = AppColors.primary.withValues(alpha: 0.35);
        final angle = math.pi * 0.7;
        canvas.drawCircle(
          Offset(cx + r * math.cos(angle), cy + r * math.sin(angle)),
          2.5,
          dotPaint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
