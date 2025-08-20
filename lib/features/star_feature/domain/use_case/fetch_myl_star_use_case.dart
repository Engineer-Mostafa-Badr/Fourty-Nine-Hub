import 'package:dartz/dartz.dart';
import '../../../../core/abstract/use_case.dart';
import '../../../../core/error/failure.dart';
import '../entity/star_entity.dart';
import '../repository/star_repository.dart';

class FetchMylStarUseCase extends UseCase<List<StarEntity>, NoParams> {
  final StarRepository _starRepository;

  FetchMylStarUseCase(this._starRepository);
  @override
  Future<Either<Failure, List<StarEntity>>> call(NoParams params) async {
    return await _starRepository.fetchMyStar();
  }
}
