import 'package:fourtyninehub/features/quraan/domain/entity/quran_surah_entity.dart';

class QuranSurahModel extends QuranSurahEntity {
  QuranSurahModel({
    required super.surahNameAr,
    required super.surahNo,
    required super.place_of_revelation,
    required super.total_ayah_surah,
  });

  factory QuranSurahModel.fromJson(Map<String, dynamic> json) {
    return QuranSurahModel(
      surahNameAr: json['surah_name_ar'] ?? '',
      surahNo: json['surah_no'] ?? 0,
      place_of_revelation: json['place_of_revelation'] ?? '',
      total_ayah_surah: json['total_ayah_surah'] ?? 0,
    );
  }
}
