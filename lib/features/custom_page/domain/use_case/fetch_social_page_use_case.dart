import 'package:dartz/dartz.dart';
import '../../../../core/abstract/use_case.dart';
import '../../../../core/error/failure.dart';
import '../entity/social_page_entity.dart';
import '../reposiory/custom_page_repository.dart';

class FetchSocialPageUseCase extends UseCase<SocialPageEntity, NoParams> {
  final CustomPageRepository _customPageRepository;

  FetchSocialPageUseCase(this._customPageRepository);

  @override
  Future<Either<Failure, SocialPageEntity>> call(NoParams params) async {
    return await _customPageRepository.fetchSocialPage();
  }
}
