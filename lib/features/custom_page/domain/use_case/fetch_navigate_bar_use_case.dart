import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/custom_page/domain/reposiory/custom_page_repository.dart';

import '../entity/navigate_bar_entity.dart';

class FetchNavigateBarUseCase extends UseCase<NavigateBarEntity, NoParams> {
  final CustomPageRepository _customPageRepository;

  FetchNavigateBarUseCase(this._customPageRepository);

  @override
  Future<Either<Failure, NavigateBarEntity>> call(NoParams params) async {
    return await _customPageRepository.fetchNavigateBar();
  }
}
