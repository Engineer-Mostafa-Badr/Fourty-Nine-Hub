import 'package:dartz/dartz.dart';
import '../../../../core/abstract/use_case.dart';
import '../../../../core/error/failure.dart';
import '../entity/activate_entity.dart';
import '../reposiory/custom_page_repository.dart';

class FetchActivateUseCase extends UseCase<ActivateEntity, NoParams> {
  final CustomPageRepository _customPageRepository;

  FetchActivateUseCase(this._customPageRepository);

  @override
  Future<Either<Failure, ActivateEntity>> call(NoParams params) async {
    return await _customPageRepository.fetchActivate();
  }
}
