import 'package:dartz/dartz.dart';
import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';
import '../entity/filter_entity.dart';
import '../repository/snap_repository.dart';

class FetchFilterSnapUseCase extends UseCase<List<FilterEntity>, NoParams> {
  final SnapRepository _repository;

  FetchFilterSnapUseCase(this._repository);
  @override
  Future<Either<Failure, List<FilterEntity>>> call(NoParams params) async {
    return await _repository.fetchFilter();
  }
}
