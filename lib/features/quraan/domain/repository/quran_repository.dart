import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/quraan/domain/entity/quran_surah_entity.dart';
import 'package:fourtyninehub/features/quraan/domain/entity/surah_entity.dart';
import 'package:fourtyninehub/features/quraan/domain/use_case/fetch_quran_surah_use_case.dart';

abstract class QuranRepository{
  Future<Either<Failure,List<QuranSurahEntity>>> fetchQuranSurah(QuranParams params);
  Future<Either<Failure,List<SurahEntity>>> fetchSurah({required int id});
}