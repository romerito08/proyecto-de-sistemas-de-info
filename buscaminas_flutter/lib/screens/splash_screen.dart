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
      duration: const Duration(seconds: 2),
    );

    _fadeAnim = Tween<double>(begin: 0, end: 1).animate(_controller);
    _controller.forward();

    Future.delayed(const Duration(seconds: 2), () {
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
      backgroundColor: const Color(0xFF0D1B2A),
      body: Center(
        child: FadeTransition(
          opacity: _fadeAnim,
          child: const Column(
            children: [
              Text('💣', style: TextStyle(fontSize: 80, color: Colors.white)),
              SizedBox(height: 16),
              Text(
                'BUSCAMINAS',
                style: TextStyle(
                  fontSize: 36,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 6,
                ),
              ),
              Text(
                "FLUTTER",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
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
