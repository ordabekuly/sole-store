import 'package:flutter/material.dart';

import 'registration_screen.dart';
import 'smart_catalog_screen.dart';
import 'global_catalog_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool updates = true;
  @override
  Widget build(BuildContext context) => Center(
    child: ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 600),
      child: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const CircleAvatar(
            radius: 42,
            child: Icon(Icons.person_outline, size: 44),
          ),
          const SizedBox(height: 16),
          Text(
            'Your profile',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 8),
          const Text('Guest · SOLE community', textAlign: TextAlign.center),
          const SizedBox(height: 24),
          Card(
            child: SwitchListTile(
              title: const Text('Collection updates'),
              subtitle: const Text(
                'Demo preference · saved during this session',
              ),
              value: updates,
              onChanged: (value) => setState(() => updates = value),
            ),
          ),
          const SizedBox(height: 12),
          FilledButton.icon(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute<void>(
                builder: (_) => const RegistrationScreen(),
              ),
            ),
            icon: const Icon(Icons.person_add_alt_1_outlined),
            label: const Text('Set up profile'),
          ),
          const SizedBox(height: 24),
          OutlinedButton.icon(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute<void>(
                builder: (_) => const SmartCatalogScreen(),
              ),
            ),
            icon: const Icon(Icons.dynamic_feed),
            label: const Text('LW8 Smart Catalog'),
          ),
          OutlinedButton.icon(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute<void>(
                builder: (_) => const GlobalCatalogScreen(),
              ),
            ),
            icon: const Icon(Icons.shopping_cart_outlined),
            label: const Text('LW9 Global Cart'),
          ),
          const Text(
            'SOLE · LAB 7\nDiscover. Save. Make it yours.',
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ),
  );
}
