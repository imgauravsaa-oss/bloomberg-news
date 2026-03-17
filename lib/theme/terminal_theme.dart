import 'package:flutter/material.dart';

class TerminalTheme {
  // Core palette
  static const Color bg = Color(0xFF0A0C0F);
  static const Color bgCard = Color(0xFF0D1117);
  static const Color bgElevated = Color(0xFF111820);
  static const Color border = Color(0xFF1E2530);
  static const Color borderLight = Color(0xFF2A3040);

  static const Color amber = Color(0xFFFF8C00);
  static const Color amberDim = Color(0xFF995400);
  static const Color textPrimary = Color(0xFFE8ECF2);
  static const Color textSecondary = Color(0xFFC8CDD6);
  static const Color textMuted = Color(0xFF7A8899);
  static const Color textDim = Color(0xFF3D4A60);

  static const Color bullGreen = Color(0xFF00D068);
  static const Color bearRed = Color(0xFFFF3333);
  static const Color urgentRed = Color(0xFFFF2200);
  static const Color warnYellow = Color(0xFFFFD166);

  // Category colors
  static const Map<String, Color> categoryColors = {
    'POLITICS': Color(0xFFE63946),
    'CONFLICT': Color(0xFFFF4500),
    'ECONOMY': Color(0xFF2EC4B6),
    'CLIMATE': Color(0xFF57CC99),
    'SOCIETY': Color(0xFFA8DADC),
    'DIPLOMACY': Color(0xFFFFD166),
    'SCIENCE': Color(0xFFC77DFF),
    'TECH': Color(0xFF4CC9F0),
    'HEALTH': Color(0xFFFF85A1),
  };

  static Color categoryColor(String cat) =>
      categoryColors[cat] ?? const Color(0xFF7A8899);

  static ThemeData get theme => ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: bg,
        colorScheme: const ColorScheme.dark(
          primary: amber,
          surface: bgCard,
        ),
        fontFamily: 'monospace',
        appBarTheme: const AppBarTheme(
          backgroundColor: bgCard,
          elevation: 0,
          centerTitle: false,
        ),
        dividerColor: border,
      );
}
