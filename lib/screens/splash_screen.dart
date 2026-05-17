import 'package:flutter/material.dart';
import 'menu_principal.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MenuPrincipal()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[800],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('💣', style: TextStyle(fontSize: 80)),
            const SizedBox(height: 20),
            Text(
              'BUSCAMINAS',
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Colors.yellow[700],
                shadows: const [Shadow(offset: Offset(2, 2), blurRadius: 4)],
              ),
            ),
            const SizedBox(height: 10),
            const Text('FLUTTER', style: TextStyle(color: Colors.white70)),
          ],
        ),
      ),
    );
  }
}