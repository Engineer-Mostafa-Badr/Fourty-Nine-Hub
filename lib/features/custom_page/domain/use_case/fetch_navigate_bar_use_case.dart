import 'package:dartz/dartz.dart';
import '../../../../core/abstract/use_case.dart';
import '../../../../core/error/failure.dart';
import '../reposiory/custom_page_repository.dart';

import '../entity/navigate_bar_entity.dart';

class FetchNavigateBarUseCase extends UseCase<NavigateBarEntity, NoParams> {
  final CustomPageRepository _customPageRepository;

  FetchNavigateBarUseCase(this._customPageRepository);

  @override
  Future<Either<Failure, NavigateBarEntity>> call(NoParams params) async {
    return await _customPageRepository.fetchNavigateBar();
  }
}
