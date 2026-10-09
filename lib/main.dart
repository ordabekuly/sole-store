import 'package:flutter/material.dart';

import 'screens/discovery_screen.dart';

void main() => runApp(const SoleStoreApp());

class SoleStoreApp extends StatelessWidget {
  const SoleStoreApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'SOLE — Sneaker Store',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF315D45)),
      scaffoldBackgroundColor: const Color(0xFFF6F5F0),
      appBarTheme: const AppBarTheme(backgroundColor: Color(0xFFF6F5F0)),
    ),
    home: const DiscoveryScreen(),
  );
}
