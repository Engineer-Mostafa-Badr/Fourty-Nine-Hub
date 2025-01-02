import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/core/abstract/use_case.dart';
import 'package:fourtyninehub/core/error/failure.dart';

import '../reposiory/custom_page_repository.dart';

class UpdateSocialPageUseCase extends UseCase<bool, SocialPageParams> {
  final CustomPageRepository _customPageRepository;

  UpdateSocialPageUseCase(this._customPageRepository);

  @override
  Future<Either<Failure, bool>> call(SocialPageParams params) async {
    return await _customPageRepository.updateSocialPage(params);
  }
}

class SocialPageParams {
  final bool face;
  final bool insta;
  final bool tweet;

  SocialPageParams(
      {required this.face, this.insta = false, this.tweet = false});

  Map<String, dynamic> toJson() => {
        "49Face": face,
        "49Insta": insta,
        "49Tweet": tweet,

        // 'fcmToken': 'fcmToken',
      };
}
