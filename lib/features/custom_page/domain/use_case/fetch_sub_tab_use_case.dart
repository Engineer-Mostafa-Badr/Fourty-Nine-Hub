import 'package:dartz/dartz.dart';
import '../../../../core/abstract/use_case.dart';
import '../../../../core/error/failure.dart';
import '../reposiory/custom_page_repository.dart';

import '../entity/sub_tab_entity.dart';

class FetchSubTabUseCase extends UseCase<SubTabEntity, NoParams> {
  final CustomPageRepository _customPageRepository;

  FetchSubTabUseCase(this._customPageRepository);

  @override
  Future<Either<Failure, SubTabEntity>> call(NoParams params) async {
    return await _customPageRepository.fetchSubTab();
  }
}
