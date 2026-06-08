import 'dart:math' as math;
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../../data/mock_data.dart';



class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});
  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  int _areaIndex = 0;

  AreaModel get _area => mockAreas[_areaIndex];

  List<FlSpot> get _ndviSpots => _area.ndviHistory
      .asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value)).toList();

  List<FlSpot> get _carbonSpots => _area.carbonHistory
      .asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value)).toList();

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.of(context).padding.top;
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(top),
            _buildAreaTabs(),
            _buildScoreRow(),
            _buildChartSection(),
            const SizedBox(height: 120),
          ],
        ),
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
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Análise Ambiental',
                  style: GoogleFonts.orbitron(
                    fontSize: 15, fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary, letterSpacing: 1,
                  ),
                ),
                Text(
                  'Monitoramento detalhado por área',
                  style: GoogleFonts.inter(fontSize: 11, color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAreaTabs() {
    return Container(
      color: AppColors.background,
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 4),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: mockAreas.asMap().entries.map((e) {
            final active = e.key == _areaIndex;
            final shortName = 'Área ${e.key + 1}';
            return GestureDetector(
              onTap: () => setState(() => _areaIndex = e.key),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.only(right: 8, bottom: 4, top: 8),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
                decoration: BoxDecoration(
                  gradient: active
                      ? AppColors.brandGradient
                      : null,
                  color: active ? null : AppColors.card,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: active ? Colors.transparent : AppColors.cardLight,
                  ),
                  boxShadow: active ? [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.25),
                      blurRadius: 12, offset: const Offset(0, 4),
                    ),
                  ] : null,
                ),
                child: Text(
                  shortName,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: active ? FontWeight.w700 : FontWeight.w400,
                    color: active ? Colors.black : AppColors.textSecondary,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildScoreRow() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppColors.cardGradient,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.cardLight),
      ),
      child: Row(
        children: [
          _ScoreRing(score: _area.scoreEnv.toInt()),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              children: [
                _StatBox(
                  icon: Icons.cloud_outlined,
                  label: 'Carbono',
                  value: '+${_area.carbonEstimate.toStringAsFixed(1)}t',
                  sub: 'CO₂ sequestrado',
                  color: AppColors.secondary,
                ),
                const SizedBox(height: 10),
                _StatBox(
                  icon: Icons.trending_up_rounded,
                  label: 'Regeneração',
                  value: '+${_area.ndviChange}%',
                  sub: 'evolução média',
                  color: AppColors.primary,
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.1, end: 0, duration: 500.ms);
  }

  Widget _buildChartSection() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 14, 16, 0),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.cardLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 18, 18, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text('Últimos 12 meses',
                    style: GoogleFonts.orbitron(
                      fontSize: 12, fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary, letterSpacing: 0.5)),
                  Text('NDVI e Carbono acumulado',
                    style: GoogleFonts.inter(fontSize: 10, color: AppColors.textSecondary)),
                ]),
                Row(children: [
                  _LegendDot(color: AppColors.primary, label: 'NDVI'),
                  const SizedBox(width: 12),
                  _LegendDot(color: AppColors.secondary, label: 'CO₂'),
                ]),
              ],
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 200,
            child: Padding(
              padding: const EdgeInsets.only(right: 18, left: 4, bottom: 8),
              child: LineChart(_buildLineChartData()),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: ['Jan', 'Fev', 'Mar', 'Abr', 'Mai', 'Jun',
                         'Jul', 'Ago', 'Set', 'Out', 'Nov', 'Dez']
                  .map((m) => Text(m,
                    style: GoogleFonts.inter(fontSize: 8, color: AppColors.textMuted)))
                  .toList(),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 500.ms, delay: 150.ms).slideY(begin: 0.1, end: 0, duration: 500.ms, delay: 150.ms);
  }

  LineChartData _buildLineChartData() {
    final maxC = _area.carbonHistory.reduce((a, b) => a > b ? a : b);
    final normalizedCarbon = _area.carbonHistory
        .map((v) => v / maxC * 0.8)
        .toList();
    final carbonSpots = normalizedCarbon
        .asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value)).toList();

    return LineChartData(
      lineBarsData: [
        LineChartBarData(
          spots: _ndviSpots,
          isCurved: true,
          curveSmoothness: 0.3,
          color: AppColors.primary,
          barWidth: 2,
          dotData: const FlDotData(show: false),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: [AppColors.primary.withOpacity(0.20), Colors.transparent],
              begin: Alignment.topCenter, end: Alignment.bottomCenter,
            ),
          ),
        ),
        LineChartBarData(
          spots: carbonSpots,
          isCurved: true,
          curveSmoothness: 0.3,
          color: AppColors.secondary,
          barWidth: 2,
          dotData: const FlDotData(show: false),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: [AppColors.secondary.withOpacity(0.15), Colors.transparent],
              begin: Alignment.topCenter, end: Alignment.bottomCenter,
            ),
          ),
        ),
      ],
      titlesData: FlTitlesData(
        show: true,
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        bottomTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 0.2,
            reservedSize: 32,
            getTitlesWidget: (v, _) => Text(
              v.toStringAsFixed(1),
              style: GoogleFonts.inter(fontSize: 8, color: AppColors.textMuted),
            ),
          ),
        ),
      ),
      gridData: FlGridData(
        show: true,
        drawVerticalLine: false,
        getDrawingHorizontalLine: (_) => FlLine(
          color: AppColors.cardLight.withOpacity(0.6),
          strokeWidth: 0.5, dashArray: [4, 4],
        ),
      ),
      borderData: FlBorderData(show: false),
      minY: 0.2,
      maxY: 0.9,
    );
  }
}


class _ScoreRing extends StatelessWidget {
  final int score;
  const _ScoreRing({required this.score});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100, height: 100,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: const Size(100, 100),
            painter: _ScoreRingPainter(score: score),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                score.toString(),
                style: GoogleFonts.orbitron(
                  fontSize: 22, fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                'Score',
                style: GoogleFonts.inter(
                  fontSize: 9, color: AppColors.textSecondary),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ScoreRingPainter extends CustomPainter {
  final int score;
  const _ScoreRingPainter({required this.score});

  @override
  void paint(Canvas canvas, Size size) {
    final cx = size.width / 2;
    final cy = size.height / 2;
    final r  = size.width * 0.43;
    const strokeW = 7.0;
    const startAngle = math.pi * 0.75;
    const sweepMax  = math.pi * 1.5;

    final trackPaint = Paint()
      ..color = AppColors.cardLight
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeW
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(
      Rect.fromCircle(center: Offset(cx, cy), radius: r),
      startAngle, sweepMax, false, trackPaint,
    );

    final sweep = sweepMax * (score / 100.0);
    final rect  = Rect.fromCircle(center: Offset(cx, cy), radius: r);
    final shader = const LinearGradient(
      colors: [AppColors.primary, AppColors.secondary],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ).createShader(rect);

    final progressPaint = Paint()
      ..shader = shader
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeW
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(rect, startAngle, sweep, false, progressPaint);

    final tipAngle = startAngle + sweep;
    final dotX = cx + r * math.cos(tipAngle);
    final dotY = cy + r * math.sin(tipAngle);
    final glowPaint = Paint()
      ..color = AppColors.secondary.withOpacity(0.4)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 5);
    canvas.drawCircle(Offset(dotX, dotY), 6, glowPaint);
    canvas.drawCircle(Offset(dotX, dotY), 3.5,
      Paint()..color = AppColors.secondary);
  }

  @override bool shouldRepaint(covariant _ScoreRingPainter old) => old.score != score;
}


class _StatBox extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final String sub;
  final Color color;
  const _StatBox({required this.icon, required this.label, required this.value,
      required this.sub, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.07),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.25)),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                  style: GoogleFonts.inter(
                    fontSize: 9, color: AppColors.textSecondary)),
                Text(value,
                  style: GoogleFonts.orbitron(
                    fontSize: 15, fontWeight: FontWeight.w700, color: color)),
                Text(sub,
                  style: GoogleFonts.inter(
                    fontSize: 9, color: AppColors.textMuted)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


class _LegendDot extends StatelessWidget {
  final Color color;
  final String label;
  const _LegendDot({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 8, height: 8,
          decoration: BoxDecoration(shape: BoxShape.circle, color: color)),
        const SizedBox(width: 4),
        Text(label, style: GoogleFonts.inter(fontSize: 9, color: AppColors.textSecondary)),
      ],
    );
  }
}
