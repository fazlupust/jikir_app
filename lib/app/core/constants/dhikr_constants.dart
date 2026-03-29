import 'package:flutter/material.dart';

class DhikrItem {
  final String id;
  final String ar;
  final String en;
  final String meaning;
  final Color color;
  final int target;

  const DhikrItem({
    required this.id,
    required this.ar,
    required this.en,
    required this.meaning,
    required this.color,
    required this.target,
  });
}

class DhikrConstants {
  static const List<DhikrItem> dhikrs = [
    DhikrItem(id: 'subhanallah', ar: 'سُبْحَانَ اللّٰه', en: 'Subhanallah', meaning: 'Glory be to Allah', color: Color(0xFF4ade80), target: 33),
    DhikrItem(id: 'laelaha', ar: 'لَا إِلَٰهَ إِلَّا اللّٰه', en: 'La Elaha Illela', meaning: 'There is no god but Allah', color: Color(0xFF60a5fa), target: 33),
    DhikrItem(id: 'allahuakbar', ar: 'اللّٰهُ أَكْبَر', en: 'Allahu Akbar', meaning: 'Allah is the Greatest', color: Color(0xFFf97316), target: 34),
    DhikrItem(id: 'alhamdulillah', ar: 'الْحَمْدُ لِلّٰه', en: 'Alhamdulillah', meaning: 'Praise be to Allah', color: Color(0xFFe879f9), target: 33),
    DhikrItem(id: 'astaghfirullah', ar: 'أَسْتَغْفِرُ اللّٰه', en: 'Astaghfirullah', meaning: 'I seek forgiveness from Allah', color: Color(0xFFfb7185), target: 100),
    DhikrItem(id: 'salawat', ar: 'صَلَّى اللّٰهُ عَلَيْهِ', en: 'Salawat', meaning: 'Blessings on the Prophet ﷺ', color: Color(0xFFa78bfa), target: 10),
    DhikrItem(id: 'hasbunallah', ar: 'حَسْبُنَا اللّٰه', en: 'Hasbunallah', meaning: 'Allah is sufficient for us', color: Color(0xFF34d399), target: 33),
    DhikrItem(id: 'laHawla', ar: 'لَا حَوْلَ وَلَا قُوَّةَ', en: 'La Hawla', meaning: 'No power except with Allah', color: Color(0xFFfbbf24), target: 33),
    DhikrItem(id: 'bismillah', ar: 'بِسْمِ اللّٰه', en: 'Bismillah', meaning: 'In the name of Allah', color: Color(0xFF67e8f9), target: 21),
    DhikrItem(id: 'innalillah', ar: 'إِنَّا لِلّٰهِ', en: 'Innalillah', meaning: 'Indeed we belong to Allah', color: Color(0xFF94a3b8), target: 10),
  ];

  static DhikrItem get(String id) {
    return dhikrs.firstWhere((d) => d.id == id, orElse: () => dhikrs.first);
  }
}
