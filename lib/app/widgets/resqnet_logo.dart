import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Custom ResQNet Shield + Heartbeat ECG Pulse Logo Widget
class ResQNetLogo extends StatelessWidget {
  final double size;
  final bool showText;
  final bool showSubtitle;
  final Color textColor;
  final Color subtitleColor;

  const ResQNetLogo({
    super.key,
    this.size = 52,
    this.showText = true,
    this.showSubtitle = true,
    this.textColor = Colors.white,
    this.subtitleColor = Colors.white70,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Shield + ECG Pulse Icon
        CustomPaint(
          size: Size(size, size * 1.1),
          painter: _ResQNetShieldPainter(
            shieldColor: AppTheme.primaryRed,
            pulseColor: Colors.white,
          ),
        ),
        if (showText) ...[
          const SizedBox(height: 8),
          Text(
            'ResQNet',
            style: TextStyle(
              fontSize: size * 0.58,
              fontWeight: FontWeight.w900,
              color: textColor,
              letterSpacing: -0.5,
              shadows: textColor == Colors.white
                  ? const [
                      Shadow(
                        color: Colors.black45,
                        blurRadius: 10,
                        offset: Offset(0, 2),
                      ),
                    ]
                  : null,
            ),
          ),
        ],
        if (showText && showSubtitle) ...[
          const SizedBox(height: 2),
          Text(
            'Report  •  Alert  •  Respond',
            style: TextStyle(
              fontSize: size * 0.22,
              fontWeight: FontWeight.w600,
              color: subtitleColor,
              letterSpacing: 1.4,
            ),
          ),
        ],
      ],
    );
  }
}

/// Paints the precise Red Shield with White ECG Pulse Waveform
class _ResQNetShieldPainter extends CustomPainter {
  final Color shieldColor;
  final Color pulseColor;

  _ResQNetShieldPainter({
    required this.shieldColor,
    required this.pulseColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // 1. Draw Red Shield Body with Gradient / Shadow
    final shieldPaint = Paint()
      ..shader = LinearGradient(
        colors: [
          shieldColor,
          const Color(0xFFB91C1C),
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTWH(0, 0, w, h))
      ..style = PaintingStyle.fill;

    final shieldPath = Path()
      ..moveTo(w * 0.08, h * 0.15)
      ..cubicTo(w * 0.08, h * 0.05, w * 0.35, 0, w * 0.5, 0)
      ..cubicTo(w * 0.65, 0, w * 0.92, h * 0.05, w * 0.92, h * 0.15)
      ..cubicTo(w * 0.92, h * 0.58, w * 0.5, h * 0.95, w * 0.5, h)
      ..cubicTo(w * 0.5, h * 0.95, w * 0.08, h * 0.58, w * 0.08, h * 0.15)
      ..close();

    canvas.drawPath(shieldPath, shieldPaint);

    // 2. Draw ECG Heartbeat Pulse Line
    final pulsePaint = Paint()
      ..color = pulseColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.07
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final pulsePath = Path()
      ..moveTo(w * 0.22, h * 0.45)
      ..lineTo(w * 0.36, h * 0.45)
      ..lineTo(w * 0.42, h * 0.28) // Upward pulse peak
      ..lineTo(w * 0.50, h * 0.64) // Downward pulse valley
      ..lineTo(w * 0.58, h * 0.36) // Recovery peak
      ..lineTo(w * 0.64, h * 0.45)
      ..lineTo(w * 0.78, h * 0.45);

    canvas.drawPath(pulsePath, pulsePaint);
  }

  @override
  bool shouldRepaint(covariant _ResQNetShieldPainter oldDelegate) {
    return oldDelegate.shieldColor != shieldColor || oldDelegate.pulseColor != pulseColor;
  }
}
