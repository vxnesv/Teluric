import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../../data/mock_data.dart';

class CertificateScreen extends StatefulWidget {
  final AreaModel area;
  const CertificateScreen({super.key, required this.area});
  @override
  State<CertificateScreen> createState() => _CertificateScreenState();
}

class _CertificateScreenState extends State<CertificateScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _shimmerCtrl;

  AreaModel get area => widget.area;

  String get _hash {
    final hex = area.id.hashCode.abs().toRadixString(16).padLeft(8, '0');
    return '0x4A3F...${hex.substring(0, 8).toUpperCase()}';
  }
  
  String get _coords {
    final c = area.polygon[0];
    return '${c.latitude.toStringAsFixed(5)}°S, ${c.longitude.toStringAsFixed(5)}°W';
  }

  @override
  void initState() {
    super.initState();
    _shimmerCtrl = AnimationController(
        vsync: this, duration: const Duration(seconds: 3))
      ..repeat();
  }

  @override
  void dispose() {
    _shimmerCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Ativo Ambiental'),
        actions: [
          IconButton(
            icon: const Icon(Icons.ios_share_rounded),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // ── Certificate card
            AnimatedBuilder(
              animation: _shimmerCtrl,
              builder: (_, __) => _CertCard(
                area: area,
                hash: _hash,
                coords: _coords,
                shimmer: _shimmerCtrl.value,
              ),
            ).animate().fadeIn(duration: 600.ms).scale(
                begin: const Offset(0.92, 0.92),
                duration: 600.ms,
                curve: Curves.easeOut),

            const SizedBox(height: 24),

            _InfoRow(
              label: 'Hash do Bloco',
              value: _hash,
              icon: Icons.link_rounded,
              mono: true,
            ).animate().fadeIn(delay: 300.ms),
            const SizedBox(height: 8),
            _InfoRow(
              label: 'Timestamp',
              value: '2025-05-01 · 09:42:17 UTC',
              icon: Icons.access_time_rounded,
            ).animate().fadeIn(delay: 380.ms),
            const SizedBox(height: 8),
            _InfoRow(
              label: 'Coordenadas',
              value: _coords,
              icon: Icons.location_on_outlined,
              mono: true,
            ).animate().fadeIn(delay: 460.ms),
            const SizedBox(height: 8),
            _InfoRow(
              label: 'Score Ambiental',
              value: '${area.scoreEnv.toInt()} / 100',
              icon: Icons.eco_rounded,
              valueColor: AppColors.primary,
            ).animate().fadeIn(delay: 540.ms),
            const SizedBox(height: 8),
            _InfoRow(
              label: 'Carbono Estimado',
              value: '+${area.carbonEstimate.toStringAsFixed(1)}t CO₂/ano',
              icon: Icons.cloud_outlined,
              valueColor: AppColors.secondary,
            ).animate().fadeIn(delay: 620.ms),

            const SizedBox(height: 24),

            Container(
              width: double.infinity,
              height: 52,
              decoration: BoxDecoration(
                gradient: AppColors.brandGradient,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.3),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: TextButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.satellite_alt_rounded,
                    color: Colors.black, size: 18),
                label: Text(
                  'Ver prova espacial',
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
              ),
            ).animate().fadeIn(delay: 700.ms).slideY(begin: 0.2, end: 0),

            const SizedBox(height: 12),

            OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.download_rounded, size: 17),
              label: const Text('Baixar PDF'),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
                side: const BorderSide(color: AppColors.cardLight),
              ),
            ).animate().fadeIn(delay: 780.ms),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

class _CertCard extends StatelessWidget {
  final AreaModel area;
  final String hash;
  final String coords;
  final double shimmer;
  const _CertCard({
    required this.area,
    required this.hash,
    required this.coords,
    required this.shimmer,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
            color: AppColors.amber.withOpacity(0.5), width: 1),
        gradient: const LinearGradient(
          colors: [Color(0xFF111C2C), Color(0xFF0D1520)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.amber.withOpacity(0.12),
            blurRadius: 30,
            spreadRadius: 2,
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            // Shimmer overlay
            Positioned.fill(
              child: CustomPaint(
                painter: _ShimmerPainter(shimmer),
              ),
            ),

            // Content
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'TELURIC',
                            style: GoogleFonts.orbitron(
                              fontSize: 13,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 3,
                              color: AppColors.amber,
                            ),
                          ),
                          Text(
                            'Spatial Environmental Intelligence',
                            style: GoogleFonts.inter(
                              fontSize: 8,
                              color: AppColors.textMuted,
                              letterSpacing: 1,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.amber.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                              color: AppColors.amber.withOpacity(0.4), width: 0.5),
                        ),
                        child: Text(
                          'TEL 001',
                          style: GoogleFonts.orbitron(
                            fontSize: 8,
                            color: AppColors.amber,
                            letterSpacing: 1.5,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  Row(children: [
                    Expanded(
                        child: Container(
                            height: 0.5, color: AppColors.amber.withOpacity(0.3))),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Icon(Icons.verified_rounded,
                          color: AppColors.amber.withOpacity(0.7), size: 16),
                    ),
                    Expanded(
                        child: Container(
                            height: 0.5, color: AppColors.amber.withOpacity(0.3))),
                  ]),

                  const SizedBox(height: 20),

                  Text(
                    area.name,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${area.category.emoji} ${area.category.label}',
                    style: GoogleFonts.inter(
                        fontSize: 12, color: AppColors.textSecondary),
                  ),

                  const SizedBox(height: 20),

                  Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(colors: [
                        AppColors.primary.withOpacity(0.2),
                        AppColors.primary.withOpacity(0.04),
                      ]),
                      border: Border.all(
                          color: AppColors.primary.withOpacity(0.6), width: 1.5),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${area.scoreEnv.toInt()}',
                          style: GoogleFonts.orbitron(
                            fontSize: 28,
                            fontWeight: FontWeight.w900,
                            color: AppColors.primary,
                          ),
                        ),
                        Text(
                          'SCORE',
                          style: GoogleFonts.orbitron(
                              fontSize: 8, color: AppColors.textMuted, letterSpacing: 2),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  Row(
                    children: [
                      Container(
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                              color: AppColors.cardLight, width: 0.5),
                        ),
                        child: CustomPaint(painter: _QrPainter()),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _CertRow('NDVI', '+${area.ndviChange.toInt()}%'),
                            _CertRow('Carbono', '+${area.carbonEstimate.toStringAsFixed(1)}t/ano'),
                            _CertRow('Emissão', '01/05/2025'),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                          color: AppColors.textMuted.withOpacity(0.3), width: 0.5),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.link_rounded,
                            color: AppColors.textMuted, size: 14),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            hash,
                            style: GoogleFonts.robotoMono(
                              fontSize: 10,
                              color: AppColors.textSecondary,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                        const Icon(Icons.content_copy_rounded,
                            color: AppColors.textMuted, size: 14),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  Text(
                    'Assinatura Digital Verificada por Teluric v1.0',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                        fontSize: 9, color: AppColors.textMuted, letterSpacing: 0.5),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CertRow extends StatelessWidget {
  final String label;
  final String value;
  const _CertRow(this.label, this.value);
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: Row(children: [
          Expanded(
            child: Text(
              label,
              style: GoogleFonts.inter(
                  fontSize: 10, color: AppColors.textMuted),
            ),
          ),
          Text(
            value,
            style: GoogleFonts.inter(
              fontSize: 11,
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ]),
      );
}

class _ShimmerPainter extends CustomPainter {
  final double t;
  _ShimmerPainter(this.t);

  @override
  void paint(Canvas canvas, Size size) {
    final x = -size.width + 3 * size.width * t;
    final paint = Paint()
      ..shader = LinearGradient(
        colors: [
          Colors.transparent,
          AppColors.amber.withOpacity(0.04),
          AppColors.primary.withOpacity(0.07),
          Colors.transparent,
        ],
        stops: const [0, 0.4, 0.6, 1],
        transform: GradientRotation(math.pi / 4),
      ).createShader(
          Rect.fromLTWH(x, 0, size.width * 0.4, size.height));
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);
  }

  @override
  bool shouldRepaint(_ShimmerPainter old) => old.t != t;
}

class _QrPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = AppColors.primary.withOpacity(0.7)
      ..style = PaintingStyle.fill;
    final s = size.width / 6;
    const positions = [
      [0, 0], [0, 1], [0, 2], [1, 0], [2, 0],
      [0, 4], [0, 5], [1, 5], [2, 5],
      [4, 0], [5, 0], [5, 1], [5, 2],
      [2, 2], [3, 3], [4, 4], [2, 4], [3, 5],
      [4, 2], [3, 1], [1, 3], [2, 3],
    ];
    for (final pos in positions) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(pos[1] * s + 1, pos[0] * s + 1, s - 2, s - 2),
          const Radius.circular(1),
        ),
        p,
      );
    }
  }

  @override
  bool shouldRepaint(_QrPainter old) => false;
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color? valueColor;
  final bool mono;
  const _InfoRow({
    required this.label,
    required this.value,
    required this.icon,
    this.valueColor,
    this.mono = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.cardLight, width: 0.5),
      ),
      child: Row(children: [
        Icon(icon, color: AppColors.textSecondary, size: 16),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: GoogleFonts.inter(
                      fontSize: 10, color: AppColors.textMuted)),
              Text(
                value,
                style: mono
                    ? GoogleFonts.robotoMono(
                        fontSize: 11,
                        color: valueColor ?? AppColors.textPrimary,
                        fontWeight: FontWeight.w500)
                    : GoogleFonts.inter(
                        fontSize: 12,
                        color: valueColor ?? AppColors.textPrimary,
                        fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ]),
    );
  }
}
