import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/custom_page/domain/entity/activate_entity.dart';
import 'package:fourtyninehub/features/custom_page/domain/reposiory/custom_page_repository.dart';


class FetchActivateUseCase extends UseCase<ActivateEntity, NoParams> {
  final CustomPageRepository _customPageRepository;

  FetchActivateUseCase(this._customPageRepository);

  @override
  Future<Either<Failure, ActivateEntity>> call(NoParams params) async {
    return await _customPageRepository.fetchActivate();
  }
}
