import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/chat_provider.dart';
import 'providers/history_provider.dart';
import 'providers/settings_provider.dart';
import 'screens/chat_screen.dart';
import 'theme/app_theme.dart';

void main() {
  runApp(const NeuraAsterApp());
}

class NeuraAsterApp extends StatefulWidget {
  const NeuraAsterApp({super.key});

  @override
  State<NeuraAsterApp> createState() => _NeuraAsterAppState();
}

class _NeuraAsterAppState extends State<NeuraAsterApp> {
  late final SettingsProvider _settings;
  late final HistoryProvider _history;
  late final ChatProvider _chat;

  @override
  void initState() {
    super.initState();
    _settings = SettingsProvider();
    _history = HistoryProvider();
    _chat = ChatProvider(historyProvider: _history);
    _settings.load();
    _history.load();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: _settings),
        ChangeNotifierProvider.value(value: _history),
        ChangeNotifierProvider.value(value: _chat),
      ],
      child: Consumer<SettingsProvider>(
        builder: (context, settings, _) {
          return MaterialApp(
            title: 'NeuraAster',
            debugShowCheckedModeBanner: false,
            themeMode: settings.themeMode,
            theme: AppTheme.light(settings.accentColor),
            darkTheme: AppTheme.dark(settings.accentColor),
            home: const ChatScreen(),
          );
        },
      ),
    );
  }
}
