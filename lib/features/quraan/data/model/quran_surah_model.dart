import 'package:fourtyninehub/features/quraan/domain/entity/quran_surah_entity.dart';

class QuranSurahModel extends QuranSurahEntity {
  QuranSurahModel({required super.surahNameAr, required super.surahNo});

  factory QuranSurahModel.fromJson(Map<String, dynamic> json) {
    return QuranSurahModel(
      surahNameAr: json['surah_name_ar'] ?? '',
      surahNo: json['surah_no'] ?? 0,
    );
  }
}
