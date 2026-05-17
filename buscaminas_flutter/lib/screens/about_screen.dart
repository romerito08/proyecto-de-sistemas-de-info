import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Créditos')),
      body: Center(
        child: Text(
          'Sofia Romero: 20241120007 \n\n Jorge Luis García: 20241120008\n\n Proyecto de Microprogramación - Buscaminas en Flutter\n\n Periodo: 2526-3',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
