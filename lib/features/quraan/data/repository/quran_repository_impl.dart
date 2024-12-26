import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/quraan/data/data_sources/quran_remote_data_source.dart';
import 'package:fourtyninehub/features/quraan/domain/entity/quran_surah_entity.dart';
import 'package:fourtyninehub/features/quraan/domain/entity/surah_entity.dart';
import 'package:fourtyninehub/features/quraan/domain/repository/quran_repository.dart';
import 'package:fourtyninehub/features/quraan/domain/use_case/fetch_quran_surah_use_case.dart';

class QuranRepositoryImpl extends QuranRepository {
  final QuranRemoteDataSource _remoteDataSource;

  QuranRepositoryImpl(this._remoteDataSource);
  @override
  Future<Either<Failure, List<QuranSurahEntity>>> fetchQuranSurah(
      QuranParams params) {
    return _remoteDataSource.fetchQuranSurah(params);
  }

  @override
  Future<Either<Failure, List<SurahEntity>>> fetchSurah({required int id}) {
    return _remoteDataSource.fetchSurah(id: id);
  }
}
