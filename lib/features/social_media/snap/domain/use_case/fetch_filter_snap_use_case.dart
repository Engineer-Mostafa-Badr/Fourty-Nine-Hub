import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/social_media/snap/domain/entity/filter_entity.dart';
import 'package:fourtyninehub/features/social_media/snap/domain/repository/snap_repository.dart';

class FetchFilterSnapUseCase extends UseCase<List<FilterEntity>, NoParams> {
  final SnapRepository _repository;

  FetchFilterSnapUseCase(this._repository);
  @override
  Future<Either<Failure, List<FilterEntity>>> call(NoParams params) async {
    return await _repository.fetchFilter();
  }
}
