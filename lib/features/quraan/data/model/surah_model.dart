import 'package:fourtyninehub/features/quraan/domain/entity/surah_entity.dart';

class SurahModel extends SurahEntity {
  SurahModel(
      {required super.surahNo,
      required super.surahNameAr,
      required super.ayahNoSurah,
      required super.ayahAr,
      required super.juzNo,
      required super.hizbQuarter,
      required super.placeOfRevelation,
      required super.sajahAyah});

  factory SurahModel.fromJson(Map<String, dynamic> json) {
    return SurahModel(
      surahNo: json['surah_no'] ?? 0,
      surahNameAr: json['surah_name_ar'] ?? '',
      ayahNoSurah: json['ayah_no_surah'] ?? 0,
      ayahAr: json['ayah_ar'] ?? '',
      juzNo: json['juz_no'] ?? 0,
      hizbQuarter: json['hizb_quarter'] ?? 0,
      placeOfRevelation: json['place_of_revelation'] ?? '',
      sajahAyah: json['sajah_ayah'] ?? 0,
    );
  }
}
