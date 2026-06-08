import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';

class TeluricLogo extends StatelessWidget {
  final double iconSize;
  final double fontSize;
  const TeluricLogo({super.key, this.iconSize = 34, this.fontSize = 14});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: iconSize,
          height: iconSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.25),
                blurRadius: 12,
                spreadRadius: 1,
              ),
            ],
          ),
          child: Image.asset(
            'assets/images/icon.png',
            fit: BoxFit.contain,
          ),
        ),
        const SizedBox(width: 8),
        ShaderMask(
          shaderCallback: (b) => AppColors.brandGradient.createShader(b),
          child: Text(
            'TELURIC',
            style: GoogleFonts.orbitron(
              fontSize: fontSize, fontWeight: FontWeight.w800,
              color: Colors.white, letterSpacing: 2.5,
            ),
          ),
        ),
      ],
    );
  }
}

