import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../../data/services/session_service.dart';
import '../auth/login_screen.dart';
import '../home/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _orbitCtrl;
  late final AnimationController _particleCtrl;
  late final AnimationController _pulseCtrl;
  final List<_Particle> _particles = [];
  final _rand = math.Random(42);

  @override
  void initState() {
    super.initState();

    _orbitCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 18),
    )..repeat();

    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    for (int i = 0; i < 70; i++) {
      _particles.add(_Particle(
        x: _rand.nextDouble(),
        y: _rand.nextDouble(),
        size: _rand.nextDouble() * 1.8 + 0.4,
        speed: _rand.nextDouble() * 0.00015 + 0.00004,
        opacity: _rand.nextDouble() * 0.6 + 0.2,
      ));
    }

    _particleCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 16),
    )
      ..addListener(() {
        for (final p in _particles) {
          p.y -= p.speed;
          if (p.y < 0) p.y = 1.0;
        }
        setState(() {});
      })
      ..repeat();

    Future.delayed(const Duration(milliseconds: 3200), () async {
      if (!mounted) return;
      await SessionService.loadSession();
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => SessionService.isAuthenticated
              ? const HomeScreen()
              : const LoginScreen(),
          transitionsBuilder: (_, a, __, child) =>
              FadeTransition(opacity: a, child: child),
          transitionDuration: const Duration(milliseconds: 600),
        ),
      );
    });
  }

  @override
  void dispose() {
    _orbitCtrl.dispose();
    _particleCtrl.dispose();
    _pulseCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(gradient: AppColors.bgGradient),
          ),

          CustomPaint(
            painter: _ParticlePainter(_particles),
            size: size,
          ),

          CustomPaint(
            painter: _GridPainter(),
            size: size,
          ),

          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: size.height * 0.06),

                AnimatedBuilder(
                  animation: Listenable.merge([_orbitCtrl, _pulseCtrl]),
                  builder: (_, __) => CustomPaint(
                    painter: _EarthPainter(
                      orbitValue: _orbitCtrl.value,
                      pulseValue: _pulseCtrl.value,
                    ),
                    size: Size(size.width * 0.72, size.width * 0.72),
                  ),
                ),

                const SizedBox(height: 36),

                ShaderMask(
                  shaderCallback: (bounds) => AppColors.brandGradient
                      .createShader(bounds),
                  child: Text(
                    'TELURIC',
                    style: GoogleFonts.orbitron(
                      fontSize: 34,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 10,
                      color: Colors.white,
                    ),
                  ),
                )
                    .animate()
                    .fadeIn(delay: 400.ms, duration: 700.ms)
                    .slideY(begin: 0.25, end: 0, curve: Curves.easeOut),

                const SizedBox(height: 8),

                Text(
                  'Spatial Environmental Intelligence',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    letterSpacing: 2.5,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w400,
                  ),
                )
                    .animate()
                    .fadeIn(delay: 700.ms, duration: 700.ms),
              ],
            ),
          ),

          Positioned(
            bottom: 52,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (i) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(3),
                    color: i == 0
                        ? AppColors.primary
                        : AppColors.textMuted,
                  ),
                )
                    .animate(onPlay: (c) => c.repeat())
                    .fadeIn(
                        delay: Duration(milliseconds: 300 + 200 * i),
                        duration: 400.ms)
                    .then(delay: 600.ms)
                    .fadeOut(duration: 400.ms);
              }),
            ),
          ),
        ],
      ),
    );
  }
}

class _Particle {
  double x, y, size, speed, opacity;
  _Particle({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    required this.opacity,
  });
}

class _ParticlePainter extends CustomPainter {
  final List<_Particle> particles;
  _ParticlePainter(this.particles);

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in particles) {
      final paint = Paint()
        ..color = const Color(0xFF00E676).withOpacity(p.opacity * 0.35);
      canvas.drawCircle(
          Offset(p.x * size.width, p.y * size.height), p.size, paint);
    }
  }

  @override
  bool shouldRepaint(_ParticlePainter old) => true;
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF00E676).withOpacity(0.03)
      ..strokeWidth = 0.5
      ..style = PaintingStyle.stroke;

    const spacing = 32.0;
    for (double x = 0; x < size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(_GridPainter old) => false;
}

class _EarthPainter extends CustomPainter {
  final double orbitValue;
  final double pulseValue;
  _EarthPainter({required this.orbitValue, required this.pulseValue});

  @override
  void paint(Canvas canvas, Size size) {
    final c = Offset(size.width / 2, size.height / 2);
    final r = size.width / 2 * 0.82;

    final glowRadius = r * (1.55 + pulseValue * 0.08);
    canvas.drawCircle(
      c,
      glowRadius,
      Paint()
        ..shader = RadialGradient(colors: [
          AppColors.primary.withOpacity(0.15 + pulseValue * 0.05),
          AppColors.secondary.withOpacity(0.08),
          Colors.transparent,
        ], stops: const [
          0.0,
          0.55,
          1.0
        ]).createShader(Rect.fromCircle(center: c, radius: glowRadius)),
    );

    canvas.drawCircle(
      c,
      r,
      Paint()
        ..shader = RadialGradient(
          colors: const [Color(0xFF1B3D6B), Color(0xFF0D2545), Color(0xFF071520)],
          focal: const Alignment(-0.28, -0.28),
          focalRadius: 0.05,
        ).createShader(Rect.fromCircle(center: c, radius: r)),
    );

    canvas.save();
    canvas.clipPath(Path()..addOval(Rect.fromCircle(center: c, radius: r)));

    final greenPaint = Paint()
      ..color = const Color(0xFF00C853).withOpacity(0.55);
    final green2Paint = Paint()
      ..color = const Color(0xFF1B5E20).withOpacity(0.45);

    _blob(canvas, c, r, greenPaint, -0.28, -0.18, 0.52, 0.38);
    _blob(canvas, c, r, green2Paint, -0.22, -0.10, 0.36, 0.24);
    _blob(canvas, c, r, greenPaint, 0.25, 0.08, 0.30, 0.38);
    _blob(canvas, c, r, green2Paint, 0.30, 0.12, 0.20, 0.28);
    _blob(canvas, c, r, greenPaint, -0.05, 0.30, 0.38, 0.22);
    _blob(canvas, c, r, green2Paint, -0.08, 0.25, 0.28, 0.15);

    // Atmosphere shimmer
    canvas.drawRect(
      Rect.fromCircle(center: c, radius: r),
      Paint()
        ..shader = LinearGradient(
          colors: [
            AppColors.secondary.withOpacity(0.08),
            Colors.transparent,
            AppColors.primary.withOpacity(0.06),
          ],
        ).createShader(Rect.fromCircle(center: c, radius: r)),
    );

    canvas.restore();

    canvas.drawCircle(
      c,
      r + 3,
      Paint()
        ..color = AppColors.secondary.withOpacity(0.25)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.5,
    );

    _orbit(canvas, c, r * 1.38, 0.30, AppColors.primary, orbitValue);
    _orbit(canvas, c, r * 1.22, -0.52, AppColors.secondary, -orbitValue * 1.4);

    canvas.drawCircle(
      c,
      r,
      Paint()
        ..shader = RadialGradient(
          colors: [Colors.white.withOpacity(0.12), Colors.transparent],
          focal: const Alignment(-0.28, -0.28),
          focalRadius: 0.01,
        ).createShader(Rect.fromCircle(center: c, radius: r)),
    );
  }

  void _blob(Canvas canvas, Offset c, double r, Paint paint,
      double dx, double dy, double w, double h) {
    final cx = c.dx + r * dx;
    final cy = c.dy + r * dy;
    final bw = r * w;
    final bh = r * h;
    final path = Path()
      ..moveTo(cx - bw * 0.5, cy)
      ..quadraticBezierTo(cx - bw * 0.2, cy - bh * 0.85, cx, cy - bh * 0.5)
      ..quadraticBezierTo(cx + bw * 0.3, cy - bh * 0.15, cx + bw * 0.5, cy)
      ..quadraticBezierTo(cx + bw * 0.2, cy + bh * 0.65, cx, cy + bh * 0.5)
      ..quadraticBezierTo(cx - bw * 0.25, cy + bh * 0.25, cx - bw * 0.5, cy);
    canvas.drawPath(path, paint);
  }

  void _orbit(
      Canvas canvas, Offset c, double r, double tilt, Color color, double t) {
    final paint = Paint()
      ..color = color.withOpacity(0.28)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8;

    canvas.save();
    canvas.translate(c.dx, c.dy);
    canvas.rotate(tilt);
    canvas.scale(1.0, 0.22);
    canvas.drawCircle(Offset.zero, r, paint);
    canvas.restore();

    final angle = t * 2 * math.pi;
    final cosT = math.cos(tilt);
    final sinT = math.sin(tilt);
    final px = r * math.cos(angle);
    final py = r * 0.22 * math.sin(angle);
    final wx = c.dx + px * cosT - py * sinT;
    final wy = c.dy + px * sinT + py * cosT;

    canvas.drawCircle(
      Offset(wx, wy),
      2.8,
      Paint()..color = color.withOpacity(0.9),
    );
  }

  @override
  bool shouldRepaint(_EarthPainter old) =>
      old.orbitValue != orbitValue || old.pulseValue != pulseValue;
}

