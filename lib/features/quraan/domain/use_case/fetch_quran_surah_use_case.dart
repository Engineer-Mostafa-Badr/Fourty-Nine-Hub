import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/quraan/domain/entity/quran_surah_entity.dart';
import 'package:fourtyninehub/features/quraan/domain/repository/quran_repository.dart';

class FetchQuranSurahUseCase extends UseCase<List<QuranSurahEntity>,NoParams>{
  final QuranRepository _quranRepository;

  FetchQuranSurahUseCase(this._quranRepository);
  @override
  Future<Either<Failure, List<QuranSurahEntity>>> call(params) async{
    return await _quranRepository.fetchQuranSurah();
  }


}
//
// class QuranParams {
//   final PaginationParams params;
//
//   QuranParams(
//       { required this.params, });
// }