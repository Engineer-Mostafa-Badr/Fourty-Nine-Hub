import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/social_media/create_post/domain/repositories/create_post_repo.dart';
import 'package:fourtyninehub/features/social_media/twitter/domain/entities/twitter_post_entity.dart';
import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';

class CreateTwitterPostUseCase
    extends UseCase<TwitterPostEntity, CreateTwitterPostParams> {
  final CreatePostRepo _repo;
  CreateTwitterPostUseCase(this._repo);
  @override
  Future<Either<Failure, TwitterPostEntity>> call(
      CreateTwitterPostParams params) async {
    return await _repo.createTwitterPost(params: params);
  }
}

class CreateTwitterPostParams {
  final String content;
  final List<String> mediaIds;
  CreateTwitterPostParams({
    required this.content,
    required this.mediaIds,
  });
  Map<String, dynamic> toJson() => {
        'content': content,
        'mediaIds': mediaIds,
      };
}
