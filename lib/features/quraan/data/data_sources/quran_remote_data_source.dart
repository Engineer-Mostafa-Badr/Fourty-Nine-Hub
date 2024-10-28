import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/api_consumer.dart';
import 'package:fourtyninehub/core/data/datasources/remote/api/end_points.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/quraan/data/model/quran_surah_model.dart';
import 'package:fourtyninehub/features/quraan/data/model/surah_model.dart';
import 'package:fourtyninehub/features/quraan/domain/entity/quran_surah_entity.dart';
import 'package:fourtyninehub/features/quraan/domain/entity/surah_entity.dart';
import 'package:fourtyninehub/features/quraan/domain/use_case/fetch_quran_surah_use_case.dart';

abstract class QuranRemoteDataSource {
  Future<Either<Failure,List<QuranSurahEntity>>> fetchQuranSurah(QuranParams params);
  Future<Either<Failure,List<SurahEntity>>> fetchSurah({required int id});

}

class QuranRemoteDataSourceImpl implements QuranRemoteDataSource {
  final ApiConsumer _apiConsumer;

  QuranRemoteDataSourceImpl(this._apiConsumer);

  @override
  Future<Either<Failure, List<QuranSurahEntity>>> fetchQuranSurah(QuranParams params) async {
    final result = await _apiConsumer.get(EndPoints.quranSurah(params));
    return result.fold(
      (failure) => Left(failure),
      (response) {
        final list = (response['data'] as List)
            .map((e) => QuranSurahModel.fromJson(e))
            .toList();
        return Right(list);
      },
    );
  }

  @override
  Future<Either<Failure, List<SurahEntity>>> fetchSurah({required int id}) async {
    final result = await _apiConsumer.get(EndPoints.quran(id));
    return result.fold(
      (failure) => Left(failure),
      (response) {
        final list = (response['data'] as List)
            .map((e) => SurahModel.fromJson(e))
            .toList();
        return Right(list,);
      },
    );
  }
}
