import 'package:flutter/material.dart';

class InstruccionesScreen extends StatelessWidget {
  const InstruccionesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cómo jugar'),
        backgroundColor: Colors.green[800],
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('🎯 Objetivo', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const Text('Descubre todas las casillas que NO contienen minas.'),
            const SizedBox(height: 20),
            const Text('🕹️ Reglas', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const Text('• Toca una casilla para revelarla.'),
            const Text('• Mantén presionado para poner/ quitar una bandera 🚩.'),
            const Text('• Los números indican cuántas minas hay alrededor.'),
            const Text('• Si tocas una mina 💣, pierdes.'),
            const SizedBox(height: 20),
            const Text('📊 Dificultades', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const Text('Fácil: 6x6 con 10 minas'),
            const Text('Medio: 8x8 con 20 minas'),
            const Text('Difícil: 10x10 con 30 minas'),
            const Spacer(),
            Center(
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Volver al menú'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}