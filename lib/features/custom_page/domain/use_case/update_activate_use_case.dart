import 'package:dartz/dartz.dart';
import '../../../../core/abstract/use_case.dart';
import '../../../../core/error/failure.dart';

import '../reposiory/custom_page_repository.dart';

class UpdateActivateUseCase extends UseCase<bool, bool> {
  final CustomPageRepository _customPageRepository;

  UpdateActivateUseCase(this._customPageRepository);

  @override
  Future<Either<Failure, bool>> call(bool params) async {
    return await _customPageRepository.updateActivate(customPage: params);
  }
}
