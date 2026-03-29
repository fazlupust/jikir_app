import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/colors.dart';

class AppTheme {
  static ThemeData getTheme(String themeName) {
    final colors = AppColors.getColors(themeName);
    
    // We base the brightness off the background. 
    // Light theme has a bright background, others are dark themes.
    final bool isLight = themeName.toLowerCase() == 'light';

    return ThemeData(
      brightness: isLight ? Brightness.light : Brightness.dark,
      scaffoldBackgroundColor: colors.bg,
      primaryColor: colors.gold,
      colorScheme: ColorScheme(
        brightness: isLight ? Brightness.light : Brightness.dark,
        primary: colors.gold,
        onPrimary: Colors.black,
        secondary: colors.accent,
        onSecondary: Colors.black,
        error: Colors.redAccent,
        onError: Colors.white,
        background: colors.bg,
        onBackground: colors.txt,
        surface: colors.surf,
        onSurface: colors.txt,
      ),
      cardColor: colors.card,
      dividerColor: colors.bdr,
      textTheme: TextTheme(
        bodyLarge: GoogleFonts.dmSans(color: colors.txt),
        bodyMedium: GoogleFonts.dmSans(color: colors.txt2),
        bodySmall: GoogleFonts.dmSans(color: colors.txt3),
        displayLarge: GoogleFonts.cinzel(color: colors.gold, fontWeight: FontWeight.bold),
        displayMedium: GoogleFonts.cinzel(color: colors.gold),
      ),
      iconTheme: IconThemeData(color: colors.txt2),
      appBarTheme: AppBarTheme(
        backgroundColor: colors.surf,
        foregroundColor: colors.txt,
        elevation: 0,
        centerTitle: false,
        iconTheme: IconThemeData(color: colors.gold),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: colors.surf,
        selectedItemColor: colors.gold,
        unselectedItemColor: colors.txt3,
        showSelectedLabels: true,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
        selectedLabelStyle: GoogleFonts.dmSans(fontSize: 10, fontWeight: FontWeight.w600, letterSpacing: 0.8),
        unselectedLabelStyle: GoogleFonts.dmSans(fontSize: 10, fontWeight: FontWeight.w500, letterSpacing: 0.8),
      ),
      extensions: [
        ThemeColorsExtension(colors: colors),
      ],
    );
  }
}

class ThemeColorsExtension extends ThemeExtension<ThemeColorsExtension> {
  final AppColors colors;

  ThemeColorsExtension({required this.colors});

  @override
  ThemeExtension<ThemeColorsExtension> copyWith({AppColors? colors}) {
    return ThemeColorsExtension(colors: colors ?? this.colors);
  }

  @override
  ThemeExtension<ThemeColorsExtension> lerp(ThemeExtension<ThemeColorsExtension>? other, double t) {
    if (other is! ThemeColorsExtension) {
      return this;
    }
    // For simplicity, we just snap the theme extension rather than interpolating every property manually
    // since we do instantaneous theme switches in this specific app logic.
    return t < 0.5 ? this : other;
  }
}

extension AppThemeExtension on BuildContext {
  AppColors get appColors => Theme.of(this).extension<ThemeColorsExtension>()!.colors;
  
  TextStyle get arabicText => GoogleFonts.amiri(
    color: appColors.txt2,
  );
}
