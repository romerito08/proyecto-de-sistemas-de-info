import 'package:flutter/material.dart';
import 'services/storage_service.dart';
import 'screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await StorageService.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Por ahora tema fijo, después se puede hacer dinámico según configuración
    return const MaterialApp(
      title: 'Buscaminas',
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}