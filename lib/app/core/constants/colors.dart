import 'package:flutter/material.dart';

class AppColors {
  final Color bg;
  final Color surf;
  final Color card;
  final Color card2;
  final Color bdr;
  final Color bdr2;
  final Color gold;
  final Color goldL;
  final Color goldD;
  final Color txt;
  final Color txt2;
  final Color txt3;
  final Color txt4;
  final Color accent;
  // White colors added here
  final Color white;
  final Color white2;

  const AppColors({
    required this.bg,
    required this.surf,
    required this.card,
    required this.card2,
    required this.bdr,
    required this.bdr2,
    required this.gold,
    required this.goldL,
    required this.goldD,
    required this.txt,
    required this.txt2,
    required this.txt3,
    required this.txt4,
    required this.accent,
    required this.white,
    required this.white2,
  });

  static const darkTheme = AppColors(
    bg: Color(0xFF08090d),
    surf: Color(0xFF0f1117),
    card: Color(0xFF13161f),
    card2: Color(0xFF181c27),
    bdr: Color(0xFF1e2333),
    bdr2: Color(0xFF252b3b),
    gold: Color(0xFFd4a843),
    goldL: Color(0xFFf0c96a),
    goldD: Color(0xFF7a5e20),
    txt: Color(0xFFddd5c0),
    txt2: Color(0xFF8892a4),
    txt3: Color(0xFF3d4558),
    txt4: Color(0xFFFFFFFF),
    accent: Color(0xFFd4a843),
    white: Color(0xFFFFFFFF),
    white2: Color(0xFFF5F5F5),
  );

  static const lightTheme = AppColors(
    bg: Color(0xFFf5f0e8),
    surf: Color(0xFFede8dc),
    card: Color(0xFFfff9ef),
    card2: Color(0xFFf5eedb),
    bdr: Color(0xFFd6cdb8),
    bdr2: Color(0xFFc8bfa8),
    gold: Color(0xFFd4a843),
    goldL: Color(0xFFf0c96a),
    goldD: Color(0xFF7a5e20),
    txt: Color(0xFF2a2318),
    txt2: Color(0xFF6b5e48),
    txt3: Color(0xFFa89880),
    txt4: Color(0xFF1A1A1A), // Added missing txt4 for light
    accent: Color(0xFFd4a843),
    white: Color(0xFFFFFFFF),
    white2: Color(0xFFFAFAFA),
  );

  static const oceanTheme = AppColors(
    bg: Color(0xFF040d18),
    surf: Color(0xFF071525),
    card: Color(0xFF0a1e30),
    card2: Color(0xFF0d2540),
    bdr: Color(0xFF0e2d45),
    bdr2: Color(0xFF143858),
    gold: Color(0xFF38bdf8),
    goldL: Color(0xFF7dd3fc),
    goldD: Color(0xFF0c4a6e),
    txt: Color(0xFFcce6f8),
    txt2: Color(0xFF6b9ab8),
    txt3: Color(0xFF2a4a60),
    txt4: Color(0xFFE0F2FE), // Added missing txt4
    accent: Color(0xFF38bdf8),
    white: Color(0xFFFFFFFF),
    white2: Color(0xFFEBF8FF),
  );

  static const emeraldTheme = AppColors(
    bg: Color(0xFF030d08),
    surf: Color(0xFF061710),
    card: Color(0xFF0a2016),
    card2: Color(0xFF0e2a1c),
    bdr: Color(0xFF113424),
    bdr2: Color(0xFF174430),
    gold: Color(0xFF4ade80),
    goldL: Color(0xFF86efac),
    goldD: Color(0xFF14532d),
    txt: Color(0xFFc6f0d8),
    txt2: Color(0xFF5a9472),
    txt3: Color(0xFF234d35),
    txt4: Color(0xFFDCFCE7), // Added missing txt4
    accent: Color(0xFF4ade80),
    white: Color(0xFFFFFFFF),
    white2: Color(0xFFF0FDF4),
  );

  static const roseTheme = AppColors(
    bg: Color(0xFF0e060a),
    surf: Color(0xFF180d13),
    card: Color(0xFF1e1018),
    card2: Color(0xFF251420),
    bdr: Color(0xFF2e1824),
    bdr2: Color(0xFF3d2030),
    gold: Color(0xFFfb7185),
    goldL: Color(0xFFfda4af),
    goldD: Color(0xFF881337),
    txt: Color(0xFFfce7f0),
    txt2: Color(0xFFb06070),
    txt3: Color(0xFF5a2535),
    txt4: Color(0xFFFFF1F2), // Added missing txt4
    accent: Color(0xFFfb7185),
    white: Color(0xFFFFFFFF),
    white2: Color(0xFFFFF5F7),
  );

  static AppColors getColors(String themeName) {
    switch (themeName.toLowerCase()) {
      case 'light':
        return lightTheme;
      case 'ocean':
        return oceanTheme;
      case 'emerald':
        return emeraldTheme;
      case 'rose':
        return roseTheme;
      case 'dark':
      default:
        return darkTheme;
    }
  }
}