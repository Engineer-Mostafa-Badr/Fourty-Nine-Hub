import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/quraan/domain/entity/quran_surah_entity.dart';
import 'package:fourtyninehub/features/quraan/domain/entity/surah_entity.dart';

abstract class QuranRepository{
  Future<Either<Failure,List<QuranSurahEntity>>> fetchQuranSurah();
  Future<Either<Failure,List<SurahEntity>>> fetchSurah({required int id});
}