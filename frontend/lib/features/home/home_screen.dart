import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latlong2/latlong.dart';

import '../../core/theme/app_colors.dart';
import '../../core/widgets/teluric_logo.dart';
import '../../data/mock_data.dart';
import '../../data/services/session_service.dart';
import '../analytics/analytics_screen.dart';
import '../area/area_detail_screen.dart';
import '../area/area_selection_screen.dart';
import '../area/register_area_screen.dart';
import '../profile/profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _tab = 0;

  void _onNavTap(int navIndex) {
    if (navIndex == 2) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => const RegisterAreaScreen()),
      );
      return;
    }
    final stackIndex = navIndex < 2 ? navIndex : navIndex - 1;
    setState(() => _tab = stackIndex);
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).padding.bottom;
    return Scaffold(
      backgroundColor: AppColors.background,
      extendBody: true,
      body: IndexedStack(
        index: _tab,
        children: const [
          _MapTab(),
          AreaSelectionScreen(),
          AnalyticsScreen(),
          ProfileScreen(),
        ],
      ),
      bottomNavigationBar: _CustomBottomNav(
        currentNavIndex: _tab < 2 ? _tab : _tab + 1,
        onTap: _onNavTap,
        bottomPad: bottom,
      ),
    );
  }
}

class _CustomBottomNav extends StatelessWidget {
  final int currentNavIndex;
  final ValueChanged<int> onTap;
  final double bottomPad;

  const _CustomBottomNav({
    required this.currentNavIndex,
    required this.onTap,
    required this.bottomPad,
  });

  static const _items = [
    (Icons.home_rounded, Icons.home_outlined, 'Home'),
    (Icons.layers_rounded, Icons.layers_outlined, 'Áreas'),
    (null, null, ''),
    (Icons.bar_chart_rounded, Icons.bar_chart_outlined, 'Analytics'),
    (Icons.person_rounded, Icons.person_outline_rounded, 'Perfil'),
  ];

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
        child: Container(
          height: 62 + bottomPad,
          decoration: BoxDecoration(
            color: AppColors.surface.withOpacity(0.88),
            border: const Border(
                top: BorderSide(color: AppColors.cardLight, width: 0.5)),
          ),
          child: Padding(
            padding: EdgeInsets.only(bottom: bottomPad),
            child: Row(
              children: List.generate(_items.length, (i) {
                if (i == 2) return _CenterFab(onTap: () => onTap(2));
                final active = currentNavIndex == i;
                final item = _items[i];
                return Expanded(
                  child: GestureDetector(
                    onTap: () => onTap(i),
                    behavior: HitTestBehavior.opaque,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: active
                                ? AppColors.primary.withOpacity(0.15)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            active ? item.$1 : item.$2,
                            color: active
                                ? AppColors.primary
                                : AppColors.textSecondary,
                            size: 22,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          item.$3,
                          style: GoogleFonts.inter(
                            fontSize: 12,
                            fontWeight: active
                                ? FontWeight.w700
                                : FontWeight.w400,
                            color: active
                                ? AppColors.primary
                                : AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}

class _CenterFab extends StatelessWidget {
  final VoidCallback onTap;
  const _CenterFab({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: AppColors.brandGradient,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.35),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(Icons.add_rounded, color: Colors.black, size: 26),
            ),
          ],
        ),
      ),
    );
  }
}

class _MapTab extends StatefulWidget {
  const _MapTab();
  @override
  State<_MapTab> createState() => _MapTabState();
}

class _MapTabState extends State<_MapTab> {
  final _mapCtrl = MapController();
  int _activeLayer = 0;
  bool _layerPanelOpen = false;

  static const _layers = ['Vegetação', 'Calor', 'Carbono', 'Biodiversidade'];
  static const _layerColors = [
    AppColors.primary,
    AppColors.amber,
    Color(0xFFCE93D8),
    AppColors.secondary,
  ];

  @override
  void dispose() {
    _mapCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.of(context).padding.top;
    final bottom = MediaQuery.of(context).padding.bottom;

    return Stack(
      children: [

        FlutterMap(
          mapController: _mapCtrl,
          options: const MapOptions(
            initialCenter: LatLng(-23.515, -46.625),
            initialZoom: 13.2,
            minZoom: 4,
            maxZoom: 18,
          ),
          children: [
            TileLayer(
              urlTemplate:
              'https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}',
              userAgentPackageName: 'br.com.fiap.teluric',
            ),
            PolygonLayer(
              polygons: mockAreas
                  .map((a) => Polygon(
                points: a.polygon,
                color: AppColors.primary.withOpacity(0.22),
                borderColor: AppColors.primary,
                borderStrokeWidth: 2.0,
              ))
                  .toList(),
            ),
            MarkerLayer(
              markers: mockAreas.map((area) {
                final c = LatLng(
                  (area.polygon[0].latitude + area.polygon[2].latitude) / 2,
                  (area.polygon[0].longitude + area.polygon[2].longitude) / 2,
                );
                return Marker(
                  point: c,
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (_) => AreaDetailScreen(area: area)),
                    ),
                    child: _AreaChip(name: area.name.split(' ').first),
                  ),
                );
              }).toList(),
            ),
          ],
        ),

        Positioned(
          top: 0, left: 0, right: 0, height: 130,
          child: IgnorePointer(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.background.withOpacity(0.80),
                    Colors.transparent,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
        ),

        Positioned(
          top: top + 12,
          left: 16,
          right: 16,
          child: Row(
            children: [
              const TeluricLogo(iconSize: 32, fontSize: 13)
                  .animate()
                  .fadeIn(duration: 500.ms)
                  .slideX(begin: -0.2, end: 0),
              const Spacer(),
              _BellBtn().animate().fadeIn(delay: 300.ms),
            ],
          ),
        ),

        Positioned(
          top: top + 62,
          left: 16,
          right: 80,
          child: _NotificationCard()
              .animate()
              .fadeIn(delay: 350.ms, duration: 500.ms)
              .slideY(begin: -0.08, end: 0, delay: 350.ms, duration: 400.ms),
        ),



        Positioned(
          bottom: bottom + 62,
          left: 0,
          right: 0,
          child: _GlassCard()
              .animate()
              .fadeIn(delay: 400.ms, duration: 600.ms)
              .slideY(begin: 0.3, end: 0, duration: 500.ms, delay: 400.ms),
        ),
      ],
    );
  }
}

class _GlassCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final avgScore = (mockAreas.map((a) => a.scoreEnv).reduce((a, b) => a + b) /
        mockAreas.length).round();
    final avgCarbon = totalCarbon / mockAreas.length;

    return ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 25, sigmaY: 25),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primary.withOpacity(0.35),
                    AppColors.secondary.withOpacity(0.35)
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
                border: Border.all(
                  color: Colors.white.withOpacity(0.2),
                  width: 1.2,
                ),
              ),

              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Center(
                    child: Container(
                      width: 36, height: 4,
                      margin: const EdgeInsets.only(bottom: 14),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.18),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),

                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Olá, ',
                                    style: GoogleFonts.inter(
                                      fontSize: 17, fontWeight: FontWeight.w400,
                                      color: Colors.black.withOpacity(0.55),
                                    ),
                                  ),
                                  TextSpan(
                                    text:
                                        '${SessionService.currentUser?.firstName ?? 'Usuário'}!',
                                    style: GoogleFonts.inter(
                                      fontSize: 17, fontWeight: FontWeight.w800,
                                      color: Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 1),
                            Text(
                              'Aqui está o resumo do seu impacto',
                              style: GoogleFonts.inter(
                                fontSize: 10.5,
                                color: Colors.black.withOpacity(0.50),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Últimos 30 dias',
                              style: GoogleFonts.inter(
                                fontSize: 10, fontWeight: FontWeight.w600,
                                color: Colors.black.withOpacity(0.75),
                              ),
                            ),
                            const SizedBox(width: 3),
                            Icon(Icons.keyboard_arrow_down_rounded,
                                size: 14,
                                color: Colors.black.withOpacity(0.75)),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),
                  IntrinsicHeight(
                    child: Row(
                      children: [
                        Expanded(child: _ScoreStatCard(score: avgScore)),
                        const SizedBox(width: 7),
                        Expanded(child: _CarbonStatCard(carbon: avgCarbon)),
                        const SizedBox(width: 7),
                        Expanded(
                            child: _AreasStatCard(count: mockAreas.length)),
                        const SizedBox(width: 7),
                        Expanded(child: _RegenStatCard(pct: 18)),
                      ],
                    ),
                  ),
                ],
              ),
            )
        )
    );
  }
}

class _StatShell extends StatelessWidget {
  final String label;
  final Widget child;
  const _StatShell({required this.label, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(10, 10, 10, 12),
      decoration: BoxDecoration(
        color: const Color(0xFF060B14).withOpacity(0.62),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 9, fontWeight: FontWeight.w500,
              color: Colors.white.withOpacity(0.50),
            ),
          ),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );
  }
}


class _ScoreStatCard extends StatelessWidget {
  final int score;
  const _ScoreStatCard({required this.score});

  @override
  Widget build(BuildContext context) {
    return _StatShell(
      label: 'Score',
      child: Center(
        child: SizedBox(
          width: 58, height: 58,
          child: Stack(
            alignment: Alignment.center,
            children: [
              CustomPaint(
                size: const Size(58, 58),
                painter: _MiniRingPainter(progress: score / 100.0),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '$score',
                    style: GoogleFonts.orbitron(
                      fontSize: 16, fontWeight: FontWeight.w800,
                      color: Colors.white,
                      height: 1.0,
                    ),
                  ),
                  Text(
                    '/100',
                    style: GoogleFonts.inter(
                        fontSize: 8, color: Colors.white.withOpacity(0.45)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CarbonStatCard extends StatelessWidget {
  final double carbon;
  const _CarbonStatCard({required this.carbon});

  @override
  Widget build(BuildContext context) {
    return _StatShell(
      label: 'Carbono',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.cloud_outlined, color: AppColors.secondary, size: 20),
          const SizedBox(height: 4),
          Text(
            '+${carbon.toStringAsFixed(1)}t',
            style: GoogleFonts.orbitron(
              fontSize: 15, fontWeight: FontWeight.w800,
              color: AppColors.primary,
            ),
          ),
          Text(
            'CO² equivalente',
            style: GoogleFonts.inter(
                fontSize: 8, color: Colors.white.withOpacity(0.45)),
          ),
        ],
      ),
    );
  }
}

class _AreasStatCard extends StatelessWidget {
  final int count;
  const _AreasStatCard({required this.count});

  @override
  Widget build(BuildContext context) {
    return _StatShell(
      label: 'Áreas\nMonitoradas',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$count',
            style: GoogleFonts.orbitron(
              fontSize: 26, fontWeight: FontWeight.w800,
              color: Colors.white, height: 1.0,
            ),
          ),
          Text(
            'áreas ativas',
            style: GoogleFonts.inter(
                fontSize: 8, color: Colors.white.withOpacity(0.45)),
          ),
        ],
      ),
    );
  }
}

class _RegenStatCard extends StatelessWidget {
  final int pct;
  const _RegenStatCard({required this.pct});

  @override
  Widget build(BuildContext context) {
    return _StatShell(
      label: 'Regeneração',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.eco_rounded, color: AppColors.primary, size: 20),
          const SizedBox(height: 4),
          Text(
            '+$pct%',
            style: GoogleFonts.orbitron(
              fontSize: 15, fontWeight: FontWeight.w800,
              color: AppColors.primary,
            ),
          ),
          Text(
            'evolução média',
            style: GoogleFonts.inter(
                fontSize: 8, color: Colors.white.withOpacity(0.45)),
          ),
        ],
      ),
    );
  }
}

class _MiniRingPainter extends CustomPainter {
  final double progress;
  const _MiniRingPainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final r = size.width * 0.42;
    const stroke = 5.5;
    const start = math.pi * 0.75;
    const sweep = math.pi * 1.5;

    canvas.drawArc(
      Rect.fromCircle(center: Offset(cx, cy), radius: r),
      start, sweep, false,
      Paint()
        ..color = Colors.white.withOpacity(0.15)
        ..style = PaintingStyle.stroke
        ..strokeWidth = stroke
        ..strokeCap = StrokeCap.round,
    );

    final sweepAngle = sweep * progress.clamp(0.0, 1.0);
    final rect = Rect.fromCircle(center: Offset(cx, cy), radius: r);
    canvas.drawArc(
      rect, start, sweepAngle, false,
      Paint()
        ..shader = const LinearGradient(
          colors: [AppColors.primary, AppColors.secondary],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ).createShader(rect)
        ..style = PaintingStyle.stroke
        ..strokeWidth = stroke
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(covariant _MiniRingPainter old) => old.progress != progress;
}

class _NotificationCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.62),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: AppColors.primary.withOpacity(0.25), width: 0.8),
          ),
          child: Row(
            children: [
              Container(
                width: 38, height: 38,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary.withOpacity(0.18),
                  border: Border.all(color: AppColors.primary.withOpacity(0.55)),
                ),
                child: const Icon(Icons.eco_rounded, color: AppColors.primary, size: 20),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tendência',
                      style: GoogleFonts.inter(
                        fontSize: 9, color: AppColors.textMuted,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      'Regeneração Detectada',
                      style: GoogleFonts.inter(
                        fontSize: 12, fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                      ),
                    ),
                    Text(
                      'A vegetação apresenta crescimento consistente na área analisada',
                      style: GoogleFonts.inter(
                          fontSize: 9, color: AppColors.textSecondary, height: 1.3),
                      maxLines: 2, overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//notificacao

class _BellBtn extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: ClipOval(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: 38, height: 38,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.08),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white.withOpacity(0.12), width: 0.5),
                ),
                child: const Icon(Icons.notifications_rounded,
                    color: AppColors.textPrimary, size: 18),
              ),

              Positioned(
                top: 2, right: 2,
                child: Container(
                  width: 9, height: 9,
                  decoration: BoxDecoration(
                    color: AppColors.danger,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.background, width: 1.5),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AreaChip extends StatelessWidget {
  final String name;
  const _AreaChip({required this.name});
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.background.withOpacity(0.88),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primary.withOpacity(0.6)),
      ),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Container(width: 6, height: 6,
            decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.primary)),
        const SizedBox(width: 4),
        Text(name, style: GoogleFonts.inter(
            fontSize: 9, color: AppColors.textPrimary, fontWeight: FontWeight.w600)),
      ]),
    );
  }
}

class _IconBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final bool active;
  const _IconBtn({required this.icon, required this.onTap, this.active = false});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipOval(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            width: 38, height: 38,
            decoration: BoxDecoration(
              color: active
                  ? AppColors.primary.withOpacity(0.22)
                  : Colors.white.withOpacity(0.08),
              shape: BoxShape.circle,
              border: Border.all(
                color: active
                    ? AppColors.primary.withOpacity(0.6)
                    : Colors.white.withOpacity(0.12),
                width: 0.5,
              ),
            ),
            child: Icon(icon,
                color: active ? AppColors.primary : AppColors.textSecondary,
                size: 18),
          ),
        ),
      ),
    );
  }
}
