import 'package:dartz/dartz.dart';
import '../entities/profile_instagram_data_entity.dart';
import '../../../../../core/abstract/use_case.dart';
import '../../../../../core/error/failure.dart';
import '../repositories/social_posts_repo.dart';

class GetInstagramProfileUseCase
    extends UseCase<ProfileInstagramDataEntity, GetInstagramProfileParams> {
  final InstagramRepo _repo;
  GetInstagramProfileUseCase(this._repo);
  @override
  Future<Either<Failure, ProfileInstagramDataEntity>> call(
      GetInstagramProfileParams params) async {
    return await _repo.getInstagramProfile(params);
  }
}

class GetInstagramProfileParams {
  final String userId;
  final int page;
  final int limit;
  GetInstagramProfileParams({required this.userId, required this.page, required this.limit});
}