import 'package:flutter/material.dart';

// ─────────────────────────────────────────────
//  PALETA ADAPTATIVA
// ─────────────────────────────────────────────

class _Palette {
  final Color background;
  final Color textPrimary;
  final Color textSecondary;

  const _Palette._({
    required this.background,
    required this.textPrimary,
    required this.textSecondary,
  });

  factory _Palette.of(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return dark ? _Palette._dark() : _Palette._light();
  }

  factory _Palette._light() => const _Palette._(
        background: Color(0xFFEAF4DE),
        textPrimary: Color(0xFF1B5E20),
        textSecondary: Color(0xFF66BB6A),
      );

  factory _Palette._dark() => const _Palette._(
        background: Color(0xFF121212),
        textPrimary: Color(0xFFA5D6A7),
        textSecondary: Color(0xFF4CAF50),
      );
}

// ─────────────────────────────────────────────
//  SPLASH SCREEN
// ─────────────────────────────────────────────

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _fadeAnim = Tween<double>(begin: 0, end: 2).animate(_controller);
    _controller.forward();

    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacementNamed(context, '/menu');
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final p = _Palette.of(context);

    return Scaffold(
      backgroundColor: p.background,
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnim,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('💣', style: TextStyle(fontSize: 80)),
              const SizedBox(height: 16),
              Text(
                'BUSCAMINAS',
                style: TextStyle(
                  fontSize: 36,
                  color: p.textPrimary,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 6,
                ),
              ),
              Text(
                'FLUTTER',
                style: TextStyle(
                  fontSize: 16,
                  color: p.textSecondary,
                  letterSpacing: 12,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}