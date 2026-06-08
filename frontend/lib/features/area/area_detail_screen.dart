import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latlong2/latlong.dart';
import '../../core/theme/app_colors.dart';
import '../../data/mock_data.dart';
import '../../data/services/geospatial_service.dart';
import '../wallet/certificate_screen.dart';


class AreaDetailScreen extends StatefulWidget {
  final AreaModel area;
  const AreaDetailScreen({super.key, required this.area});
  @override
  State<AreaDetailScreen> createState() => _AreaDetailScreenState();
}

class _AreaDetailScreenState extends State<AreaDetailScreen> {
  final List<String> _periods = ['7D', '30D', '12M'];
  String _selectedPeriod = '30D';
  final _geoService = GeospatialService();
  
  WeatherData? _weather;
  List<InpeAlert>? _alerts;
  bool _isLoadingGeo = true;

  AreaModel get area => widget.area;

  @override
  void initState() {
    super.initState();
    _loadGeoData();
  }

  Future<void> _loadGeoData() async {
    try {
      final weather = await _geoService.fetchWeatherData(_areaCenter);
      final alerts = await _geoService.fetchInpeAlerts(_areaCenter);
      if (mounted) {
        setState(() {
          _weather = weather;
          _alerts = alerts;
          _isLoadingGeo = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoadingGeo = false);
    }
  }

  double get _periodMultiplier {
    switch (_selectedPeriod) {
      case '7D':
        return 0.25;
      case '30D':
        return 0.50;
      case '12M':
      default:
        return 1.00;
    }
  }

  double get _ndviDisplay =>
      (area.ndviChange * _periodMultiplier).clamp(0, area.ndviChange);

  LatLng get _areaCenter =>
      LatLng(
        (area.polygon[0].latitude + area.polygon[2].latitude) / 2,
        (area.polygon[0].longitude + area.polygon[2].longitude) / 2,
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 220,
            pinned: true,
            backgroundColor: AppColors.surface,
            leading: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppColors.background.withOpacity(0.8),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_back,
                    color: AppColors.textPrimary, size: 18),
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                children: [
                  FlutterMap(
                    options: MapOptions(
                      initialCenter: _areaCenter,
                      initialZoom: 14.5,
                      interactionOptions: const InteractionOptions(
                        flags: InteractiveFlag.none,
                      ),
                    ),
                    children: [
                      TileLayer(
                        urlTemplate:
                        'https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}',
                        userAgentPackageName: 'com.telluric.app',
                      ),
                      PolygonLayer(
                        polygons: [
                          Polygon(
                            points: area.polygon,
                            color: AppColors.primary.withOpacity(0.3),
                            borderColor: AppColors.primary,
                            borderStrokeWidth: 2,
                          ),
                        ],
                      ),
                    ],
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    height: 80,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.transparent,
                            AppColors.surface.withOpacity(0.95),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              title: Text(
                area.name,
                style: GoogleFonts.orbitron(
                    fontSize: 13, fontWeight: FontWeight.w700),
              ),
              titlePadding:
              const EdgeInsets.only(left: 56, bottom: 14, right: 56),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                const SizedBox(height: 16),
                Row(children: [
                  _Chip(
                    label: '${area.category.emoji} ${area.category.label}',
                    color: AppColors.primary,
                  ),
                  const SizedBox(width: 8),
                  _StatusChip(area.status),
                  const Spacer(),
                  Text(
                    'Atualizado ${area.lastUpdate}',
                    style: GoogleFonts.inter(
                        fontSize: 10, color: AppColors.textMuted),
                  ),
                ]).animate().fadeIn(delay: 100.ms),

                const SizedBox(height: 24),

                // --- NOVA SEÇÃO: DADOS EM TEMPO REAL (INMET / INPE) ---
                _SectionLabel('Monitoramento em Tempo Real'),
                const SizedBox(height: 12),
                if (_isLoadingGeo)
                  const LinearProgressIndicator(backgroundColor: AppColors.cardLight, color: AppColors.primary)
                else
                  Row(
                    children: [
                      Expanded(
                        child: _RealtimeCard(
                          title: 'Clima (INMET)',
                          value: '${_weather?.temp ?? "--"}°C',
                          subtitle: _weather?.condition ?? 'Carregando...',
                          icon: Icons.wb_sunny_rounded,
                          color: AppColors.amber,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _RealtimeCard(
                          title: 'Alertas (INPE)',
                          value: _alerts?.isEmpty ?? true ? 'Nenhum' : '${_alerts!.length} Ativo',
                          subtitle: _alerts?.isEmpty ?? true ? 'Área segura' : _alerts!.first.type,
                          icon: Icons.warning_amber_rounded,
                          color: (_alerts?.isEmpty ?? true) ? AppColors.primary : AppColors.danger,
                        ),
                      ),
                    ],
                  ).animate().fadeIn(),

                const SizedBox(height: 24),

                _SectionLabel('Período de Análise'),
                const SizedBox(height: 12),
                _buildPeriodDropdown(),
                
                const SizedBox(height: 24),

                _SectionLabel('Indicadores Espaciais (Sentinel)'),
                const SizedBox(height: 10),
                Row(children: [
                  Expanded(
                    child: _MetricCard(
                      label: 'NDVI',
                      value: '+${_ndviDisplay.toStringAsFixed(0)}%',
                      sub: 'Índice vegetal',
                      color: AppColors.primary,
                      icon: Icons.grass_rounded,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _MetricCard(
                      label: 'Biomassa',
                      value:
                      '+${(area.biomassChange * _periodMultiplier)
                          .toStringAsFixed(1)}t',
                      sub: 'Acumulado',
                      color: AppColors.secondary,
                      icon: Icons.park_rounded,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _MetricCard(
                      label: 'Umidade Solo',
                      value: '62%',
                      sub: 'Estimado',
                      color: Colors.blue,
                      icon: Icons.water_drop_rounded,
                    ),
                  ),
                ]).animate().fadeIn(delay: 200.ms),

                const SizedBox(height: 24),
                _SectionLabel('Score Ambiental'),
                const SizedBox(height: 10),
                _ScoreBar(score: area.scoreEnv).animate().fadeIn(delay: 250.ms),

                const SizedBox(height: 24),
                _EsgCertificateCard(area: area),

                const SizedBox(height: 24),
                _SectionLabel('Histórico de Eventos'),
                const SizedBox(height: 12),
                ...area.events.asMap().entries.map((entry) {
                  return _TimelineItem(
                    event: entry.value,
                    isLast: entry.key == area.events.length - 1,
                  ).animate().fadeIn(delay: Duration(milliseconds: 350 + entry.key * 80));
                }),
                const SizedBox(height: 48),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPeriodDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.cardLight.withOpacity(0.4),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: AppColors.primary.withOpacity(0.25),
          width: 1,
        ),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedPeriod,
          icon: const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.primary),
          dropdownColor: AppColors.background,
          borderRadius: BorderRadius.circular(10),
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
          onChanged: (String? newValue) {
            if (newValue != null) setState(() => _selectedPeriod = newValue);
          },
          items: const [
            DropdownMenuItem(value: '7D', child: Text('Últimos 7 dias')),
            DropdownMenuItem(value: '30D', child: Text('Últimos 30 dias')),
            DropdownMenuItem(value: '12M', child: Text('Últimos 12 meses')),
          ],
        ),
      ),
    );
  }
}

class _RealtimeCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
  final Color color;

  const _RealtimeCard({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(0.15), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 16),
              const SizedBox(width: 6),
              Text(title, style: GoogleFonts.inter(fontSize: 10, color: AppColors.textMuted, fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 8),
          Text(value, style: GoogleFonts.orbitron(fontSize: 16, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
          Text(subtitle, style: GoogleFonts.inter(fontSize: 9, color: AppColors.textSecondary), overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }
}

class _EsgCertificateCard extends StatelessWidget {
  final AreaModel area;
  const _EsgCertificateCard({required this.area});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (_) => CertificateScreen(area: area))),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.amber.withOpacity(0.15), AppColors.primary.withOpacity(0.08)],
          ),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.amber.withOpacity(0.35), width: 0.5),
        ),
        child: Row(children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: AppColors.amber.withOpacity(0.2), borderRadius: BorderRadius.circular(10)),
            child: const Icon(Icons.verified_rounded, color: AppColors.amber, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Certificado ESG', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.textPrimary)),
                Text('Verificado por IA espacial', style: GoogleFonts.inter(fontSize: 11, color: AppColors.textSecondary)),
              ],
            ),
          ),
          const Icon(Icons.arrow_forward_ios_rounded, color: AppColors.amber, size: 14),
        ]),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);
  @override
  Widget build(BuildContext context) => Text(
        text.toUpperCase(),
        style: GoogleFonts.orbitron(
          fontSize: 10,
          color: AppColors.textMuted,
          letterSpacing: 1.5,
          fontWeight: FontWeight.w600,
        ),
      );
}

class _Chip extends StatelessWidget {
  final String label;
  final Color color;
  const _Chip({required this.label, required this.color});
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: color.withOpacity(0.12),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withOpacity(0.3), width: 0.5),
        ),
        child: Text(
          label,
          style: GoogleFonts.inter(
              fontSize: 11, color: color, fontWeight: FontWeight.w600),
        ),
      );
}

class _StatusChip extends StatelessWidget {
  final RegenerationStatus status;
  const _StatusChip(this.status);

  @override
  Widget build(BuildContext context) {
    final Map<RegenerationStatus, (String, Color)> map = {
      RegenerationStatus.growing: ('Growing 📈', AppColors.primary),
      RegenerationStatus.stable: ('Stable ➡️', AppColors.secondary),
      RegenerationStatus.atRisk: ('At Risk ⚠️', AppColors.amber),
    };
    final (label, color) = map[status]!;
    return _Chip(label: label, color: color);
  }
}

class _MetricCard extends StatelessWidget {
  final String label;
  final String value;
  final String sub;
  final Color color;
  final IconData icon;
  const _MetricCard({
    required this.label,
    required this.value,
    required this.sub,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(0.25), width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(height: 8),
          Text(
            value,
            style: GoogleFonts.orbitron(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: GoogleFonts.inter(
                fontSize: 10, color: AppColors.textPrimary, fontWeight: FontWeight.w600),
          ),
          Text(
            sub,
            style: GoogleFonts.inter(fontSize: 9, color: AppColors.textMuted),
          ),
        ],
      ),
    );
  }
}

class _ScoreBar extends StatelessWidget {
  final double score;
  const _ScoreBar({required this.score});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              score.toInt().toString(),
              style: GoogleFonts.orbitron(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary),
            ),
            Text(
              '/ 100',
              style: GoogleFonts.inter(
                  fontSize: 12, color: AppColors.textMuted),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: score / 100,
            backgroundColor: AppColors.cardLight,
            valueColor: const AlwaysStoppedAnimation(AppColors.primary),
            minHeight: 8,
          ),
        ),
      ],
    );
  }
}

class _TimelineItem extends StatelessWidget {
  final TimelineEvent event;
  final bool isLast;
  const _TimelineItem({required this.event, required this.isLast});

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: event.isAlert
                      ? AppColors.amber.withOpacity(0.15)
                      : AppColors.primary.withOpacity(0.12),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: event.isAlert
                        ? AppColors.amber.withOpacity(0.4)
                        : AppColors.primary.withOpacity(0.3),
                    width: 0.5,
                  ),
                ),
                alignment: Alignment.center,
                child: Text(event.icon, style: const TextStyle(fontSize: 14)),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 1,
                    color: AppColors.cardLight,
                    margin: const EdgeInsets.symmetric(vertical: 4),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 6),
                  Text(
                    event.title,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w500,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    event.date,
                    style: GoogleFonts.inter(
                        fontSize: 10, color: AppColors.textMuted),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
