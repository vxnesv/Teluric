import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:latlong2/latlong.dart';
import '../../core/theme/app_colors.dart';
import '../../data/mock_data.dart';
import '../area/area_detail_screen.dart';

class RegisterAreaScreen extends StatefulWidget {
  const RegisterAreaScreen({super.key});
  @override
  State<RegisterAreaScreen> createState() => _RegisterAreaScreenState();
}

class _RegisterAreaScreenState extends State<RegisterAreaScreen> {
  final _nameCtrl = TextEditingController();
  AreaCategory _category = AreaCategory.reforestation;
  int _mode = 0; // 0=draw, 1=gps, 2=import
  final List<LatLng> _points = [];
  bool _loading = false;

  static const _center = LatLng(-23.510, -46.640);

  static const _modes = ['Desenhar', 'GPS', 'Importar'];
  static const _modeIcons = [
    Icons.edit_outlined,
    Icons.my_location,
    Icons.upload_file_outlined,
  ];

  void _onMapTap(_, LatLng point) {
    if (_mode != 0) return;
    setState(() => _points.add(point));
  }

  void _removeLastPoint() {
    if (_points.isEmpty) return;
    setState(() => _points.removeLast());
  }

  void _submit() async {
    if (_nameCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Informe o nome da área.'),
          backgroundColor: AppColors.danger,
        ),
      );
      return;
    }
    setState(() => _loading = true);
    await Future.delayed(const Duration(milliseconds: 1200));
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => AreaDetailScreen(area: mockAreas.first)),
    );
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final topPad = MediaQuery.of(context).padding.top;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          // ── Map (top 50%)
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.5,
            child: Stack(
              children: [
                FlutterMap(
                  options: MapOptions(
                    initialCenter: _center,
                    initialZoom: 14.5,
                    onTap: _onMapTap,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          'https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}',
                      userAgentPackageName: 'com.telluric.app',
                    ),
                    if (_points.length >= 3)
                      PolygonLayer(
                        polygons: [
                          Polygon(
                            points: _points,
                            color: AppColors.primary.withOpacity(0.28),
                            borderColor: AppColors.primary,
                            borderStrokeWidth: 2,
                          ),
                        ],
                      ),
                    MarkerLayer(
                      markers: _points
                          .map((p) => Marker(
                                point: p,
                                width: 14,
                                height: 14,
                                child: Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: AppColors.primary,
                                    border: Border.all(
                                        color: Colors.white, width: 2),
                                  ),
                                ),
                              ))
                          .toList(),
                    ),
                  ],
                ),

                Positioned(
                  top: topPad + 8,
                  left: 8,
                  right: 8,
                  child: Row(
                    children: [
                      _MapBtn(
                        icon: Icons.arrow_back,
                        onTap: () => Navigator.of(context).pop(),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 7),
                        decoration: BoxDecoration(
                          color: AppColors.background.withOpacity(0.88),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '${_points.length} ponto${_points.length != 1 ? 's' : ''}',
                          style: GoogleFonts.orbitron(
                              fontSize: 10,
                              color: AppColors.primary,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      const SizedBox(width: 8),
                      if (_points.isNotEmpty)
                        _MapBtn(
                          icon: Icons.undo_rounded,
                          onTap: _removeLastPoint,
                        ),
                    ],
                  ),
                ),

                Positioned(
                  bottom: 12,
                  left: 16,
                  right: 16,
                  child: Container(
                    height: 42,
                    decoration: BoxDecoration(
                      color: AppColors.background.withOpacity(0.90),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.cardLight, width: 0.5),
                    ),
                    child: Row(
                      children: List.generate(_modes.length, (i) {
                        final active = i == _mode;
                        return Expanded(
                          child: GestureDetector(
                            onTap: () => setState(() => _mode = i),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              margin: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: active
                                    ? AppColors.primary.withOpacity(0.18)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    _modeIcons[i],
                                    size: 13,
                                    color: active
                                        ? AppColors.primary
                                        : AppColors.textSecondary,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    _modes[i],
                                    style: GoogleFonts.inter(
                                      fontSize: 11,
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
                          ),
                        );
                      }),
                    ),
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _Label('Nome da área'),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _nameCtrl,
                    style: const TextStyle(color: AppColors.textPrimary),
                    decoration: const InputDecoration(
                      hintText: 'ex: Floresta das Vertentes',
                      prefixIcon: Icon(Icons.landscape_outlined,
                          color: AppColors.textSecondary, size: 18),
                    ),
                  )
                      .animate()
                      .fadeIn(delay: 200.ms),

                  const SizedBox(height: 20),
                  _Label('Categoria'),
                  const SizedBox(height: 10),

                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: AreaCategory.values.map((cat) {
                      final active = cat == _category;
                      return GestureDetector(
                        onTap: () => setState(() => _category = cat),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 9),
                          decoration: BoxDecoration(
                            color: active
                                ? AppColors.primary.withOpacity(0.15)
                                : AppColors.card,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: active
                                  ? AppColors.primary.withOpacity(0.6)
                                  : AppColors.cardLight,
                              width: 0.7,
                            ),
                          ),
                          child: Row(mainAxisSize: MainAxisSize.min, children: [
                            Text(cat.emoji,
                                style: const TextStyle(fontSize: 14)),
                            const SizedBox(width: 6),
                            Text(
                              cat.label,
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
                          ]),
                        ),
                      );
                    }).toList(),
                  ).animate().fadeIn(delay: 300.ms),

                  const SizedBox(height: 24),

                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.07),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: AppColors.primary.withOpacity(0.2),
                          width: 0.5),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.info_outline,
                            color: AppColors.primary, size: 18),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Após registrar, a IA espacial iniciará o monitoramento orbital dentro de 24h.',
                            style: GoogleFonts.inter(
                              fontSize: 11,
                              color: AppColors.textSecondary,
                              height: 1.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ).animate().fadeIn(delay: 400.ms),

                  const SizedBox(height: 24),

                  GestureDetector(
                    onTap: _loading ? null : _submit,
                    child: Container(
                      height: 52,
                      decoration: BoxDecoration(
                        gradient: _loading
                            ? const LinearGradient(
                                colors: [AppColors.textMuted, AppColors.textMuted])
                            : AppColors.brandGradient,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: _loading
                            ? []
                            : [
                                BoxShadow(
                                  color: AppColors.primary.withOpacity(0.3),
                                  blurRadius: 16,
                                  offset: const Offset(0, 6),
                                ),
                              ],
                      ),
                      alignment: Alignment.center,
                      child: _loading
                          ? const SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                  strokeWidth: 2, color: Colors.black))
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.satellite_alt_rounded,
                                    color: Colors.black, size: 18),
                                const SizedBox(width: 8),
                                Text(
                                  'Iniciar Monitoramento',
                                  style: GoogleFonts.inter(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                    ),
                  ).animate().fadeIn(delay: 500.ms),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Label extends StatelessWidget {
  final String text;
  const _Label(this.text);
  @override
  Widget build(BuildContext context) => Text(
        text,
        style: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: AppColors.textSecondary,
          letterSpacing: 0.5,
        ),
      );
}

class _MapBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _MapBtn({required this.icon, required this.onTap});
  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: AppColors.background.withOpacity(0.88),
            shape: BoxShape.circle,
            border: Border.all(
                color: AppColors.cardLight.withOpacity(0.5), width: 0.5),
          ),
          child: Icon(icon, color: AppColors.textPrimary, size: 18),
        ),
      );
}
