import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Créditos')),
      body: Center(
        child: Text(
          'Sofia Romero: 20241120007 \n Gianfraco Camporeale: 20251110476\n\n Proyecto de Microprogramación - Buscaminas en Flutter\n Periodo: 2526-3\n Materia: Sistemas de información\n Profesor: Franklin Sandoval',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
