import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/history_provider.dart';
import '../config/api_config.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final history = context.watch<HistoryProvider>();
    final totalSessions = history.sessions.length;
    final totalMessages = history.sessions.fold<int>(0, (sum, s) => sum + s.messages.length);

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const CircleAvatar(
            radius: 36,
            backgroundImage: AssetImage('assets/images/logo.png'),
          ),
          const SizedBox(height: 12),
          const Center(
            child: Text('NeuraAster', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 24),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _Stat(label: 'Chats', value: '$totalSessions'),
                  _Stat(label: 'Messages', value: '$totalMessages'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          ListTile(
            leading: const Icon(Icons.dns_outlined),
            title: const Text('Backend'),
            subtitle: const Text(ApiConfig.baseUrl),
          ),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('About NeuraAster'),
            subtitle: const Text('Your own AI assistant, powered by your backend.'),
          ),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  final String label;
  final String value;
  const _Stat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(color: Colors.grey)),
      ],
    );
  }
}
