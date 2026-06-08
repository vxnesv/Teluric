import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../../data/mock_data.dart';
import '../area/area_detail_screen.dart';
import '../wallet/certificate_screen.dart';

class AreaSelectionScreen extends StatefulWidget {
  const AreaSelectionScreen({super.key});
  @override
  State<AreaSelectionScreen> createState() => _AreaSelectionScreenState();
}

class _AreaSelectionScreenState extends State<AreaSelectionScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabCtrl;

  @override
  void initState() {
    super.initState();
    _tabCtrl = TabController(length: 2, vsync: this);
    _tabCtrl.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _tabCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.of(context).padding.top;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          _buildHeader(top),
          _buildTabBar(),
          Expanded(
            child: TabBarView(
              controller: _tabCtrl,
              children: [
                _AreaList(areas: mockAreas, shared: false),
                _AreaList(areas: mockAreas.sublist(0, 1), shared: true),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(double top) {
    return Container(
      padding: EdgeInsets.fromLTRB(20, top + 14, 20, 14),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(bottom: BorderSide(color: AppColors.cardLight, width: 0.5)),
      ),
      child: Row(
        children: [
          Text(
            'Áreas',
            style: GoogleFonts.orbitron(
              fontSize: 18, fontWeight: FontWeight.w700,
              color: AppColors.textPrimary, letterSpacing: 1.5,
            ),
          ),
          const SizedBox(width: 10),

          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              gradient: AppColors.brandGradient,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              '${mockAreas.length}',
              style: GoogleFonts.orbitron(
                  fontSize: 10, fontWeight: FontWeight.w700, color: Colors.black),
            ),
          ),

        ],
      ),
    );
  }


  Widget _buildTabBar() {
    return Container(
      color: AppColors.surface,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
      child: TabBar(
        controller: _tabCtrl,
        labelStyle: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w700),
        unselectedLabelStyle: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w400),
        labelColor: AppColors.primary,
        unselectedLabelColor: AppColors.textSecondary,
        indicatorColor: AppColors.primary,
        indicatorWeight: 2,
        indicatorSize: TabBarIndicatorSize.label,
        splashFactory: NoSplash.splashFactory,
        tabs: const [
          Tab(text: 'Minhas áreas'),
          Tab(text: 'Compartilhadas'),
        ],
      ),
    );
  }
}

class _AreaList extends StatelessWidget {
  final List<AreaModel> areas;
  final bool shared;
  const _AreaList({required this.areas, required this.shared});

  @override
  Widget build(BuildContext context) {
    if (areas.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('🔗', style: TextStyle(fontSize: 40)),
            const SizedBox(height: 12),
            Text(
              'Nenhuma área compartilhada',
              style: GoogleFonts.inter(color: AppColors.textSecondary),
            ),
          ],
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
      itemCount: areas.length,
      itemBuilder: (context, i) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: _AreaCard(area: areas[i], index: i),
      ),
    );
  }
}

class _AreaCard extends StatelessWidget {
  final AreaModel area;
  final int index;
  const _AreaCard({required this.area, required this.index});

  Color get _statusColor {
    switch (area.status) {
      case RegenerationStatus.growing: return AppColors.primary;
      case RegenerationStatus.stable:  return AppColors.secondary;
      case RegenerationStatus.atRisk:  return AppColors.danger;
    }
  }

  String get _statusLabel {
    switch (area.status) {
      case RegenerationStatus.growing: return 'Crescendo';
      case RegenerationStatus.stable:  return 'Estável';
      case RegenerationStatus.atRisk:  return 'Em Risco';
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => AreaDetailScreen(area: area)),
      ),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.cardLight),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(14),
              child: Row(
                children: [
                  _AreaThumbnail(area: area),
                  const SizedBox(width: 14),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                area.name,
                                style: GoogleFonts.inter(
                                  fontSize: 14, fontWeight: FontWeight.w700,
                                  color: AppColors.textPrimary),
                              ),
                            ),

                            Text(
                              area.scoreEnv.toInt().toString(),
                              style: GoogleFonts.orbitron(
                                fontSize: 18, fontWeight: FontWeight.w700,
                                color: _statusColor),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          area.category.label,
                          style: GoogleFonts.inter(
                            fontSize: 11, color: AppColors.textSecondary),
                        ),
                        const SizedBox(height: 8),

                        Row(children: [
                          _MiniStat(label: 'Área', value: '${(index + 1) * 3}.${index + 1}km²',
                              color: AppColors.secondary),
                          const SizedBox(width: 10),
                          _MiniStat(label: 'CO₂', value: '${area.carbonEstimate}t',
                              color: AppColors.primary),
                          const SizedBox(width: 10),
                          _MiniStat(label: 'NDVI', value: '+${area.ndviChange}%',
                              color: AppColors.amber),
                        ]),
                      ],
                    ),
                  ),

                  const SizedBox(width: 10),

                  _QrButton(
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => CertificateScreen(area: area)),
                    ),
                  ),
                ],
              ),
            ),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: _statusColor.withOpacity(0.06),
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16)),
                border: Border(top: BorderSide(color: _statusColor.withOpacity(0.2))),
              ),
              child: Row(
                children: [
                  Container(
                    width: 6, height: 6,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle, color: _statusColor,
                      boxShadow: [BoxShadow(color: _statusColor.withOpacity(0.5), blurRadius: 4)],
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    _statusLabel,
                    style: GoogleFonts.inter(
                      fontSize: 10, fontWeight: FontWeight.w600, color: _statusColor),
                  ),
                  const Spacer(),
                  Icon(Icons.access_time_rounded, size: 10, color: AppColors.textMuted),
                  const SizedBox(width: 4),
                  Text(
                    'Atualizado ${area.lastUpdate}',
                    style: GoogleFonts.inter(fontSize: 10, color: AppColors.textMuted),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    )
        .animate()
        .fadeIn(duration: 400.ms, delay: Duration(milliseconds: 80 * index))
        .slideY(begin: 0.12, end: 0, duration: 400.ms, delay: Duration(milliseconds: 80 * index));
  }
}

class _AreaThumbnail extends StatelessWidget {
  final AreaModel area;
  const _AreaThumbnail({required this.area});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 72,
      height: 72,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withOpacity(0.25),
            AppColors.secondary.withOpacity(0.12),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: AppColors.primary.withOpacity(0.35)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            CustomPaint(
              size: const Size(72, 72),
              painter: _GridThumbnailPainter(),
            ),
            CustomPaint(
              size: const Size(72, 72),
              painter: _PolygonMiniPainter(),
            ),
            Center(
              child: Text(area.category.emoji,
                style: const TextStyle(fontSize: 22)),
            ),
          ],
        ),
      ),
    );
  }
}

class _GridThumbnailPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primary.withOpacity(0.12)
      ..strokeWidth = 0.5;
    const step = 12.0;
    for (double x = 0; x <= size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y <= size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }
  @override bool shouldRepaint(_) => false;
}

class _PolygonMiniPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primary.withOpacity(0.35)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    final path = Path()
      ..moveTo(size.width * 0.3, size.height * 0.15)
      ..lineTo(size.width * 0.75, size.height * 0.20)
      ..lineTo(size.width * 0.82, size.height * 0.65)
      ..lineTo(size.width * 0.45, size.height * 0.82)
      ..lineTo(size.width * 0.18, size.height * 0.60)
      ..close();
    canvas.drawPath(path, paint..style = PaintingStyle.fill
      ..color = AppColors.primary.withOpacity(0.15));
    canvas.drawPath(path, paint..style = PaintingStyle.stroke
      ..color = AppColors.primary.withOpacity(0.5));
  }
  @override bool shouldRepaint(_) => false;
}

class _QrButton extends StatelessWidget {
  final VoidCallback onTap;
  const _QrButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 48, height: 48,
            decoration: BoxDecoration(
              color: AppColors.secondary.withOpacity(0.10),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.secondary.withOpacity(0.30)),
            ),
            child: CustomPaint(painter: _QrMiniPainter()),
          ),
          const SizedBox(height: 4),
          Text(
            'Cert.',
            style: GoogleFonts.inter(
              fontSize: 9, color: AppColors.secondary, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

class _QrMiniPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.secondary.withOpacity(0.7)
      ..style = PaintingStyle.fill;
    final m = size.width * 0.15;
    final b = size.width * 0.28;

    void sq(double x, double y, double s) =>
        canvas.drawRRect(RRect.fromRectAndRadius(
          Rect.fromLTWH(x, y, s, s), const Radius.circular(1.5)), paint);

    sq(m, m, b); sq(size.width - m - b, m, b); sq(m, size.height - m - b, b);

    final dp = Paint()..color = AppColors.secondary.withOpacity(0.9)..style = PaintingStyle.fill;
    final ds = b * 0.4;
    final db = b * 0.3;
    sq(m + db, m + db, ds);
    sq(size.width - m - b + db, m + db, ds);
    sq(m + db, size.height - m - b + db, ds);

    final dots = [
      Offset(size.width * 0.5, size.height * 0.4),
      Offset(size.width * 0.6, size.height * 0.5),
      Offset(size.width * 0.5, size.height * 0.6),
      Offset(size.width * 0.4, size.height * 0.55),
      Offset(size.width * 0.65, size.height * 0.65),
    ];
    for (final d in dots) {
      canvas.drawRect(Rect.fromCenter(center: d, width: 3, height: 3), dp);
    }
  }
  @override bool shouldRepaint(_) => false;
}


class _HeaderStat extends StatelessWidget {
  final String value;
  final String label;
  const _HeaderStat({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        ShaderMask(
          shaderCallback: (b) => AppColors.brandGradient.createShader(b),
          child: Text(value,
            style: GoogleFonts.orbitron(
              fontSize: 13, fontWeight: FontWeight.w700, color: Colors.white)),
        ),
        Text(label, style: GoogleFonts.inter(fontSize: 9, color: AppColors.textSecondary)),
      ],
    );
  }
}

class _MiniStat extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  const _MiniStat({required this.label, required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(value,
          style: GoogleFonts.orbitron(
            fontSize: 10, fontWeight: FontWeight.w700, color: color)),
        Text(label,
          style: GoogleFonts.inter(fontSize: 9, color: AppColors.textMuted)),
      ],
    );
  }
}
