import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/quraan/domain/entity/surah_entity.dart';
import 'package:fourtyninehub/features/quraan/domain/repository/quran_repository.dart';

class FetchSurahUseCase extends UseCase<List<SurahEntity>, int> {
  final QuranRepository _quranRepository;

  FetchSurahUseCase(this._quranRepository);
  @override
  Future<Either<Failure, List<SurahEntity>>> call(int params) async {
    return await _quranRepository.fetchSurah(id: params);
  }
}
