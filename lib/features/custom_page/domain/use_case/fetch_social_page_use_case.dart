import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';
import 'package:fourtyninehub/features/custom_page/domain/entity/social_page_entity.dart';
import 'package:fourtyninehub/features/custom_page/domain/reposiory/custom_page_repository.dart';

class FetchSocialPageUseCase extends UseCase<SocialPageEntity, NoParams> {
  final CustomPageRepository _customPageRepository;

  FetchSocialPageUseCase(this._customPageRepository);

  @override
  Future<Either<Failure, SocialPageEntity>> call(NoParams params) async {
    return await _customPageRepository.fetchSocialPage();
  }
}
