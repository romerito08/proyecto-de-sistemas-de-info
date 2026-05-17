import 'package:flutter/material.dart';
import 'juego_screen.dart';
import 'marcadores_screen.dart';
import 'configuracion_screen.dart';
import 'instrucciones_screen.dart';

class MenuPrincipal extends StatelessWidget {
  const MenuPrincipal({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green[900],
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const Spacer(flex: 1),
              const Text('💣', style: TextStyle(fontSize: 60)),
              Text(
                'BUSCAMINAS',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.amber[300],
                  shadows: const [Shadow(offset: Offset(3, 3), blurRadius: 6)],
                ),
              ),
              const Spacer(flex: 2),
              _botonMenu('JUGAR', Icons.play_arrow, Colors.red, () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const JuegoScreen()));
              }),
              const SizedBox(height: 15),
              _botonMenu('MARCADORES', Icons.leaderboard, Colors.blue, () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const MarcadoresScreen()));
              }),
              const SizedBox(height: 15),
              _botonMenu('CONFIGURACIÓN', Icons.settings, Colors.grey, () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const ConfiguracionScreen()));
              }),
              const SizedBox(height: 15),
              _botonMenu('INSTRUCCIONES', Icons.help_outline, Colors.teal, () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => const InstruccionesScreen()));
              }),
              const Spacer(flex: 1),
            ],
          ),
        ),
      ),
    );
  }

  Widget _botonMenu(String texto, IconData icono, Color color, VoidCallback alPresionar) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: alPresionar,
        icon: Icon(icono, color: Colors.white),
        label: Text(texto, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: const EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        ),
      ),
    );
  }
}