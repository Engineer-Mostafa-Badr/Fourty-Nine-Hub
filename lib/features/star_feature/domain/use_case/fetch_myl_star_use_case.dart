import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/star_feature/domain/entity/star_entity.dart';
import 'package:fourtyninehub/features/star_feature/domain/repository/star_repository.dart';

class FetchMylStarUseCase extends UseCase<List<StarEntity>, NoParams> {
  final StarRepository _starRepository;

  FetchMylStarUseCase(this._starRepository);
  @override
  Future<Either<Failure, List<StarEntity>>> call(NoParams params) async {
    return await _starRepository.fetchMyStar();
  }
}
