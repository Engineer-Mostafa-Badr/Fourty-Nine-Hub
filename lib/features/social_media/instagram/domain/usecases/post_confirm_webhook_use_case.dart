import 'package:dartz/dartz.dart';

import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';
import '../repositories/social_posts_repo.dart';

class PostConfirmWebhookUseCase
    extends UseCase<void, PostConfirmWebhookParams> {
  final InstagramRepo _repo;

  PostConfirmWebhookUseCase(this._repo);

  @override
  Future<Either<Failure, void>> call(PostConfirmWebhookParams params) async {
    return await _repo.postConfirmWebhook(params);
  }
}

class PostConfirmWebhookParams {
  final List<String> mediaIds;

  PostConfirmWebhookParams({required this.mediaIds});
}
