import 'package:flutter/material.dart';
 
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});
 
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Configuración')),
      body: const _SettingsBody(),
    );
  }
}
 
class _SettingsBody extends StatefulWidget {
  const _SettingsBody();
 
  @override
  State<_SettingsBody> createState() => _SettingsBodyState();
}
 
class _SettingsBodyState extends State<_SettingsBody> {
  String _difficulty = 'Fácil';
  bool _vibration = true;
  bool _sound = true;
 
  final List<Map<String, String>> _difficulties = [
    {'label': 'Fácil',   'desc': '6×6 · 10 minas'},
    {'label': 'Medio',   'desc': '8×8 · 20 minas'},
    {'label': 'Difícil', 'desc': '10×10 · 30 minas'},
  ];
 
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
 
        // ── Dificultad ──────────────────────────────────────────
        const Text(
          '🎯 Dificultad',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1B5E20),
          ),
        ),
        const SizedBox(height: 10),
        ..._difficulties.map((d) {
          final selected = _difficulty == d['label'];
          return GestureDetector(
            onTap: () => setState(() => _difficulty = d['label']!),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: selected ? const Color(0xFF2E7D32) : Colors.white,
                border: Border.all(
                  color: selected
                      ? const Color(0xFF2E7D32)
                      : const Color(0xFFC8E6C9),
                  width: 1.5,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(
                    selected
                        ? Icons.radio_button_checked
                        : Icons.radio_button_off,
                    color: selected ? Colors.white : const Color(0xFF81C784),
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        d['label']!,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: selected ? Colors.white : const Color(0xFF2E7D32),
                        ),
                      ),
                      Text(
                        d['desc']!,
                        style: TextStyle(
                          fontSize: 12,
                          color: selected ? Colors.white70 : Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }),
 
        const SizedBox(height: 28),
 
        // ── Opciones ────────────────────────────────────────────
        const Text(
          '🔧 Opciones',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1B5E20),
          ),
        ),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFC8E6C9)),
          ),
          child: Column(
            children: [
              SwitchListTile(
                title: const Text('Sonido'),
                subtitle: const Text('Efectos de sonido del juego'),
                value: _sound,
                activeColor: const Color(0xFF2E7D32),
                onChanged: (v) => setState(() => _sound = v),
              ),
              const Divider(height: 1),
              SwitchListTile(
                title: const Text('Vibración'),
                subtitle: const Text('Vibrar al revelar una mina'),
                value: _vibration,
                activeColor: const Color(0xFF2E7D32),
                onChanged: (v) => setState(() => _vibration = v),
              ),
            ],
          ),
        ),
 
        const SizedBox(height: 32),
 
        // ── Botón guardar ───────────────────────────────────────
        ElevatedButton.icon(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('✅ Configuración guardada'),
                duration: Duration(seconds: 1),
              ),
            );
          },
          icon: const Icon(Icons.save),
          label: const Text('Guardar configuración'),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF2E7D32),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ],
    );
  }
}