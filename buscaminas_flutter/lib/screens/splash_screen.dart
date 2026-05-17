import 'package:flutter/material.dart';

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

    _fadeAnim = Tween<double>(begin: 0, end: 1).animate(_controller);
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
    return Scaffold(
      backgroundColor: const Color(0xFFEAF4DE),
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnim,
          child: const Column(
          mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('💣', style: TextStyle(fontSize: 80, color: Colors.white)),
              SizedBox(height: 16),
              Text(
                'BUSCAMINAS',
                style: TextStyle(
                  fontSize: 36,
                  color: Color(0xFF1B5E20),
                  fontWeight: FontWeight.bold,
                  letterSpacing: 6,
                ),
              ),
              Text(
                "FLUTTER",
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF66BB6A),
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
