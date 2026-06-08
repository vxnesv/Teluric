import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../core/theme/app_colors.dart';
import '../../data/services/auth_service.dart';
import '../home/home_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _showEmail = false;
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _loading = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  // ── Login real com e-mail e senha
  Future<void> _loginWithEmail() async {
    final email = _emailCtrl.text.trim();
    final password = _passCtrl.text;

    if (email.isEmpty || password.isEmpty) {
      _showSnackBar('Preencha e-mail e senha', isError: true);
      return;
    }

    setState(() => _loading = true);
    try {
      await AuthService.login(email: email, password: password);
      if (!mounted) return;
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => const HomeScreen(),
          transitionsBuilder: (_, a, __, child) =>
              FadeTransition(opacity: a, child: child),
          transitionDuration: const Duration(milliseconds: 600),
        ),
      );
    } on AuthException catch (e) {
      if (!mounted) return;
      _showSnackBar(e.message, isError: true);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  // ── Google / Apple: ainda não disponível no MVP
  void _comingSoon() {
    _showSnackBar('Disponível em breve', isError: false);
  }

  void _showSnackBar(String message, {required bool isError}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: GoogleFonts.inter(
            color: isError ? Colors.white : Colors.black,
          ),
        ),
        backgroundColor: isError
            ? AppColors.danger.withValues(alpha: 0.92)
            : AppColors.primary,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 38),

              // ── Logo
              Center(
                child: Column(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      padding: const EdgeInsets.all(0.5),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: AppColors.brandGradient,
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          'assets/images/icon.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    ShaderMask(
                      shaderCallback: (b) =>
                          AppColors.brandGradient.createShader(b),
                      child: Text(
                        'TELURIC',
                        style: GoogleFonts.orbitron(
                          fontSize: 26,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 6,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn(duration: 500.ms),

              const SizedBox(height: 52),

              // ── Título
              Text(
                'Bem-vindo',
                style: GoogleFonts.inter(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ).animate().fadeIn(delay: 200.ms, duration: 500.ms),
              const SizedBox(height: 6),
              Text(
                'Acesse sua conta para continuar monitorando o planeta.',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
              ).animate().fadeIn(delay: 300.ms, duration: 500.ms),

              const SizedBox(height: 36),

              // ── Botão Google
              _SocialButton(
                icon: FontAwesomeIcons.google,
                label: 'Continuar com Google',
                color: const Color(0xFFEA4335),
                onTap: _comingSoon,
              ).animate().fadeIn(delay: 400.ms).slideY(begin: 0.2, end: 0),

              const SizedBox(height: 12),

              // ── Botão Apple
              _SocialButton(
                icon: FontAwesomeIcons.apple,
                label: 'Continuar com Apple',
                color: AppColors.textPrimary,
                onTap: _comingSoon,
              ).animate().fadeIn(delay: 500.ms).slideY(begin: 0.2, end: 0),

              const SizedBox(height: 12),

              // ── Botão E-mail (toggle do formulário)
              _SocialButton(
                icon: Icons.email_outlined,
                label: 'Continuar com E-mail',
                color: AppColors.secondary,
                onTap: () => setState(() => _showEmail = !_showEmail),
                isFontAwesome: false,
              ).animate().fadeIn(delay: 600.ms).slideY(begin: 0.2, end: 0),

              // ── Formulário de e-mail/senha (expansível)
              AnimatedSize(
                duration: const Duration(milliseconds: 350),
                curve: Curves.easeInOut,
                child: _showEmail
                    ? Column(
                        children: [
                          const SizedBox(height: 20),
                          TextField(
                            controller: _emailCtrl,
                            keyboardType: TextInputType.emailAddress,
                            style:
                                const TextStyle(color: AppColors.textPrimary),
                            decoration: const InputDecoration(
                              labelText: 'E-mail',
                              prefixIcon: Icon(Icons.email_outlined,
                                  color: AppColors.textSecondary, size: 18),
                            ),
                          ),
                          const SizedBox(height: 12),
                          TextField(
                            controller: _passCtrl,
                            obscureText: true,
                            style:
                                const TextStyle(color: AppColors.textPrimary),
                            decoration: const InputDecoration(
                              labelText: 'Senha',
                              prefixIcon: Icon(Icons.lock_outline,
                                  color: AppColors.textSecondary, size: 18),
                            ),
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: _loading ? null : _loginWithEmail,
                              child: _loading
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.black),
                                    )
                                  : const Text('Entrar'),
                            ),
                          ),
                        ],
                      )
                    : const SizedBox.shrink(),
              ),

              const SizedBox(height: 32),

              // ── Divisor
              Row(children: [
                const Expanded(child: Divider()),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text('ou',
                      style: GoogleFonts.inter(
                          color: AppColors.textMuted, fontSize: 12)),
                ),
                const Expanded(child: Divider()),
              ]).animate().fadeIn(delay: 700.ms),

              const SizedBox(height: 20),

              // ── Link "Criar conta"
              Center(
                child: GestureDetector(
                  onTap: () => Navigator.of(context).push(
                    PageRouteBuilder(
                      pageBuilder: (_, __, ___) => const RegisterScreen(),
                      transitionsBuilder: (_, a, __, child) =>
                          FadeTransition(opacity: a, child: child),
                      transitionDuration: const Duration(milliseconds: 400),
                    ),
                  ),
                  child: RichText(
                    text: TextSpan(
                      text: 'Não tem conta? ',
                      style: GoogleFonts.inter(
                          color: AppColors.textSecondary, fontSize: 13),
                      children: [
                        TextSpan(
                          text: 'Criar conta gratuita',
                          style: GoogleFonts.inter(
                            color: AppColors.primary,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ).animate().fadeIn(delay: 800.ms),

              const SizedBox(height: 40),

              // ── Aviso de localização
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: AppColors.secondary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                      color: AppColors.secondary.withValues(alpha: 0.2),
                      width: 0.5),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.location_on_outlined,
                        color: AppColors.secondary, size: 18),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'O app utiliza sua localização para registrar e monitorar áreas ambientais.',
                        style: GoogleFonts.inter(
                          fontSize: 11,
                          color: AppColors.textSecondary,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn(delay: 900.ms),

              const SizedBox(height: 28),

              // ── Termos
              Center(
                child: Text(
                  'Ao continuar, você concorda com nossos\nTermos de Uso e Política de Privacidade.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    color: AppColors.textMuted,
                    height: 1.6,
                  ),
                ),
              ).animate().fadeIn(delay: 1000.ms),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

class _SocialButton extends StatelessWidget {
  final dynamic icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  final bool isFontAwesome;

  const _SocialButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
    this.isFontAwesome = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
              color: AppColors.cardLight.withValues(alpha: 0.8), width: 0.5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            isFontAwesome
                ? FaIcon(icon as FaIconData, color: color, size: 18)
                : Icon(icon as IconData, color: color, size: 20),
            const SizedBox(width: 12),
            Text(
              label,
              style: GoogleFonts.inter(
                color: AppColors.textPrimary,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
