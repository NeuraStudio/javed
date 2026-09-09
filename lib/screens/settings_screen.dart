import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/settings_provider.dart';
import '../providers/history_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  static const _accentSwatches = [
    Color(0xFF5B8DEF), // blue
    Color(0xFFA855F7), // violet
    Color(0xFF22D3EE), // cyan
    Color(0xFFEF4444), // red
    Color(0xFF22C55E), // green
    Color(0xFFF59E0B), // amber
  ];

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsProvider>();
    final history = context.read<HistoryProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          const _SectionHeader('Appearance'),
          ListTile(
            title: const Text('Theme'),
            subtitle: Text(settings.themeMode.name),
            trailing: DropdownButton<ThemeMode>(
              value: settings.themeMode,
              dropdownColor: Colors.grey[900],
              items: const [
                DropdownMenuItem(value: ThemeMode.system, child: Text('System')),
                DropdownMenuItem(value: ThemeMode.light, child: Text('Light')),
                DropdownMenuItem(value: ThemeMode.dark, child: Text('Dark')),
              ],
              onChanged: (v) {
                if (v != null) settings.setThemeMode(v);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Wrap(
              spacing: 12,
              children: _accentSwatches.map((c) {
                final selected = c.value == settings.accentColor.value;
                return GestureDetector(
                  onTap: () => settings.setAccentColor(c),
                  child: CircleAvatar(
                    radius: 18,
                    backgroundColor: c,
                    child: selected ? const Icon(Icons.check, color: Colors.white, size: 18) : null,
                  ),
                );
              }).toList(),
            ),
          ),
          const Divider(),
          const _SectionHeader('Voice'),
          ListTile(
            title: const Text('Voice gender'),
            trailing: DropdownButton<String>(
              value: settings.voiceGender,
              dropdownColor: Colors.grey[900],
              items: const [
                DropdownMenuItem(value: 'female', child: Text('Female')),
                DropdownMenuItem(value: 'male', child: Text('Male')),
              ],
              onChanged: (v) {
                if (v != null) settings.setVoiceGender(v);
              },
            ),
          ),
          ListTile(
            title: const Text('Voice language'),
            trailing: DropdownButton<String>(
              value: settings.voiceLang,
              dropdownColor: Colors.grey[900],
              items: const [
                DropdownMenuItem(value: 'hindi', child: Text('Hindi')),
                DropdownMenuItem(value: 'english', child: Text('English')),
                DropdownMenuItem(value: 'urdu', child: Text('Urdu')),
              ],
              onChanged: (v) {
                if (v != null) settings.setVoiceLang(v);
              },
            ),
          ),
          const Divider(),
          const _SectionHeader('General'),
          ListTile(
            leading: const Icon(Icons.delete_forever_outlined),
            title: const Text('Clear all chat history'),
            subtitle: const Text('Deletes all saved conversations from this device'),
            onTap: () async {
              final confirm = await showDialog<bool>(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: const Text('Clear all history?'),
                  content: const Text('This cannot be undone.'),
                  actions: [
                    TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
                    TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Clear')),
                  ],
                ),
              );
              if (confirm == true) {
                await history.clearAllHistory();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('History cleared')),
                  );
                }
              }
            },
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: Text(title, style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
    );
  }
}
