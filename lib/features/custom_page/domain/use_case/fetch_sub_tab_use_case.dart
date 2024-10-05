import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/custom_page/domain/entity/social_page_entity.dart';
import 'package:fourtyninehub/features/custom_page/domain/reposiory/custom_page_repository.dart';

import '../entity/sub_tab_entity.dart';

class FetchSubTabUseCase extends UseCase<SubTabEntity, NoParams> {
  final CustomPageRepository _customPageRepository;

  FetchSubTabUseCase(this._customPageRepository);

  @override
  Future<Either<Failure, SubTabEntity>> call(NoParams params) async {
    return await _customPageRepository.fetchSubTab();
  }
}
