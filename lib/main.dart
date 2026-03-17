import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'services/news_provider.dart';
import 'screens/home_screen.dart';
import 'screens/api_key_screen.dart';
import 'theme/terminal_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarColor: TerminalTheme.bgCard,
    systemNavigationBarIconBrightness: Brightness.light,
  ));

  final prefs = await SharedPreferences.getInstance();
  final hasKey = prefs.containsKey('anthropic_api_key') &&
      (prefs.getString('anthropic_api_key') ?? '').isNotEmpty;

  runApp(BloombergNewsApp(hasKey: hasKey));
}

class BloombergNewsApp extends StatelessWidget {
  final bool hasKey;
  const BloombergNewsApp({super.key, required this.hasKey});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => NewsProvider()..startAutoRefresh(),
      child: MaterialApp(
        title: 'Claude Terminal',
        debugShowCheckedModeBanner: false,
        theme: TerminalTheme.theme,
        home: hasKey ? const HomeScreen() : const ApiKeyScreen(),
      ),
    );
  }
}
