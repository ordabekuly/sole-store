import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/cart_provider.dart';
import 'providers/cloud_cart_provider.dart';
import 'providers/vault_provider.dart';
import 'screens/discovery_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    // All persisted settings are loaded before the first application frame.
    final vault = await VaultProvider.load();
    runApp(SoleStoreApp(vault: vault));
  } catch (_) {
    runApp(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Local storage could not be opened.'),
                ElevatedButton(
                  onPressed: main,
                  child: const Text('Retry storage'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SoleStoreApp extends StatelessWidget {
  final VaultProvider? vault;
  const SoleStoreApp({super.key, this.vault});
  @override
  Widget build(BuildContext context) => MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => CartProvider()),
      ChangeNotifierProvider(create: (_) => CloudCartProvider()),
      ChangeNotifierProvider(create: (_) => vault ?? VaultProvider.memory()),
    ],
    child: Consumer<VaultProvider>(
      builder: (_, settings, child) => MaterialApp(
        title: 'SOLE — Sneaker Store',
        debugShowCheckedModeBanner: false,
        themeMode: settings.darkMode ? ThemeMode.dark : ThemeMode.light,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF315D45)),
          scaffoldBackgroundColor: const Color(0xFFF6F5F0),
          appBarTheme: const AppBarTheme(backgroundColor: Color(0xFFF6F5F0)),
        ),
        darkTheme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF8CCDA5),
            brightness: Brightness.dark,
          ),
        ),
        home: const DiscoveryScreen(),
      ),
    ),
  );
}
