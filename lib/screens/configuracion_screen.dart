import 'package:flutter/material.dart';
import '../services/storage_service.dart';
import '../utils/constants.dart';

class ConfiguracionScreen extends StatefulWidget {
  const ConfiguracionScreen({super.key});

  @override
  State<ConfiguracionScreen> createState() => _ConfiguracionScreenState();
}

class _ConfiguracionScreenState extends State<ConfiguracionScreen> {
  String _dificultad = 'Medio';
  String _tema = 'system';
  bool _sonido = true;
  bool _animaciones = true;
  String _estiloNumeros = NumberStyle.classic;

  @override
  void initState() {
    super.initState();
    _cargar();
  }

  void _cargar() {
    setState(() {
      _dificultad = StorageService.getDifficulty();
      _tema = StorageService.getThemeMode();
      _sonido = StorageService.getSoundEnabled();
      _animaciones = StorageService.getAnimationsEnabled();
      _estiloNumeros = StorageService.getNumberStyle();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Configuración'), backgroundColor: Colors.green[800], foregroundColor: Colors.white),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text('Dificultad', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          DropdownButtonFormField<String>(
            initialValue: _dificultad,  // 🔁 CAMBIADO: value → initialValue
            items: ['Fácil', 'Medio', 'Difícil'].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
            onChanged: (val) async {
              if (val != null) {
                setState(() => _dificultad = val);
                await StorageService.setDifficulty(val);
              }
            },
          ),
          const SizedBox(height: 20),
          const Text('Tema', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SegmentedButton<String>(
            segments: const [
              ButtonSegment(value: 'light', label: Text('Claro'), icon: Icon(Icons.light_mode)),
              ButtonSegment(value: 'dark', label: Text('Oscuro'), icon: Icon(Icons.dark_mode)),
              ButtonSegment(value: 'system', label: Text('Auto'), icon: Icon(Icons.settings)),
            ],
            selected: {_tema},
            onSelectionChanged: (Set<String> newSel) async {
              final val = newSel.first;
              setState(() => _tema = val);
              await StorageService.setThemeMode(val);
              // ignore: use_build_context_synchronously
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Reinicia la app para aplicar el tema')));
            },
          ),
          const SizedBox(height: 20),
          const Text('Estilo de números', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SegmentedButton<String>(
            segments: const [
              ButtonSegment(value: NumberStyle.classic, label: Text('Clásico')),
              ButtonSegment(value: NumberStyle.colorful, label: Text('Colorido')),
              ButtonSegment(value: NumberStyle.retro, label: Text('Retro')),
              ButtonSegment(value: NumberStyle.minimal, label: Text('Minimalista')),
            ],
            selected: {_estiloNumeros},
            onSelectionChanged: (Set<String> newSel) async {
              final val = newSel.first;
              setState(() => _estiloNumeros = val);
              await StorageService.setNumberStyle(val);
            },
          ),
          const SizedBox(height: 20),
          SwitchListTile(
            title: const Text('Efectos de sonido'),
            value: _sonido,
            onChanged: (val) async {
              setState(() => _sonido = val);
              await StorageService.setSoundEnabled(val);
            },
          ),
          SwitchListTile(
            title: const Text('Animaciones'),
            value: _animaciones,
            onChanged: (val) async {
              setState(() => _animaciones = val);
              await StorageService.setAnimationsEnabled(val);
            },
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              await StorageService.setDifficulty('Medio');
              await StorageService.setThemeMode('system');
              await StorageService.setSoundEnabled(true);
              await StorageService.setAnimationsEnabled(true);
              await StorageService.setNumberStyle(NumberStyle.classic);
              _cargar();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Configuración restablecida')));
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
            child: const Text('Restablecer', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}