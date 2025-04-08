import 'package:dartz/dartz.dart';
import 'package:fourtyninehub/features/social_media/instagram/domain/entities/user_tag_entity.dart';
import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';
import '../repositories/social_posts_repo.dart';

class GetUserTagUseCase extends UseCase<List<UserTagEntity>, String> {
  final InstagramRepo _repo;
  GetUserTagUseCase(this._repo);
  @override
  Future<Either<Failure, List<UserTagEntity>>> call(String params) async {
    return await _repo.getUserTag(params);
  }
}
