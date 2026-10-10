import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';

class EAduanApp extends StatelessWidget {
  const EAduanApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'e-Aduan ICT KUYPJ',
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        colorSchemeSeed: Colors.blue,
        useMaterial3: true,
      ),

      home: const SplashScreen(),
    );
  }
}