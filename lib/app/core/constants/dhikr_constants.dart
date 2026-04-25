import 'package:flutter/material.dart';

class DhikrItem {
  final String id;
  final String ar;
  final String en;
  final String bn;
  final String meaning;
  final Color color;
  final int target;

  const DhikrItem({
    required this.id,
    required this.ar,
    required this.en,
    required this.bn,
    required this.meaning,
    required this.color,
    required this.target,
  });
}

class DhikrConstants {
  static const List<DhikrItem> dhikrs = [
    DhikrItem(
      id: 'subhanallah',
      ar: 'سُبْحَانَ اللّٰه',
      bn: 'সুবহানাল্লাহ',
      en: 'Subhanallah',
      meaning: 'আল্লাহ অতি পবিত্র',
      color: Color(0xFF4ade80),
      target: 33,
    ),
    DhikrItem(
      id: 'subhanallah_wa_bihamdihi',
      ar: 'سُبْحَانَ اللَّهِ وَبِحَمْدِهِ',
      bn: 'সুবহানাল্লাহি ওয়া বিহামদিহি',
      en: 'Subhanallahi Wa Bihamdihi',
      meaning: 'আল্লাহ অতি পবিত্র এবং সমস্ত প্রশংসা তাঁরই',
      color: Color(0xFF8b5cf6),
      target: 100,
    ),
    DhikrItem(
      id: 'laelaha',
      ar: 'لَا إِلَٰهَ إِلَّا اللّٰه',
      bn: 'লা ইলাহা ইল্লাল্লাহ',
      en: 'La Elaha Illela',
      meaning: 'আল্লাহ ছাড়া কোনো উপাস্য নেই',
      color: Color(0xFF60a5fa),
      target: 33,
    ),
    DhikrItem(
      id: 'allahuakbar',
      ar: 'اللّٰهُ أَكْبَر',
      bn: 'আল্লাহু আকবার',
      en: 'Allahu Akbar',
      meaning: 'আল্লাহ সর্বশ্রেষ্ঠ',
      color: Color(0xFFf97316),
      target: 34,
    ),
    DhikrItem(
      id: 'alhamdulillah',
      ar: 'الْحَمْدُ لِلّٰه',
      bn: 'আলহামদুলিল্লাহ',
      en: 'Alhamdulillah',
      meaning: 'সকল প্রশংসা আল্লাহর জন্য',
      color: Color(0xFFe879f9),
      target: 33,
    ),
    DhikrItem(
      id: 'astaghfirullah',
      ar: 'أَسْتَغْفِرُ اللّٰه',
      bn: 'আস্তাগফিরুল্লাহ',
      en: 'Astaghfirullah',
      meaning: 'আমি আল্লাহর কাছে ক্ষমা প্রার্থনা করছি',
      color: Color(0xFFfb7185),
      target: 100,
    ),
    DhikrItem(
      id: 'salawat',
      ar: 'صَلَّى اللّٰهُ عَلَيْهِ',
      bn: 'সাল্লাল্লাহু আলাইহি ওয়াসাল্লাম',
      en: 'Salawat',
      meaning: 'নবী (সাঃ)-এর উপর রহমত বর্ষিত হোক',
      color: Color(0xFFa78bfa),
      target: 10,
    ),
    DhikrItem(
      id: 'hasbunallah',
      ar: 'حَسْبُنَا اللّٰه',
      bn: 'হাসবুনাল্লাহ',
      en: 'Hasbunallah',
      meaning: 'আল্লাহই আমাদের জন্য যথেষ্ট',
      color: Color(0xFF34d399),
      target: 33,
    ),
    DhikrItem(
      id: 'laHawla',
      ar: 'لَا حَوْلَ وَلَا قُوَّةَ إِلَّا بِاللَّهِ',
      bn: 'লা হাওলা ওয়ালা কুউওয়াতা ইল্লা বিল্লাহ',
      en: 'La Hawla Wala Quwwata Illa Billah',
      meaning:
          'আল্লাহ ছাড়া কোনো শক্তি নেই এবং আল্লাহ ছাড়া কোনো আশ্রয় বা ক্ষমতা নেই',
      color: Color(0xFFfbbf24),
      target: 33,
    ),
    DhikrItem(
      id: 'bismillah',
      ar: 'بِسْمِ اللّٰه',
      bn: 'বিসমিল্লাহ',
      en: 'Bismillah',
      meaning: 'পরম করুণাময় অসীম দয়ালু আল্লাহর নামে শুরু করছি',
      color: Color(0xFF67e8f9),
      target: 21,
    ),
    DhikrItem(
      id: 'innalillah',
      ar: 'إِنَّا لِلّٰهِ',
      bn: 'ইন্নালিল্লাহি',
      en: 'Innalillah',
      meaning: 'নিশ্চয়ই আমরা আল্লাহর জন্য এবং তাঁর কাছেই ফিরে যাব',
      color: Color(0xFF94a3b8),
      target: 10,
    ),
    DhikrItem(
      id: 'subhan_alhamdu_laelaha_allahuakbar',
      ar: 'سُبْحَانَ اللهِ، وَالْحَمْدُ لِلَّهِ، وَلَا إِلَهَ إِلَّا اللهُ، وَاللهُ أَكْبَرُ',
      bn: 'সুবহানাল্লাহ, আলহামদুলিল্লাহ, লা ইলাহা ইল্লাল্লাহ, আল্লাহু আকবার',
      en: 'Subhanallah, Alhamdulillah, La ilaha illallah, Allahu Akbar',
      meaning:
          'আল্লাহ অতি পবিত্র, সমস্ত প্রশংসা আল্লাহর, আল্লাহ ছাড়া কোনো উপাস্য নেই এবং আল্লাহ সর্বশ্রেষ্ঠ',
      color: Color(0xFF14b8a6),
      target: 33,
    ),
  ];

  static DhikrItem get(String id) {
    return dhikrs.firstWhere((d) => d.id == id, orElse: () => dhikrs.first);
  }
}
