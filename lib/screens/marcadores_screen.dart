import 'package:flutter/material.dart';
import '../services/storage_service.dart';
import '../utils/constants.dart';

class MarcadoresScreen extends StatelessWidget {
  const MarcadoresScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Marcadores'),
        backgroundColor: Colors.green[800],
        foregroundColor: Colors.white,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: Difficulty.levels.map((diff) {
          var score = StorageService.getHighScore(diff.name);
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: ListTile(
              title: Text(diff.name, style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: score == null
                  ? const Text('Sin registros aún')
                  : Text('Tiempo: ${score['time']} s · Intentos: ${score['attempts']} · ${score['date']}'),
            ),
          );
        }).toList(),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await StorageService.clearAllHighScores();
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Marcadores borrados')));
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const MarcadoresScreen()));
          }
        },
        icon: const Icon(Icons.delete),
        label: const Text('Borrar todo'),
        backgroundColor: Colors.red,
      ),
    );
  }
}