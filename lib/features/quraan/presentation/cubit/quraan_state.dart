import 'package:fourtyninehub/features/quraan/domain/entity/quran_surah_entity.dart';
import 'package:fourtyninehub/features/quraan/domain/entity/surah_entity.dart';

import '../../../../../../core/error/failure.dart';

enum QuranStates { loading, initial, error, success }

class QuranState {
  final QuranStates status;
  final Failure? failure;
  final List<QuranSurahEntity>? quranSurah;
  final List<SurahEntity>? surah;

  const QuranState({
    this.status = QuranStates.loading,
    this.failure,
    this.quranSurah,
    this.surah,
  });
  QuranState copyWith(
      {QuranStates? status,
      Failure? failure,
      List<QuranSurahEntity>? quranSurah,
      List<SurahEntity>? surah}) {
    return QuranState(
      status: status ?? this.status,
      failure: failure ?? this.failure,
      quranSurah: quranSurah ?? this.quranSurah,
      surah: surah ?? this.surah,
    );
  }
}
